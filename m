Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE295417B3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379025AbiFGVEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378839AbiFGVBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30BE20ED78;
        Tue,  7 Jun 2022 11:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BE87B82018;
        Tue,  7 Jun 2022 18:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F68C385A2;
        Tue,  7 Jun 2022 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627546;
        bh=VWcjbaWEKU8jM7eBzPIHpVL4HsBF647GA3mic0FDKcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8qFUc3k+CtLLG57l2/SDFnzJqQO/jR4Hl9DLAZaEYb8MyeZwU6F8btogQAr8R5lx
         Ocr/EwpsujUiwEfHrCa+FhJ4yF8lt5YF2X+xgDNPmnD8/s6SGUujxFYFh7sWkemeQs
         uDy3GS0hEeS8ec1IPsmO3O+8Jzj3hTsnciKhAMJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.17 741/772] arm64: tegra: Add missing DFLL reset on Tegra210
Date:   Tue,  7 Jun 2022 19:05:33 +0200
Message-Id: <20220607165010.869515890@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

commit 0017f2c856e21bb900be88469e15dac4f41f4065 upstream.

Commit 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling
clocks") removed deassertion of reset lines when enabling peripheral
clocks. This breaks the initialization of the DFLL driver which relied
on this behaviour.

In order to be able to fix this, add the corresponding reset to the DT.
Tested on Google Pixel C.

Cc: stable@vger.kernel.org
Fixes: 4782c0a5dd88 ("clk: tegra: Don't deassert reset on enabling clocks")
Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -1366,8 +1366,9 @@
 			 <&tegra_car TEGRA210_CLK_DFLL_REF>,
 			 <&tegra_car TEGRA210_CLK_I2C5>;
 		clock-names = "soc", "ref", "i2c";
-		resets = <&tegra_car TEGRA210_RST_DFLL_DVCO>;
-		reset-names = "dvco";
+		resets = <&tegra_car TEGRA210_RST_DFLL_DVCO>,
+			 <&tegra_car 155>;
+		reset-names = "dvco", "dfll";
 		#clock-cells = <0>;
 		clock-output-names = "dfllCPU_out";
 		status = "disabled";


