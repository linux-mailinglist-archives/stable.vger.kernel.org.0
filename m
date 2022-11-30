Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D974D63DF71
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiK3SrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiK3SrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E05431F9E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9E7D61D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE15C433D6;
        Wed, 30 Nov 2022 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834023;
        bh=Zn6RLBflghdpehnMevu43IDm9YMOqhkLX6/6gXQpHlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2F3/K7ucE13rTT5UbLJ0cYm9QgikWmbGcAeKG2xKw9juAIrprrH3sPE3Exmm5XPdw
         i6Cib1Er3EjqP5O1n26GFGfkff8I0p04IU2QADjaJIMDZ7hgdck9LjXhsq4hi3ReiE
         Dui38z/s64HckHvw52eX653GmfW3VIG7FgKzPFg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 100/289] drm/i915: Fix warn in intel_display_power_*_domain() functions
Date:   Wed, 30 Nov 2022 19:21:25 +0100
Message-Id: <20221130180546.407492987@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit ebbaa4392e36521fb893973d8a0fcb32f3b6d5eb ]

The intel_display_power_*_domain() functions should always warn if a
default domain is returned as a fallback, fix this up. Spotted by Ville.

Fixes: 979e1b32e0e2 ("drm/i915: Sanitize the port -> DDI/AUX power domain mapping for each platform")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221114122251.21327-2-imre.deak@intel.com
(cherry picked from commit 10b85f0e1d922210ae857afed6d012ec32c4b6cb)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display_power.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 589af257edeb..3bb113b42cfa 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -2427,7 +2427,7 @@ intel_display_power_ddi_io_domain(struct drm_i915_private *i915, enum port port)
 {
 	const struct intel_ddi_port_domains *domains = intel_port_domains_for_port(i915, port);
 
-	if (drm_WARN_ON(&i915->drm, !domains) || domains->ddi_io == POWER_DOMAIN_INVALID)
+	if (drm_WARN_ON(&i915->drm, !domains || domains->ddi_io == POWER_DOMAIN_INVALID))
 		return POWER_DOMAIN_PORT_DDI_IO_A;
 
 	return domains->ddi_io + (int)(port - domains->port_start);
@@ -2438,7 +2438,7 @@ intel_display_power_ddi_lanes_domain(struct drm_i915_private *i915, enum port po
 {
 	const struct intel_ddi_port_domains *domains = intel_port_domains_for_port(i915, port);
 
-	if (drm_WARN_ON(&i915->drm, !domains) || domains->ddi_lanes == POWER_DOMAIN_INVALID)
+	if (drm_WARN_ON(&i915->drm, !domains || domains->ddi_lanes == POWER_DOMAIN_INVALID))
 		return POWER_DOMAIN_PORT_DDI_LANES_A;
 
 	return domains->ddi_lanes + (int)(port - domains->port_start);
@@ -2464,7 +2464,7 @@ intel_display_power_legacy_aux_domain(struct drm_i915_private *i915, enum aux_ch
 {
 	const struct intel_ddi_port_domains *domains = intel_port_domains_for_aux_ch(i915, aux_ch);
 
-	if (drm_WARN_ON(&i915->drm, !domains) || domains->aux_legacy_usbc == POWER_DOMAIN_INVALID)
+	if (drm_WARN_ON(&i915->drm, !domains || domains->aux_legacy_usbc == POWER_DOMAIN_INVALID))
 		return POWER_DOMAIN_AUX_A;
 
 	return domains->aux_legacy_usbc + (int)(aux_ch - domains->aux_ch_start);
@@ -2475,7 +2475,7 @@ intel_display_power_tbt_aux_domain(struct drm_i915_private *i915, enum aux_ch au
 {
 	const struct intel_ddi_port_domains *domains = intel_port_domains_for_aux_ch(i915, aux_ch);
 
-	if (drm_WARN_ON(&i915->drm, !domains) || domains->aux_tbt == POWER_DOMAIN_INVALID)
+	if (drm_WARN_ON(&i915->drm, !domains || domains->aux_tbt == POWER_DOMAIN_INVALID))
 		return POWER_DOMAIN_AUX_TBT1;
 
 	return domains->aux_tbt + (int)(aux_ch - domains->aux_ch_start);
-- 
2.35.1



