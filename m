Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF71A3FDB7F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbhIAMl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345022AbhIAMkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 061E5611AD;
        Wed,  1 Sep 2021 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499797;
        bh=7tbVTn4xSds3qmU1rNabZ45Hm3sMmMXSWEqLze0MOR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aZrDlZcdS1v908k6VGRcn2ol/LDf+bekO+cLPueWZ9RaBmb9rRGBShrr6UGAvXyu
         jnOoiSf/LpwhwEfti/QCuACuMkIqZ6q7DwVyVMYNHLALrMWzNZt5qoRvRlhPrdkl5T
         7c0qhqTDJKnGunoD2y4BGYw+VOSFhfYule6xZ6ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 089/103] srcu: Make Tiny SRCU use multi-bit grace-period counter
Date:   Wed,  1 Sep 2021 14:28:39 +0200
Message-Id: <20210901122303.534998185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 74612a07b83fc46c2b2e6f71a541d55b024ebefc upstream.

There is a need for a polling interface for SRCU grace periods.  This
polling needs to distinguish between an SRCU instance being idle on the
one hand or in the middle of a grace period on the other.  This commit
therefore converts the Tiny SRCU srcu_struct structure's srcu_idx from
a defacto boolean to a free-running counter, using the bottom bit to
indicate that a grace period is in progress.  The second-from-bottom
bit is thus used as the index returned by srcu_read_lock().

Link: https://lore.kernel.org/rcu/20201112201547.GF3365678@moria.home.lan/
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
[ paulmck: Fix ->srcu_lock_nesting[] indexing per Neeraj Upadhyay. ]
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/srcutiny.h |    6 +++---
 kernel/rcu/srcutiny.c    |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -15,7 +15,7 @@
 
 struct srcu_struct {
 	short srcu_lock_nesting[2];	/* srcu_read_lock() nesting depth. */
-	short srcu_idx;			/* Current reader array element. */
+	unsigned short srcu_idx;	/* Current reader array element in bit 0x2. */
 	u8 srcu_gp_running;		/* GP workqueue running? */
 	u8 srcu_gp_waiting;		/* GP waiting for readers? */
 	struct swait_queue_head srcu_wq;
@@ -59,7 +59,7 @@ static inline int __srcu_read_lock(struc
 {
 	int idx;
 
-	idx = READ_ONCE(ssp->srcu_idx);
+	idx = ((READ_ONCE(ssp->srcu_idx) + 1) & 0x2) >> 1;
 	WRITE_ONCE(ssp->srcu_lock_nesting[idx], ssp->srcu_lock_nesting[idx] + 1);
 	return idx;
 }
@@ -80,7 +80,7 @@ static inline void srcu_torture_stats_pr
 {
 	int idx;
 
-	idx = READ_ONCE(ssp->srcu_idx) & 0x1;
+	idx = ((READ_ONCE(ssp->srcu_idx) + 1) & 0x2) >> 1;
 	pr_alert("%s%s Tiny SRCU per-CPU(idx=%d): (%hd,%hd)\n",
 		 tt, tf, idx,
 		 READ_ONCE(ssp->srcu_lock_nesting[!idx]),
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -124,11 +124,12 @@ void srcu_drive_gp(struct work_struct *w
 	ssp->srcu_cb_head = NULL;
 	ssp->srcu_cb_tail = &ssp->srcu_cb_head;
 	local_irq_enable();
-	idx = ssp->srcu_idx;
-	WRITE_ONCE(ssp->srcu_idx, !ssp->srcu_idx);
+	idx = (ssp->srcu_idx & 0x2) / 2;
+	WRITE_ONCE(ssp->srcu_idx, ssp->srcu_idx + 1);
 	WRITE_ONCE(ssp->srcu_gp_waiting, true);  /* srcu_read_unlock() wakes! */
 	swait_event_exclusive(ssp->srcu_wq, !READ_ONCE(ssp->srcu_lock_nesting[idx]));
 	WRITE_ONCE(ssp->srcu_gp_waiting, false); /* srcu_read_unlock() cheap. */
+	WRITE_ONCE(ssp->srcu_idx, ssp->srcu_idx + 1);
 
 	/* Invoke the callbacks we removed above. */
 	while (lh) {


