Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68A9497FF6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242659AbiAXMtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:49:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32876 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiAXMtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:49:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F4060EC2
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D39C340E4;
        Mon, 24 Jan 2022 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643028584;
        bh=lf3/4gCHVu43PgeqfZm+wgcLMzmXtPGPalSohDAELc4=;
        h=Subject:To:Cc:From:Date:From;
        b=IyDSZB2jevR9XgGzre7UD8uJbw5M58+AZX+V/Vc8wCZBLs8ej7/Zt7O3MpDwmBE4q
         W9DdwBrn1EkKvokZ0VjbbNMO0KmK7sh+bdE/0WA66w55zU3174k8a4DRkW7Bb4PjWt
         Iy60EPYO5D4YOKi6i/MD9s3OYCVSul/pBaJg3ByM=
Subject: FAILED: patch "[PATCH] net: axienet: increase default TX ring size to 128" failed to apply to 4.19-stable tree
To:     robert.hancock@calian.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:49:30 +0100
Message-ID: <1643028570222192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 2d19c3fd80178160dd505ccd7fed1643831227a5 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 18 Jan 2022 15:41:32 -0600
Subject: [PATCH] net: axienet: increase default TX ring size to 128

With previous changes to make the driver handle the TX ring size more
correctly, the default TX ring size of 64 appears to significantly
bottleneck TX performance to around 600 Mbps on a 1 Gbps link on ZynqMP.
Increasing this to 128 seems to bring performance up to near line rate and
shouldn't cause excess bufferbloat (this driver doesn't yet support modern
byte-based queue management).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b4f42ee9b75d..377c94ec2486 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -41,7 +41,7 @@
 #include "xilinx_axienet.h"
 
 /* Descriptors defines for Tx and Rx DMA */
-#define TX_BD_NUM_DEFAULT		64
+#define TX_BD_NUM_DEFAULT		128
 #define RX_BD_NUM_DEFAULT		1024
 #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096

