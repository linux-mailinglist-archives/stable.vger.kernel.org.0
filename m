Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708ED404C39
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241856AbhIIL4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241279AbhIILwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 766A261360;
        Thu,  9 Sep 2021 11:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187864;
        bh=eH78ZO8br28WU6kJd750zNC7axdeaw4weOlZh2QrV2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU9ooLTkqwqRC7wkI1oALc6EQsAnx5IIyYSnCIS+wp7eQG32P1rF8yQRIyuIlo809
         XpEMVkr0amBFLD8nRTzfufj136K8pBD/gIFPACByPF+QjYYcN8a8pmnvc/paFB5pAL
         iU3W3aUagWFxiyVjyQlmHhQeQYshTlRobrc75E35pZOrm+MnWs6N9N8oS1bxGToIVZ
         KfnciRWcIz+ZpBpOZ1u+ogPIvjTPoczqHka7b9aViKsQERrZKpFtSRcFi1vOTWCiJD
         XnpaGVJHePWoNgUp5yHMuqhbWDRqzJVDpZFfbpZLDtcj1zw63T7DUZ64cJfPFMKo7b
         wcdNbxLEI71dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 151/252] ARM: tegra: tamonten: Fix UART pad setting
Date:   Thu,  9 Sep 2021 07:39:25 -0400
Message-Id: <20210909114106.141462-151-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

