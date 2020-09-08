Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D132261B6F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgIHTDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgIHQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:07:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6575E23E26;
        Tue,  8 Sep 2020 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580028;
        bh=bmQdkNH3AtKy4aJrZ0hiO2G1mnDDEJjfOONUdQ49HW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXMZs8fnm/ai3Eub59ODnLGc6FvEGfThXGFRqzEVPgXvS6xBr8vstD82wNsrmItCA
         qsqyr+MPl6ImnJCZiiaeAMEkOUClB0fz1r50OKup/RtiOFR2xCY+FyHSdJXs6aMg77
         O67hVln+oGa6ZYSDBqDP2J4HLYcilG3f87GekqRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 110/129] blk-iocost: ioc_pd_free() shouldnt assume irq disabled
Date:   Tue,  8 Sep 2020 17:25:51 +0200
Message-Id: <20200908152235.335513954@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 5aeac7c4b16069aae49005f0a8d4526baa83341b upstream.

ioc_pd_free() grabs irq-safe ioc->lock without ensuring that irq is disabled
when it can be called with irq disabled or enabled. This has a small chance
of causing A-A deadlocks and triggers lockdep splats. Use irqsave operations
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-iocost.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2074,14 +2074,15 @@ static void ioc_pd_free(struct blkg_poli
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
 
 	if (ioc) {
-		spin_lock(&ioc->lock);
+		spin_lock_irqsave(&ioc->lock, flags);
 		if (!list_empty(&iocg->active_list)) {
 			propagate_active_weight(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
-		spin_unlock(&ioc->lock);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		hrtimer_cancel(&iocg->waitq_timer);
 		hrtimer_cancel(&iocg->delay_timer);


