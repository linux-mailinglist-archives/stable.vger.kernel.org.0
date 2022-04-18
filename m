Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EFB5058E1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245042AbiDROLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiDROIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:08:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C73669A;
        Mon, 18 Apr 2022 06:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF507B80E59;
        Mon, 18 Apr 2022 13:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7B8C385A8;
        Mon, 18 Apr 2022 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287379;
        bh=ovHc4eVfLIwPzgDupeP7xqTAvr7qsXez6cVtCEg6mOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlCqjZH0IFzeNwSPQUnDy5Ta8JXncykEa2LuQ2rw+CKoZ6e0R7zoGgP2J0MHmbpEN
         9ejCSZI5rPKAQMGXU1IVGwDfn1Njcc5qXplICx4wXE3mcqwSgUyA41uDHO9SM46HdU
         lt14XcNrPrc3FacEHEyvUAOGcvrrZKlnEOHwEWdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Leitner <richard.leitner@skidata.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 143/218] ARM: tegra: tamonten: Fix I2C3 pad setting
Date:   Mon, 18 Apr 2022 14:13:29 +0200
Message-Id: <20220418121203.681462800@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a613e3b85b45..29769bf7a11a 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -182,8 +182,8 @@
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
@@ -202,7 +202,7 @@
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



