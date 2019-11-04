Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFDAEDBBA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKDJfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:35:42 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50965 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728321AbfKDJfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:35:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 85C5322023;
        Mon,  4 Nov 2019 04:35:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 04:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QFZl2r
        obajjIQ4IA0j1kPU1DL9I5RVMESrVFu/UKesU=; b=TTTawVmeghQyF08dhnNkzo
        EknzBVmvpaRL2e8j9jw/YvU0RPLWxSEmYmmgfQaTRZIUEgsYJowE7Av1KLSqX8zA
        apacE2LU3MgLBhir86R6/SoC10et0Oya+gMRQmN4ZOOh8I2lvMuDoz3GSs0owwv1
        c7k1znIwFuMq8xQXgPgHoHut9oPz4E7Dm8Kr4jETW/GjYxMGOVWNxCzL9/NyuAey
        LRehXsO3l+huImlg1IEyYDCH3qpzFKvlwAgfsVg8ejUEWs60hfidjbYpIsoyO8Uh
        J6a6mgcfrACWoVH+oh6csTRJVZHdw7cRzSGCAIf14/lJr3dcS3FHTKhFqEs1v+EA
        ==
X-ME-Sender: <xms:7fC_XY4KKMR5m_pvFQI72nAwa2bhO0s8sWiin1fUDIw9boSudvj0mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:7fC_XeIHlf4CpAKqMX8Y_XoGiBg8elqCa0XF3ifRSpCEt3JM-AwFhg>
    <xmx:7fC_XSdUjEwoe5BR1TvzaZ7i7czg8BtSt-uS5fOZj7-8MBlndMbY2g>
    <xmx:7fC_XRfoTSDLtnmosDdpfw7YCeDhU1XAEvcacBeWx0y56h0f8l_1-g>
    <xmx:7fC_Xc-iKVxyOp7UaMJjsgDa97Q9Bp3c2SBwiNG_F3rugjfwGxzLRQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21A47306005E;
        Mon,  4 Nov 2019 04:35:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: Fix resource leak" failed to apply to 4.4-stable tree
To:     jeffrey.l.hugo@gmail.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 10:35:27 +0100
Message-ID: <1572860127152108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

