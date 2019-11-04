Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C25EDBB6
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfKDJfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:35:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47685 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727236AbfKDJf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:35:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 90F0621EBC;
        Mon,  4 Nov 2019 04:35:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 04:35:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gklXwO
        AB7a+8QTqOsPSz8tX+AiAzhNqifWk4yeaxvc4=; b=de0mvIq/O1mwBEg44EVTSt
        Ol8InMUaUrBHTdrkPgSqe1L9COfl1/TRdYk5mHFqQkxgJ7xlvOMvJjaiyo3ckLGz
        sZSMAKMwGzENE2LDgizPqzKXBEnfMGoJZSEb0xb3jbaCKUl/ZSNKpiSGqtjWagAK
        x0lVAjHb1VhFswUubbDs2cNc/ZmKau44URZA3gixqn4oAlmzdV3EzZ7odTJAv+Z8
        xXoL2idjbiU79JNPtFQNKeq7HiJ6PEkh4D2AcfOxBGMRCpzt+tnz33+dtcabC8ku
        Jh9AlpdlFDePGLrnqS8eY4tK/5QNi0KzGgrYxNKKIysJ3IH4FgkGKdILIHxMYRvA
        ==
X-ME-Sender: <xms:4PC_Xb2dhh-kZWptZ7Cwh3sAqNAEEBOw7rN2_oOUUxTyJmQrDOUSoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4PC_XRP-4dvzD0nLU0vW05sXuAt-2wQe-qE4_WgS8PlWaJIltcEsOQ>
    <xmx:4PC_XeMWmiDwKe3a1jbzia7WrZamvHB3LAJOMJr4Qbs85AKddpPJCw>
    <xmx:4PC_XZlTsd4UGSlWekwEpYWmRTp85XhEAJtD2CnYR4rvlKkOYJp0RA>
    <xmx:4PC_XfqzmmX155rCS_OF_gw2p9W4EK8xfypl1pY7-A1ydJ4fASePgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CC2B80061;
        Mon,  4 Nov 2019 04:35:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: Fix resource leak" failed to apply to 4.14-stable tree
To:     jeffrey.l.hugo@gmail.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 10:35:26 +0100
Message-ID: <15728601263783@kroah.com>
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

From 7667819385457b4aeb5fac94f67f52ab52cc10d5 Mon Sep 17 00:00:00 2001
From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date: Thu, 17 Oct 2019 08:26:06 -0700
Subject: [PATCH] dmaengine: qcom: bam_dma: Fix resource leak

bam_dma_terminate_all() will leak resources if any of the transactions are
committed to the hardware (present in the desc fifo), and not complete.
Since bam_dma_terminate_all() does not cause the hardware to be updated,
the hardware will still operate on any previously committed transactions.
This can cause memory corruption if the memory for the transaction has been
reassigned, and will cause a sync issue between the BAM and its client(s).

Fix this by properly updating the hardware in bam_dma_terminate_all().

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8e90a405939d..ef73f65224b1 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -694,6 +694,25 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 
 	/* remove all transactions, including active transaction */
 	spin_lock_irqsave(&bchan->vc.lock, flag);
+	/*
+	 * If we have transactions queued, then some might be committed to the
+	 * hardware in the desc fifo.  The only way to reset the desc fifo is
+	 * to do a hardware reset (either by pipe or the entire block).
+	 * bam_chan_init_hw() will trigger a pipe reset, and also reinit the
+	 * pipe.  If the pipe is left disabled (default state after pipe reset)
+	 * and is accessed by a connected hardware engine, a fatal error in
+	 * the BAM will occur.  There is a small window where this could happen
+	 * with bam_chan_init_hw(), but it is assumed that the caller has
+	 * stopped activity on any attached hardware engine.  Make sure to do
+	 * this first so that the BAM hardware doesn't cause memory corruption
+	 * by accessing freed resources.
+	 */
+	if (!list_empty(&bchan->desc_list)) {
+		async_desc = list_first_entry(&bchan->desc_list,
+					      struct bam_async_desc, desc_node);
+		bam_chan_init_hw(bchan, async_desc->dir);
+	}
+
 	list_for_each_entry_safe(async_desc, tmp,
 				 &bchan->desc_list, desc_node) {
 		list_add(&async_desc->vd.node, &bchan->vc.desc_issued);

