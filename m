Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254E7F5600
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390669AbfKHTGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391211AbfKHTGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B1E2087E;
        Fri,  8 Nov 2019 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239967;
        bh=Du/6PTSuGoZ0Qf9UkdU/yHUEIgefC9EtDGfESH88STo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFz9u37iEslZMSJANv9y5/tgsbyzkR6lnNZzo254V4cFaEXSEwZdOG4qliWbv/gCv
         kT8U4KI0vR+rLQ5aCnZkYqxq9l31GwpRpdIWKzvJNcL5O+9MXdbUPyCZPDPbxOUvxh
         iBv3YMtXPRpUy4zyLX+OGx8Ny4elpmBCTvkLmAcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soeren Moch <smoch@web.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 026/140] arm64: dts: rockchip: fix RockPro64 sdhci settings
Date:   Fri,  8 Nov 2019 19:49:14 +0100
Message-Id: <20191108174904.989259730@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

[ Upstream commit 2558b3b1b11a1b32b336be2dd0aabfa6d35ddcb5 ]

The RockPro64 schematics [1], [2] show that the rk3399 EMMC_STRB pin is
connected to the RESET pin instead of the DATA_STROBE pin of the eMMC module.
So the data strobe cannot be used for its intended purpose on this board,
and so the HS400 eMMC mode is not functional. Limit the controller to HS200.

[1] http://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf
[2] http://files.pine64.org/doc/rock64/PINE64_eMMC_Module_20170719.pdf

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Signed-off-by: Soeren Moch <smoch@web.de>
Link: https://lore.kernel.org/r/20191003215036.15023-2-smoch@web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
index cad314f708300..1ff617230f6c4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -625,8 +625,7 @@
 
 &sdhci {
 	bus-width = <8>;
-	mmc-hs400-1_8v;
-	mmc-hs400-enhanced-strobe;
+	mmc-hs200-1_8v;
 	non-removable;
 	status = "okay";
 };
-- 
2.20.1



