Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F9F318DFD
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhBKPTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1BF864EF4;
        Thu, 11 Feb 2021 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055887;
        bh=KWkwalSkb27ZGozz9AZ+d3puMXgUXrgcd9/nR7P7UaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1HkDfCnTDIXTWIa+e/zCqG/p8dy4YMSy+kl6vhRN02K3wgs043gBbUKTE/bXKSnY
         rmMLl52vlhn+CcIEIXCf4XO3jI3hO3KkxK1Y5Uucf9ZOS17V2U/r8dqdOb1AibCoSg
         MfE9oLoJ5+xDKQeOkqfBzMI1J8dbEWTJsGcz8c9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Clinton Taylor <clinton.a.taylor@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 47/54] drm/i915: Fix ICL MG PHY vswing handling
Date:   Thu, 11 Feb 2021 16:02:31 +0100
Message-Id: <20210211150154.924286991@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2605,12 +2605,11 @@ static void icl_mg_phy_ddi_vswing_sequen
 
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


