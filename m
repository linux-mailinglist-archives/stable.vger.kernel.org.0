Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EADB18B6B5
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgCSN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730772AbgCSN0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89DC20658;
        Thu, 19 Mar 2020 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624378;
        bh=ACVs9EEdSSF2EStts4WvgDFgGjqrcJok/0eJsCLUZM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9zzMw/jDUgVFBzoLcbTZYs6ZHiWZSzZzWk9gugrOfn+lrKAL6f+8O0QnQTc8sKmK
         bAykaYyw51TEZ7bVxgwVrMc6MICPaSfHmCoKauG/z1UGM1Kd+T5TFO/Kj4CmQfX5jN
         x8Kf0NvqCA0ddySjdAkG2wUMPvEQh6pkeHNlwVjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 42/65] net: phy: mscc: fix firmware paths
Date:   Thu, 19 Mar 2020 14:04:24 +0100
Message-Id: <20200319123939.770299315@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit c87a9d6fc6d555e4981f2ded77d9a8cce950743e ]

The firmware paths for the VSC8584 PHYs not not contain the leading
'microchip/' directory, as used in linux-firmware, resulting in an
error when probing the driver. This patch fixes it.

Fixes: a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index d5f8f351d9eff..3e38d15a67c64 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -310,11 +310,11 @@ enum rgmii_rx_clock_delay {
 				BIT(VSC8531_FORCE_LED_OFF) | \
 				BIT(VSC8531_FORCE_LED_ON))
 
-#define MSCC_VSC8584_REVB_INT8051_FW		"mscc_vsc8584_revb_int8051_fb48.bin"
+#define MSCC_VSC8584_REVB_INT8051_FW		"microchip/mscc_vsc8584_revb_int8051_fb48.bin"
 #define MSCC_VSC8584_REVB_INT8051_FW_START_ADDR	0xe800
 #define MSCC_VSC8584_REVB_INT8051_FW_CRC	0xfb48
 
-#define MSCC_VSC8574_REVB_INT8051_FW		"mscc_vsc8574_revb_int8051_29e8.bin"
+#define MSCC_VSC8574_REVB_INT8051_FW		"microchip/mscc_vsc8574_revb_int8051_29e8.bin"
 #define MSCC_VSC8574_REVB_INT8051_FW_START_ADDR	0x4000
 #define MSCC_VSC8574_REVB_INT8051_FW_CRC	0x29e8
 
-- 
2.20.1



