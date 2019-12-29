Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC24512C326
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfL2Pql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:41 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36997 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pql (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3BC1542B;
        Sun, 29 Dec 2019 10:46:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0Z94J1
        30uvfdtIH8CPTfWiivJfIv25BN0iie1YHnQ/M=; b=LB6+ecM4vAAyjsk0cvYYyg
        N3RNfINti+g0zFpDZ9qGdnkc1hU3YzmrmQisTAni8cETGSoJ84VuyO250xXW/4n0
        SJw+i0gk2srYx39CDC6xf427iVNopb5v8hnUXASRsXLAHI5p8Qudu2dgn/UVOQkZ
        bZGUY7bqy85h36oE9i7Js+qGdDbe+BN0HZuPfyWvSSy3RvtfByrgeoBNAw/IcilE
        pguHYCE7JmxDnCapU8Z5PqgHixK+sYnCrX6xY6jw3a/riHzgjGJ82nEnaO9NsX/R
        Y8f4WwDI/vRnce72zGWm1T3r1ZSaX6hPampEUYJMpPSSRdsI6qoXn5LKw8xih8NA
        ==
X-ME-Sender: <xms:X8oIXp89ENwENS-LR5NfVAxOmL7v_jESc91EbbRAwR0OrrPHOhk_JA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:X8oIXlIOraw7nXcA6tnbsDMW7RkYGi-8JNXT8DfP5sOFRKUj8SgCFA>
    <xmx:X8oIXkbNooSxdLkYSkTt2rVzP4T6I2tma3nLFuQavnE2cRxsOeDjUQ>
    <xmx:X8oIXnLOEJcSqckaDB8WtcVZQZq5CPQubMF-XjIsQOgxMLKtcSNcvg>
    <xmx:X8oIXmnB8WoPbPB74Tt3H3dcs8hWa-biUhtgzAQb7Lud5wqw10b9NA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64D1780059;
        Sun, 29 Dec 2019 10:46:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] serial: sprd: Add clearing break interrupt operation" failed to apply to 4.4-stable tree
To:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:46:29 +0100
Message-ID: <15776343899936@kroah.com>
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

From abeb2e9414d7e3a0d8417bc3b13d7172513ea8a0 Mon Sep 17 00:00:00 2001
From: Yonghan Ye <yonghan.ye@unisoc.com>
Date: Wed, 4 Dec 2019 20:00:07 +0800
Subject: [PATCH] serial: sprd: Add clearing break interrupt operation

A break interrupt will be generated if the RX line was pulled low, which
means some abnomal behaviors occurred of the UART. In this case, we still
need to clear this break interrupt status, otherwise it will cause irq
storm to crash the whole system.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Yonghan Ye <yonghan.ye@unisoc.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/925e51b73099c90158e080b8f5bed9b3b38c4548.1575460601.git.baolin.wang7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 31df23502562..f60a59d9bf27 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -679,6 +679,9 @@ static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
 	if (ims & SPRD_IMSR_TIMEOUT)
 		serial_out(port, SPRD_ICLR, SPRD_ICLR_TIMEOUT);
 
+	if (ims & SPRD_IMSR_BREAK_DETECT)
+		serial_out(port, SPRD_ICLR, SPRD_IMSR_BREAK_DETECT);
+
 	if (ims & (SPRD_IMSR_RX_FIFO_FULL | SPRD_IMSR_BREAK_DETECT |
 		   SPRD_IMSR_TIMEOUT))
 		sprd_rx(port);

