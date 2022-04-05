Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545BB4F3088
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245317AbiDEIyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240910AbiDEIci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319B18CD89;
        Tue,  5 Apr 2022 01:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CF42B81BC0;
        Tue,  5 Apr 2022 08:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1770C385A1;
        Tue,  5 Apr 2022 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147116;
        bh=wFHIxxBTTP4wOS9bz+1lwhshF/VP5NrSb9hmYItn70Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP+5Va8HaNDjQBhIdk6yy+tDdh0oTaG4FOVgpbAe+xeNojE4iUWE/dF5iCYaFvUhK
         VR97/+yewmvhKZZCpGZMDOJWji/9YmPKtYCFPc+ha6ZHrs9djmGwrXYz9heVVoaaka
         2Vvhb4UJmnX5C8NZMqfo9yGTIXCuQK/RU72J9TZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Mika Kahola <mika.kahola@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.17 0969/1126] drm/i915: Reject unsupported TMDS rates on ICL+
Date:   Tue,  5 Apr 2022 09:28:36 +0200
Message-Id: <20220405070435.946243241@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 9cddf03b2af07443bebdc73cba21acb360c079e8 upstream.

ICL+ PLLs can't genenerate certain frequencies. Running the PLL
algorithms through for all frequencies 25-594MHz we see a gap just
above 500 MHz. Specifically 500-522.8MHZ for TC PLLs, and 500-533.2
MHz for combo PHY PLLs. Reject those frequencies hdmi_port_clock_valid()
so that we properly filter out unsupported modes and/or color depths
for HDMI.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5247
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220311212845.32358-1-ville.syrjala@linux.intel.com
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
(cherry picked from commit e5086cb3f3d3f94091be29eec38cf13f8a75a778)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -1836,6 +1836,7 @@ hdmi_port_clock_valid(struct intel_hdmi
 		      bool has_hdmi_sink)
 {
 	struct drm_i915_private *dev_priv = intel_hdmi_to_i915(hdmi);
+	enum phy phy = intel_port_to_phy(dev_priv, hdmi_to_dig_port(hdmi)->base.port);
 
 	if (clock < 25000)
 		return MODE_CLOCK_LOW;
@@ -1856,6 +1857,14 @@ hdmi_port_clock_valid(struct intel_hdmi
 	if (IS_CHERRYVIEW(dev_priv) && clock > 216000 && clock < 240000)
 		return MODE_CLOCK_RANGE;
 
+	/* ICL+ combo PHY PLL can't generate 500-533.2 MHz */
+	if (intel_phy_is_combo(dev_priv, phy) && clock > 500000 && clock < 533200)
+		return MODE_CLOCK_RANGE;
+
+	/* ICL+ TC PHY PLL can't generate 500-532.8 MHz */
+	if (intel_phy_is_tc(dev_priv, phy) && clock > 500000 && clock < 532800)
+		return MODE_CLOCK_RANGE;
+
 	/*
 	 * SNPS PHYs' MPLLB table-based programming can only handle a fixed
 	 * set of link rates.


