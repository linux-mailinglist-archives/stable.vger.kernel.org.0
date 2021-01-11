Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13F2F1462
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbhAKNYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732663AbhAKNRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B271D2246B;
        Mon, 11 Jan 2021 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371045;
        bh=ZC8biu2rBnDrTjnIWiaDeoITdh+U0ptR2jeWui5ivvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf014tLUb5JzG4yAKlgXA7DpmXpB0KbjnqPzs/MUv9aV/3QPrwiiig+NKp+zEtHgb
         o7XU+69Zks4jPzo5EmAdoc5SdC//h1QnpFl0MZ4y4yw3n9bejwSfbMbCbD1o2L8V1R
         FcfOsLXnslsOsUOUYqAm6JbJzvJbyQg9NAogJvv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jonathan Lemon <bsd@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 117/145] blk-iocost: fix NULL iocg deref from racing against initialization
Date:   Mon, 11 Jan 2021 14:02:21 +0100
Message-Id: <20210111130054.150102299@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit d16baa3f1453c14d680c5fee01cd122a22d0e0ce upstream.

When initializing iocost for a queue, its rqos should be registered before
the blkcg policy is activated to allow policy data initiailization to lookup
the associated ioc. This unfortunately means that the rqos methods can be
called on bios before iocgs are attached to all existing blkgs.

While the race is theoretically possible on ioc_rqos_throttle(), it mostly
happened in ioc_rqos_merge() due to the difference in how they lookup ioc.
The former determines it from the passed in @rqos and then bails before
dereferencing iocg if the looked up ioc is disabled, which most likely is
the case if initialization is still in progress. The latter looked up ioc by
dereferencing the possibly NULL iocg making it a lot more prone to actually
triggering the bug.

* Make ioc_rqos_merge() use the same method as ioc_rqos_throttle() to look
  up ioc for consistency.

* Make ioc_rqos_throttle() and ioc_rqos_merge() test for NULL iocg before
  dereferencing it.

* Explain the danger of NULL iocgs in blk_iocost_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jonathan Lemon <bsd@fb.com>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iocost.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2525,8 +2525,8 @@ static void ioc_rqos_throttle(struct rq_
 	bool use_debt, ioc_locked;
 	unsigned long flags;
 
-	/* bypass IOs if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass IOs if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	/* calculate the absolute vtime cost */
@@ -2653,14 +2653,14 @@ static void ioc_rqos_merge(struct rq_qos
 			   struct bio *bio)
 {
 	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
-	struct ioc *ioc = iocg->ioc;
+	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
 	u64 vtime, abs_cost, cost;
 	unsigned long flags;
 
-	/* bypass if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	abs_cost = calc_vtime_cost(bio, iocg, true);
@@ -2837,6 +2837,12 @@ static int blk_iocost_init(struct reques
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	/*
+	 * rqos must be added before activation to allow iocg_pd_init() to
+	 * lookup the ioc from q. This means that the rqos methods may get
+	 * called before policy activation completion, can't assume that the
+	 * target bio has an iocg associated and need to test for NULL iocg.
+	 */
 	rq_qos_add(q, rqos);
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
 	if (ret) {


