Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FEA499E4D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588329AbiAXWb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584542AbiAXWVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6332BC0424CC;
        Mon, 24 Jan 2022 12:49:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A775B80FA1;
        Mon, 24 Jan 2022 20:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED2AC340E5;
        Mon, 24 Jan 2022 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057394;
        bh=GQv7LOP06zbfKaH6OrGhewLZ8+JM8W6ZxwkO/Q4Zfm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTZm5TCGQ8TUlihVBNh/tMQoy23+2l1QITRY9tPZd3AX0xuIoD8pB8MnX8lUXNb7C
         xZHbqfxdfaC8UvPCKF9BWH2a/Yk1UtNHWrjSwPioHJr7ZByrwJLM+TfYVU4OqRR4zo
         n9xOFL9Op2gvjpImYI45mIywPE1YKmGvtLFNh7dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 799/846] net: axienet: increase default TX ring size to 128
Date:   Mon, 24 Jan 2022 19:45:16 +0100
Message-Id: <20220124184128.507976561@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 2d19c3fd80178160dd505ccd7fed1643831227a5 upstream.

With previous changes to make the driver handle the TX ring size more
correctly, the default TX ring size of 64 appears to significantly
bottleneck TX performance to around 600 Mbps on a 1 Gbps link on ZynqMP.
Increasing this to 128 seems to bring performance up to near line rate and
shouldn't cause excess bufferbloat (this driver doesn't yet support modern
byte-based queue management).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


