Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4402140E7E6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345039AbhIPRgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348509AbhIPRc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2569663211;
        Thu, 16 Sep 2021 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810876;
        bh=eH78ZO8br28WU6kJd750zNC7axdeaw4weOlZh2QrV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omzQjxBKenOEVtDANtxpBRnWgzty3qYvPwn82pPL0wxiTq1RUC/uSaWm0fFX1NXGT
         9jeYiGa/Ovuxh3afKi2tCTFXcj9nRWXh1Ztn726UYRg/IctW334hkP7lSYFMulGkIy
         7YUxKKzSl1x9kwRXPPiXmSI/ufP+nX3CEQjtRZbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 299/432] ARM: tegra: tamonten: Fix UART pad setting
Date:   Thu, 16 Sep 2021 18:00:48 +0200
Message-Id: <20210916155820.961819041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>

[ Upstream commit 2270ad2f4e123336af685ecedd1618701cb4ca1e ]

This patch fixes the tristate and pullup configuration for UART 1 to 3
on the Tamonten SOM.

Signed-off-by: Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 95e6bccdb4f6..dd4d506683de 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -185,8 +185,9 @@ conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
 					"cdev1", "cdev2", "dap1", "dtb", "gma",
 					"gmb", "gmc", "gmd", "gme", "gpu7",
-					"gpv", "i2cp", "pta", "rm", "slxa",
-					"slxk", "spia", "spib", "uac";
+					"gpv", "i2cp", "irrx", "irtx", "pta",
+					"rm", "slxa", "slxk", "spia", "spib",
+					"uac";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -211,7 +212,7 @@ conf_crtp {
 			conf_ddc {
 				nvidia,pins = "ddc", "dta", "dtd", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
-					"sdc";
+					"sdc", "uad", "uca";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
@@ -221,10 +222,9 @@ conf_hdint {
 					"lvp0", "owc", "sdb";
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
-			conf_irrx {
-				nvidia,pins = "irrx", "irtx", "sdd", "spic",
-					"spie", "spih", "uaa", "uab", "uad",
-					"uca", "ucb";
+			conf_sdd {
+				nvidia,pins = "sdd", "spic", "spie", "spih",
+					"uaa", "uab", "ucb";
 				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
-- 
2.30.2



