Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973ED6C19B8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbjCTPhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjCTPgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D4C38022
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C509C6158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2026C433D2;
        Mon, 20 Mar 2023 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326118;
        bh=qiPPvstn9iDse4oCkEy7I1GK5Guy0SDOGAs8XIcXX3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1Q5ziYQ+b2S1wPFXrGMuXbTOqf2h5YqV8knue8AYmBnVenCetto2A+4welfAq2ur
         z8+2GKj01k5laeWoVZ9B5wbwfgE23MEZTin7DVl+m/TliFkK+g0ZEX0nhApsXlwPJE
         MBhfRPNHaM46BM0Fr9mrKJqe8bAhsG4vFxzlJhkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 165/211] drm/i915/dg2: Add HDMI pixel clock frequencies 267.30 and 319.89 MHz
Date:   Mon, 20 Mar 2023 15:55:00 +0100
Message-Id: <20230320145520.346847077@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 46bc23dcd94569270d02c4c1f7e62ae01ebd53bb upstream.

Add snps phy table values for HDMI pixel clocks 267.30 MHz and
319.89 MHz. Values are based on the Bspec algorithm for
PLL programming for HDMI.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8008
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230223043619.3941382-1-ankit.k.nautiyal@intel.com
(cherry picked from commit d46746b8b13cbd377ffc733e465d25800459a31b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_snps_phy.c |   62 ++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -1419,6 +1419,36 @@ static const struct intel_mpllb_state dg
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_267300 = {
+	.clock = 267300,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 7) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 3),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 74) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 30146) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 36699),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_268500 = {
 	.clock = 268500,
 	.ref_control =
@@ -1509,6 +1539,36 @@ static const struct intel_mpllb_state dg
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_319890 = {
+	.clock = 319890,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 6) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 2),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 94) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 64094) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 13631),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_497750 = {
 	.clock = 497750,
 	.ref_control =
@@ -1696,8 +1756,10 @@ static const struct intel_mpllb_state *
 	&dg2_hdmi_209800,
 	&dg2_hdmi_241500,
 	&dg2_hdmi_262750,
+	&dg2_hdmi_267300,
 	&dg2_hdmi_268500,
 	&dg2_hdmi_296703,
+	&dg2_hdmi_319890,
 	&dg2_hdmi_497750,
 	&dg2_hdmi_592000,
 	&dg2_hdmi_593407,


