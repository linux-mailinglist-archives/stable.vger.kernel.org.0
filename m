Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7679E428F32
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhJKNzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235235AbhJKNx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D8C60F6E;
        Mon, 11 Oct 2021 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960319;
        bh=J1bevgMjOGZSt9baN1ki61/2AfSBoET06mjlkdzidVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axqpZ8YrSCAvsfCjYF2FfR+ehnlGPassEQcQVI+r/H707P6jiQ2Xvxx/2RFzIbc5w
         vpg3v+jOfj2bWaTUrAWKBYZg9KjdyN2uBXw4IvSm5qHXNrYzSdmLvv2GntUEokHy/l
         Iqa3KV67M9rwDn7U5FrmmiuWeHFZZ7DbJymAuYw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/83] ARM: dts: imx: Fix USB host power regulator polarity on M53Menlo
Date:   Mon, 11 Oct 2021 15:45:47 +0200
Message-Id: <20211011134509.300278126@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 5c187e2eb3f92daa38cb3d4ab45e1107ea34108e ]

The MIC2025 switch input signal nEN is active low, describe it as such
in the DT. The previous change to this regulator polarity was incorrectly
influenced by broken quirks in gpiolib-of.c, which is now long fixed. So
fix this regulator polarity setting here once and for all.

Fixes: 3c3601cd6a6d3 ("ARM: dts: imx53: Update USB configuration on M53Menlo")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-m53menlo.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-m53menlo.dts b/arch/arm/boot/dts/imx53-m53menlo.dts
index 48adcfd32cea..4f88e96d81dd 100644
--- a/arch/arm/boot/dts/imx53-m53menlo.dts
+++ b/arch/arm/boot/dts/imx53-m53menlo.dts
@@ -77,8 +77,7 @@
 		regulator-name = "vbus";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
-		gpio = <&gpio1 2 GPIO_ACTIVE_HIGH>;
-		enable-active-high;
+		gpio = <&gpio1 2 0>;
 	};
 };
 
-- 
2.33.0



