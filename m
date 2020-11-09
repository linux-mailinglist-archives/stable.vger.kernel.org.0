Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0C2ABAF4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgKINPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731894AbgKINPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AB120663;
        Mon,  9 Nov 2020 13:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927752;
        bh=PRDHuO/C+mpdzivCNEYkAPBD0OkCwi78rvQaLYe4U4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLruVHVsyxa4OxVqPQ+G2DR2AciGj3Duq87RcbR8l68w+d/nBeFM6lZqRAQkDkWbj
         xtoODX2Mpe/H+PlB4wwngJcceLPEw12oMNBmV4z+Od3SWhS2S6C19v7T16e5OOZO/C
         y4x1sJAW7lWH2NGm38pV7Zks8R+QfgUtIrf3h1CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 010/133] drm/i915: Fix TGL DKL PHY DP vswing handling
Date:   Mon,  9 Nov 2020 13:54:32 +0100
Message-Id: <20201109125031.216282421@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f0b707c125a2e228bcc047cd46040943bef61931 upstream.

The HDMI vs. not-HDMI check got inverted whem the bogus encoder->type
checks were eliminated. So now we're using 0 as the link rate on DP
and potentially non-zero on HDMI, which is exactly the opposite of
what we want. The original bogus check actually worked more correctly
by accident since if would always evaluate to true. Due to this we
now always use the RBR/HBR1 vswing table and never ever the HBR2+
vswing table. That is probably not a good way to get a high quality
signal at HBR2+ rates. Fix the check so we pick the right table.

Cc: stable@vger.kernel.org
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Fixes: 94641eb6c696 ("drm/i915/display: Fix the encoder type check")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200930223642.28565-1-ville.syrjala@linux.intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
(cherry picked from commit 945b18fb4803b01e822ade6aef6cc0b6e4bd644f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_ddi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2655,7 +2655,7 @@ tgl_dkl_phy_ddi_vswing_sequence(struct i
 	u32 n_entries, val, ln, dpcnt_mask, dpcnt_val;
 	int rate = 0;
 
-	if (type == INTEL_OUTPUT_HDMI) {
+	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
 		rate = intel_dp->link_rate;


