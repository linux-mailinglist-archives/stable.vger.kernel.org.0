Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA041EFAA8
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgFEOTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgFEOTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF078208A9;
        Fri,  5 Jun 2020 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366774;
        bh=MYJqfoYIbEzY1UIFb/rjRLJvQvUWngWnN24BHuAkXuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQpmU2EDQ8G6iT2ratAgjJWDELIkZ/AOFUKkkjtB5/47ToXXAKwxp6uVLEO7hdjiJ
         6H3nWzaNdF4NmcaHqIVzOPSmD44AQIlpwSSECACOrAn0UQQ9hAlPLV+8O+FdKSaAuB
         v5AHV1kSh9ottvVQU9rNWwfzKQBNMYwUnQ1Bruao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas De Marchi <lucas.demarchi@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/28] drm/i915: fix port checks for MST support on gen >= 11
Date:   Fri,  5 Jun 2020 16:15:14 +0200
Message-Id: <20200605140253.085150761@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.338635395@linuxfoundation.org>
References: <20200605140252.338635395@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 10d987fd1b7baceaafa78d805e71427ab735b4e4 ]

Both Ice Lake and Elkhart Lake (gen 11) support MST on all external
connections except DDI A. Tiger Lake (gen 12) supports on all external
connections.

Move the check to happen inside intel_dp_mst_encoder_init() and add
specific platform checks.

v2: Replace != with == checks for ports on gen < 11 (Ville)

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191015164029.18431-3-lucas.demarchi@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_dp.c     |  7 ++-----
 drivers/gpu/drm/i915/intel_dp_mst.c | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 20cd4c8acecc..77a2f7fc2b37 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -6288,11 +6288,8 @@ intel_dp_init_connector(struct intel_digital_port *intel_dig_port,
 		intel_connector->get_hw_state = intel_connector_get_hw_state;
 
 	/* init MST on ports that can support it */
-	if (HAS_DP_MST(dev_priv) && !intel_dp_is_edp(intel_dp) &&
-	    (port == PORT_B || port == PORT_C ||
-	     port == PORT_D || port == PORT_F))
-		intel_dp_mst_encoder_init(intel_dig_port,
-					  intel_connector->base.base.id);
+	intel_dp_mst_encoder_init(intel_dig_port,
+				  intel_connector->base.base.id);
 
 	if (!intel_edp_init_connector(intel_dp, intel_connector)) {
 		intel_dp_aux_fini(intel_dp);
diff --git a/drivers/gpu/drm/i915/intel_dp_mst.c b/drivers/gpu/drm/i915/intel_dp_mst.c
index 58ba14966d4f..c7d52c66ff29 100644
--- a/drivers/gpu/drm/i915/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/intel_dp_mst.c
@@ -588,21 +588,31 @@ intel_dp_create_fake_mst_encoders(struct intel_digital_port *intel_dig_port)
 int
 intel_dp_mst_encoder_init(struct intel_digital_port *intel_dig_port, int conn_base_id)
 {
+	struct drm_i915_private *i915 = to_i915(intel_dig_port->base.base.dev);
 	struct intel_dp *intel_dp = &intel_dig_port->dp;
-	struct drm_device *dev = intel_dig_port->base.base.dev;
+	enum port port = intel_dig_port->base.port;
 	int ret;
 
-	intel_dp->can_mst = true;
+	if (!HAS_DP_MST(i915) || intel_dp_is_edp(intel_dp))
+		return 0;
+
+	if (INTEL_GEN(i915) < 12 && port == PORT_A)
+		return 0;
+
+	if (INTEL_GEN(i915) < 11 && port == PORT_E)
+		return 0;
+
 	intel_dp->mst_mgr.cbs = &mst_cbs;
 
 	/* create encoders */
 	intel_dp_create_fake_mst_encoders(intel_dig_port);
-	ret = drm_dp_mst_topology_mgr_init(&intel_dp->mst_mgr, dev,
+	ret = drm_dp_mst_topology_mgr_init(&intel_dp->mst_mgr, &i915->drm,
 					   &intel_dp->aux, 16, 3, conn_base_id);
-	if (ret) {
-		intel_dp->can_mst = false;
+	if (ret)
 		return ret;
-	}
+
+	intel_dp->can_mst = true;
+
 	return 0;
 }
 
-- 
2.25.1



