Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10FA9166
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbfIDSPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbfIDSPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E9C22CF7;
        Wed,  4 Sep 2019 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620913;
        bh=pNjTmQkXr2yxZMaQNAbVRnf1sMaLKyG6AAgQ8NtZhxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEbUI2khU4cLrnO7xq9kbryVMeRRo+MoR1hw1VxT9+M/1PpdTe2qc3hdjA+hznfXJ
         2HcI4qqUB8oPqg9AfuCh10V1VlC09SnrEU6A0b4oIzfTkKRzfYdBJCVA2s7SAbdGEr
         7o18QigXo2y6UWiVw2nT4r/LqAFPsVmtpqtrBduA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 140/143] drm/i915/dp: Fix DSC enable code to use cpu_transcoder instead of encoder->type
Date:   Wed,  4 Sep 2019 19:54:43 +0200
Message-Id: <20190904175319.933659265@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d4c61c4a16decd8ace8660f22c81609a539fccba ]

This patch fixes the intel_configure_pps_for_dsc_encoder() function to use
cpu_transcoder instead of encoder->type to select the correct DSC registers
that was wrongly used in the original patch for one DSC register isntance.

Fixes: 7182414e2530 ("drm/i915/dp: Configure i915 Picture parameter Set registers during DSC enabling")
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190821215950.24223-1-manasi.d.navare@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_vdsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_vdsc.c b/drivers/gpu/drm/i915/intel_vdsc.c
index 3f9921ba4a769..eb978e7238c24 100644
--- a/drivers/gpu/drm/i915/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/intel_vdsc.c
@@ -539,7 +539,7 @@ static void intel_configure_pps_for_dsc_encoder(struct intel_encoder *encoder,
 	pps_val |= DSC_PIC_HEIGHT(vdsc_cfg->pic_height) |
 		DSC_PIC_WIDTH(vdsc_cfg->pic_width / num_vdsc_instances);
 	DRM_INFO("PPS2 = 0x%08x\n", pps_val);
-	if (encoder->type == INTEL_OUTPUT_EDP) {
+	if (cpu_transcoder == TRANSCODER_EDP) {
 		I915_WRITE(DSCA_PICTURE_PARAMETER_SET_2, pps_val);
 		/*
 		 * If 2 VDSC instances are needed, configure PPS for second
-- 
2.20.1



