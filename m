Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B96313BC3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhBHR5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:57:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:11265 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235104AbhBHRzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:55:33 -0500
IronPort-SDR: VLKd9zi6JddK4Sh3FamA5ZUCv/5IjPlcCM7Bek+kDSCPc8zJK/bmtBq906tNlPRGSTV/2Os3Zl
 FiIm4YuosjMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="200814533"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="200814533"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 09:53:45 -0800
IronPort-SDR: BRbgEeZGJGRgmbX62u/0s4Cr3LLPBJbsnpeOytjtOPeZd3aEa+sDNPnJRWiwHRn4S2R8EvZY6N
 rboRVqVJRfdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="360121561"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga007.fm.intel.com with SMTP; 08 Feb 2021 09:53:42 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 08 Feb 2021 19:53:41 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Clinton Taylor <clinton.a.taylor@intel.com>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH stable-5.10 1/2] drm/i915: Fix ICL MG PHY vswing handling
Date:   Mon,  8 Feb 2021 19:53:40 +0200
Message-Id: <20210208175341.8695-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <16127808794868@kroah.com>
References: <16127808794868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit a2a5f5628e5494ca9353f761f7fe783dfa82fb9a upstream.

The MH PHY vswing table does have all the entries these days. Get
rid of the old hacks in the code which claim otherwise.

This hack was totally bogus anyway. The correct way to handle the
lack of those two entries would have been to declare our max
vswing and pre-emph to both be level 2.

Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Clinton Taylor <clinton.a.taylor@intel.com>
Fixes: 9f7ffa297978 ("drm/i915/tc/icl: Update TC vswing tables")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201207203512.1718-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit 5ec346476e795089b7dac8ab9dcee30c8d80ad84)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a2a5f5628e5494ca9353f761f7fe783dfa82fb9a)
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 3f2bbd9370a8..51f4f4374dea 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2605,12 +2605,11 @@ static void icl_mg_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 
 	ddi_translations = icl_get_mg_buf_trans(encoder, type, rate,
 						&n_entries);
-	/* The table does not have values for level 3 and level 9. */
-	if (level >= n_entries || level == 3 || level == 9) {
+	if (level >= n_entries) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "DDI translation not found for level %d. Using %d instead.",
-			    level, n_entries - 2);
-		level = n_entries - 2;
+			    level, n_entries - 1);
+		level = n_entries - 1;
 	}
 
 	/* Set MG_TX_LINK_PARAMS cri_use_fs32 to 0. */
-- 
2.26.2

