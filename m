Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7CF4EC1FC
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344901AbiC3L5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345890AbiC3LzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D3425EC9D;
        Wed, 30 Mar 2022 04:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA15D616DA;
        Wed, 30 Mar 2022 11:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B6C34111;
        Wed, 30 Mar 2022 11:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641131;
        bh=8ZFmnqlSEMxKjuWziuwkhdq48STdoQ3qVnRC30Htjlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubGd8FF7QhLDXrxASeA+gcqSIFiHwhiZEYqLmdM+lwJ79+i3dNVxqohNXqkSeDvxK
         enIYDOqrYm5ntXhL8qgXX03VeKuMBnqA1OHLZ0j57YaZcK+VXY2druT0Y8dVC0rBsQ
         ustOz5Crwpwr/HMwNxGCXWJEYEBjlcrtem8rukwe80Bf0ToVWgpHkT6yXesYaS+xcC
         3M14O9xKvnEql57lHhZk92h4KgkRHwa7+4fCCjtpvbj7EPBmJzSLES6X3dfzxWtrvS
         PRRM8iLvtITDZcM/7T7WNDtZNs1Bx4BWSTwnVliGbgKYrIYIGVKxT5BAr5csqm9sRA
         zUNlyovntM55Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Leitner <richard.leitner@skidata.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/37] ARM: tegra: tamonten: Fix I2C3 pad setting
Date:   Wed, 30 Mar 2022 07:51:13 -0400
Message-Id: <20220330115122.1671763-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Leitner <richard.leitner@skidata.com>

[ Upstream commit 0092c25b541a5422d7e71892a13c55ee91abc34b ]

This patch fixes the tristate configuration for i2c3 function assigned
to the dtf pins on the Tamonten Tegra20 SoM.

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index dd4d506683de..7f14f0d005c3 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -183,8 +183,8 @@
 			};
 			conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
-					"cdev1", "cdev2", "dap1", "dtb", "gma",
-					"gmb", "gmc", "gmd", "gme", "gpu7",
+					"cdev1", "cdev2", "dap1", "dtb", "dtf",
+					"gma", "gmb", "gmc", "gmd", "gme", "gpu7",
 					"gpv", "i2cp", "irrx", "irtx", "pta",
 					"rm", "slxa", "slxk", "spia", "spib",
 					"uac";
@@ -203,7 +203,7 @@
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap2", "dap3", "dap4",
-					"dtc", "dte", "dtf", "gpu", "sdio1",
+					"dtc", "dte", "gpu", "sdio1",
 					"slxc", "slxd", "spdi", "spdo", "spig",
 					"uda";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-- 
2.34.1

