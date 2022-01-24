Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082AF499FDA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842246AbiAXXBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579821AbiAXWnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:43:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84ADC05A1B4;
        Mon, 24 Jan 2022 11:39:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D592B810BD;
        Mon, 24 Jan 2022 19:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA0AC340E5;
        Mon, 24 Jan 2022 19:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053165;
        bh=GQv7LOP06zbfKaH6OrGhewLZ8+JM8W6ZxwkO/Q4Zfm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDwG35NSccQJbJ/soHUtOJLEu3Hl+fgWorfiMMephf2a1MUcwQ0aXBVhMVp0ZGAtz
         0pjcOOoNLm+Fw+BZaM68D48xx/B2MqYUqxBpNdGsUwjZk+aYewzd57UarKvbc2RUp8
         OBWDsIo13xG8dC0sh4Y4Vhzz5CPfcYeSKjaf1PZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 297/320] net: axienet: increase default TX ring size to 128
Date:   Mon, 24 Jan 2022 19:44:41 +0100
Message-Id: <20220124184004.051571050@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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


