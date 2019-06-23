Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78534FC88
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 17:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFWP7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 11:59:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33179 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFWP7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 11:59:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5321622110;
        Sun, 23 Jun 2019 11:59:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 11:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CVRfZh
        +q49GzqkFXlcnI5x6EWemlQlhe2g3u+J35uXk=; b=mnTvZiI5Yc4Y2xq/8ttRhi
        RB+Ke+BybdKA6DnZHzs2wHQPrTimfPrJKp78wPJvo6DuTEJbuO+eMUBkaDX6J/4B
        rr0RLJXEvmLLmc9tlVl19rr6dCaKVBEAs7WamhMB4iYKFUOfvAoD3U7g4Uutnb1G
        eYZ2XsvJREGSJob+6DNlAta3q1lGJTmD4gVTQnEWFFqIZ3i7Af81P+g+x3DQCGAL
        ki2zMM8d8ShSvTlmkLdL3riCturAtnJDLfV2V/QTEG4D2STql+PsBwQXPbZ6j168
        WsvtnWMgPYp5MkZyvC4HV4plaNwg66t/9tbHPrbgm5/Coqgtv04XzYIepd7PEcmQ
        ==
X-ME-Sender: <xms:zKEPXfb7-QJxzRlMg55Gdjm7NS51naY-uVSp6cNmd1TqAfLyvrZ2-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudeliedrvddvtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:zKEPXbPy_p-vEv_KldCiEUDyyTQy0Ty3VxpRShIoZb5fThPBKNUScw>
    <xmx:zKEPXc0MRsk_Y4veBVS7M4QMUtGqBsIP2fC229vbYwFSC9jyltWpBw>
    <xmx:zKEPXQjD4mMi5tXiSpk4uI9RkkVqzX9QNlrYi8S9JB0cfen0V8K9BA>
    <xmx:zKEPXYU05AOtJAHunMhatX80AW0Jfu_LpByi-Mg6VFHN3wuFGhxiXg>
Received: from localhost (unknown [84.241.196.220])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9690B8005A;
        Sun, 23 Jun 2019 11:59:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock" failed to apply to 4.9-stable tree
To:     mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        dledford@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 17:58:54 +0200
Message-ID: <156130553466146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

