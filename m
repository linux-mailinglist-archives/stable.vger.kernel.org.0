Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B1637B928
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELJaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:30:03 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41045 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELJaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:30:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4D3AF1393;
        Wed, 12 May 2021 05:28:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Lg/c2P
        Qo6KBTJLr4glwGmPGQd9yKWt9A8aG5Wo6wPL8=; b=mSHgsRRinS2bcGbbspr1L0
        hdJSNwWifWDJQJPj8UcrvmbQBvymhflt04SSPhzVal7/hCICzmwZQB5K17+xg+Il
        XHWoAC7HdKM55oMBTCBHIbtwwoTrWqVdN27wFWjjW8hvBL2qBuxeDQhInnjHW3B9
        Vj/FZpLxheE1vH51oWZUNeV8SajUQZS/pcdllYOv/WkE+5fNJwWeQSLnoaLzyaoi
        OykFDHISGoGZ2VnpFEGFuefZfErV9Y7saaL4+11YzSEoVD4GeZMxR3p8NcAfiEac
        eJb8tM2kEp9dyHjsLNzjDhuO84c4s74oVgpAQW22O45EKDpJAtWh5Vlc+W/BhTng
        ==
X-ME-Sender: <xms:1Z-bYNW2z5w_Xd4wlbuYMRS_tGlOnG8TUGI8biS7ra_cY8CZax7hdQ>
    <xme:1Z-bYNlSBu1TfFD5Mugw2VVvkz1mWoM4OnBJBh4TPeO6MPf6apT5DgMAH41fMhF8j
    4Ugd5_FOo0BXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:1Z-bYJaUjB9hmVDu8m1qC295lbbc3YAOnZnA0jeBbRD0A2NzD6xYGg>
    <xmx:1Z-bYAV0hQ8RoYvfm-F8SFlmu8gw86gMo09vKrRqoq1U_Txj9SxlWQ>
    <xmx:1Z-bYHmo7gj4lwB92HY2YAHZRwF-hXyjsAfdWJAtd4TJBeXLomhSIw>
    <xmx:1Z-bYNSnZqtl1uThlD1y5h0_c6ENXz8U0oipARpDjiA7Je9SvmArNISCc5U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mt76: fix potential DMA mapping leak" failed to apply to 5.10-stable tree
To:     nbd@nbd.name
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:52 +0200
Message-ID: <162081173220670@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b4403cee6400c5f679e9c4a82b91d61aa961eccf Mon Sep 17 00:00:00 2001
From: Felix Fietkau <nbd@nbd.name>
Date: Tue, 23 Mar 2021 22:47:37 +0100
Subject: [PATCH] mt76: fix potential DMA mapping leak

With buf uninitialized in mt76_dma_tx_queue_skb_raw, its field skip_unmap
could potentially inherit a non-zero value from stack garbage.
If this happens, it will cause DMA mappings for MCU command frames to not be
unmapped after completion

Fixes: 27d5c528a7ca ("mt76: fix double DMA unmap of the first buffer on 7615/7915")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index b87b46538b95..6ea58aecca41 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -318,7 +318,7 @@ static int
 mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, u32 tx_info)
 {
-	struct mt76_queue_buf buf;
+	struct mt76_queue_buf buf = {};
 	dma_addr_t addr;
 
 	if (q->queued + 1 >= q->ndesc - 1)

