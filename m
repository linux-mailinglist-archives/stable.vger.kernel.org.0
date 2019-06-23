Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD144FC86
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFWP66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 11:58:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35251 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFWP65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 11:58:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 835072211E;
        Sun, 23 Jun 2019 11:58:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 11:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iqSbLD
        9GX3700w9thFHHOBIfEL3hg1agw9JLVUL2gP0=; b=KSAqDQ4ozU9HYILzDJhT/w
        mBeGsRkw9s4ue0umVTZY4N4C0DE7YLflFbpyHkOQ/ZdG34BxiWwSXdvzJ/5a1B8m
        dYO66P4nZmKmAMAN7d7VVaz7Zo06sAL5mQS+3IsqHwlY7ilTwiz0by+8AQ63Zyrz
        74ugcJCYvLcHCFX5upM6j/iKHifiuaJ7rfQZGZ0jsdTvlDzhOZvIgJmN2Xl79fKM
        qLePVgSox7JWM49ByQYwPtv4czpP8Yqkd6U4FqHigPKb7CwovZpYkglrmZTAegae
        1EKwEWvlstA+imOt7/mkT7XrCLzyiAVfd9yDCe4ell/0sZocTrzUE6G8guNmMLGA
        ==
X-ME-Sender: <xms:wKEPXc-flvAY4xrpMVElgzVzynOKGKxWUC9MngVWPDEenCKNlu4baw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudeliedrvddvtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:wKEPXS81_m_V8GevwyCGYR65JlGDHk33t5-Tt_RQMQQZLyTgEnfdpg>
    <xmx:wKEPXbLWIXtJpjYCH0ckZjwO6gv8ESVGnkAhMYrde9y18m7ITupsxg>
    <xmx:wKEPXdp_-anlFn0uKPWoNULAEYdB4XHaNSWDdtetC7n17NHPEiZ_XQ>
    <xmx:wKEPXWoQGpA5yF7UMi9IDnh0bd1nNpzv-nujo7Di6vRjbybHWRwjEw>
Received: from localhost (unknown [84.241.196.220])
        by mail.messagingengine.com (Postfix) with ESMTPA id B36DE8005B;
        Sun, 23 Jun 2019 11:58:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock" failed to apply to 4.19-stable tree
To:     mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        dledford@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 17:58:52 +0200
Message-ID: <156130553241116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cf131a81967583ae737df6383a0893b9fee75b4e Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Date: Fri, 14 Jun 2019 12:32:26 -0400
Subject: [PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock

Heavy contention of the sde flushlist_lock can cause hard lockups at
extreme scale when the flushing logic is under stress.

Mitigate by replacing the item at a time copy to the local list with
an O(1) list_splice_init() and using the high priority work queue to
do the flushes.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index b0110728f541..70828de7436b 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -410,10 +410,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	sdma_flush_descq(sde);
 	spin_lock_irqsave(&sde->flushlist_lock, flags);
 	/* copy flush list */
-	list_for_each_entry_safe(txp, txp_next, &sde->flushlist, list) {
-		list_del_init(&txp->list);
-		list_add_tail(&txp->list, &flushlist);
-	}
+	list_splice_init(&sde->flushlist, &flushlist);
 	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
@@ -2413,7 +2410,7 @@ int sdma_send_txreq(struct sdma_engine *sde,
 	list_add_tail(&tx->list, &sde->flushlist);
 	spin_unlock(&sde->flushlist_lock);
 	iowait_inc_wait_count(wait, tx->num_desc);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto unlock;
 nodesc:
@@ -2511,7 +2508,7 @@ int sdma_send_txlist(struct sdma_engine *sde, struct iowait_work *wait,
 		iowait_inc_wait_count(wait, tx->num_desc);
 	}
 	spin_unlock(&sde->flushlist_lock);
-	schedule_work(&sde->flush_worker);
+	queue_work_on(sde->cpu, system_highpri_wq, &sde->flush_worker);
 	ret = -ECOMM;
 	goto update_tail;
 nodesc:

