Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FE735BE49
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237537AbhDLI5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239024AbhDLIzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BDE161207;
        Mon, 12 Apr 2021 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217699;
        bh=jgcchRaluWdfefFgcWzhdgFzO/l9Na4FFH4ScjZaTZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nefSCE6J1DF02MAL2Lil/XQQa0Vgm0ENQVV45rTYvpc1sSpG9IYJUxWPVByw+7lHe
         LByr/IK3eFXOapCCpCceHSjUBwJTtIbOWT9vHn9WFCYat8pwp5XTVcGYtEfdTII+af
         wS0F3fn2M3uqrCs9qDQTqrAKoabp2nUgw5PMMNGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Oliver=20St=C3=A4bler?= <oliver.staebler@bytesatwork.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/188] arm64: dts: imx8mm/q: Fix pad control of SD1_DATA0
Date:   Mon, 12 Apr 2021 10:40:28 +0200
Message-Id: <20210412084017.445069592@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Stäbler <oliver.staebler@bytesatwork.ch>

[ Upstream commit 5cfad4f45806f6f898b63b8c77cea7452c704cb3 ]

Fix address of the pad control register
(IOMUXC_SW_PAD_CTL_PAD_SD1_DATA0) for SD1_DATA0_GPIO2_IO2.  This seems
to be a typo but it leads to an exception when pinctrl is applied due to
wrong memory address access.

Signed-off-by: Oliver Stäbler <oliver.staebler@bytesatwork.ch>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Fixes: c1c9d41319c3 ("dt-bindings: imx: Add pinctrl binding doc for imx8mm")
Fixes: 748f908cc882 ("arm64: add basic DTS for i.MX8MQ")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
index 5ccc4cc91959..a003e6af3353 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
@@ -124,7 +124,7 @@
 #define MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD                                     0x0A4 0x30C 0x000 0x0 0x0
 #define MX8MM_IOMUXC_SD1_CMD_GPIO2_IO1                                      0x0A4 0x30C 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0                                 0x0A8 0x310 0x000 0x0 0x0
-#define MX8MM_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x31  0x000 0x5 0x0
+#define MX8MM_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x310 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1                                 0x0AC 0x314 0x000 0x0 0x0
 #define MX8MM_IOMUXC_SD1_DATA1_GPIO2_IO3                                    0x0AC 0x314 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2                                 0x0B0 0x318 0x000 0x0 0x0
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h
index b94b02080a34..68e8fa172974 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h
@@ -130,7 +130,7 @@
 #define MX8MQ_IOMUXC_SD1_CMD_USDHC1_CMD                                     0x0A4 0x30C 0x000 0x0 0x0
 #define MX8MQ_IOMUXC_SD1_CMD_GPIO2_IO1                                      0x0A4 0x30C 0x000 0x5 0x0
 #define MX8MQ_IOMUXC_SD1_DATA0_USDHC1_DATA0                                 0x0A8 0x310 0x000 0x0 0x0
-#define MX8MQ_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x31  0x000 0x5 0x0
+#define MX8MQ_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x310 0x000 0x5 0x0
 #define MX8MQ_IOMUXC_SD1_DATA1_USDHC1_DATA1                                 0x0AC 0x314 0x000 0x0 0x0
 #define MX8MQ_IOMUXC_SD1_DATA1_GPIO2_IO3                                    0x0AC 0x314 0x000 0x5 0x0
 #define MX8MQ_IOMUXC_SD1_DATA2_USDHC1_DATA2                                 0x0B0 0x318 0x000 0x0 0x0
-- 
2.30.2



