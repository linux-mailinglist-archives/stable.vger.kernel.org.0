Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536164FC87
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfFWP7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 11:59:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55917 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFWP7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 11:59:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1567C220CB;
        Sun, 23 Jun 2019 11:59:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 11:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DUcz4d
        yKg1IIzHDMlFUodu95YHyDtnDeNs2XTfZS6s4=; b=yIWCIIIm2Q9G+Q1M3ROyTM
        o5S/xq34EBuiDa8FZBAbC8gWFDU3K6KJziJ0AmSwieXXOJtLfVgty/CZCqYX9noE
        3VoOqNVYgz/TFji+xX59ss36pvuWnr3EVGqNF2wfTv3XmiEQds2+De9J0na1U+QR
        dZZiZcJiyC6SYy2kXuD9d/vpcwKZdu7VRqBZ2aUaPj84ogyN2H3V1ZkPLsjAyeP6
        39Lt1RKGj4TGKdSJnj6spJQaBAbUsgFcWK0MLJ75NJHxjbaO68O1mkJkCYaPf+AJ
        M6T2utxqxPvlB5qATrySwRxj+VkTMrfH9CapDP6Eoom7S27bj2p3WqpW8P2Ex2mQ
        ==
X-ME-Sender: <xms:yKEPXcQ6C2vBxlx3fu-3NkI35c_xw_pBv_I3c9gMRv4jkTmZVEey7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudeliedrvddvtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:yKEPXcs7Rd8frIKxg1Y2XyX3QP8laZaCaoFY0QwdVDHkQu1bHYPFOg>
    <xmx:yKEPXSAsH8rN8u7inqPsUM04saN2cThjsX2SGHDwolQNNT9u33wo6Q>
    <xmx:yKEPXe0tZBsSAlNTCC0tLxCMjypM_oXF8Inz1uOf5uPuVI11W4QROw>
    <xmx:yaEPXaoljh5oInHyIagsjBWMEpm_dxuI208TPxvDI1L5rU8pxER46w>
Received: from localhost (unknown [84.241.196.220])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5282D380074;
        Sun, 23 Jun 2019 11:59:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock" failed to apply to 4.14-stable tree
To:     mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        dledford@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 17:58:53 +0200
Message-ID: <1561305533232244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

