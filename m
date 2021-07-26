Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D85F3D5619
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhGZIZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhGZIZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E9D60D07;
        Mon, 26 Jul 2021 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627290345;
        bh=yQWPELxVRd6OT1tR8MTK9HW8I3eywV6LZnEwViEa0Oo=;
        h=Subject:To:Cc:From:Date:From;
        b=BDf2vS/aooQIYLSZAvLJcqupqBocbrE7T7MPqVUGcxKmqdij/m0uyXQnDCgmhs58d
         497O3boiVQJHtfnAjJsUke9ED2E+JaPA/+nkDoZQsGxFiBSR9eKg96C9DdY1yaOzou
         1kuDBjuFWzTyHB7KmFOPd5ZzjiObWuOAKb8Nenrs=
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix ASSR regression on embedded panels" failed to apply to 5.10-stable tree
To:     stylon.wang@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 11:01:58 +0200
Message-ID: <162729011848230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6be50f5d83adc9541de3d5be26e968182b5ac150 Mon Sep 17 00:00:00 2001
From: Stylon Wang <stylon.wang@amd.com>
Date: Wed, 21 Jul 2021 12:25:24 +0800
Subject: [PATCH] drm/amd/display: Fix ASSR regression on embedded panels

[Why]
Regression found in some embedded panels traces back to the earliest
upstreamed ASSR patch. The changed code flow are causing problems
with some panels.

[How]
- Change ASSR enabling code while preserving original code flow
  as much as possible
- Simplify the code on guarding with internal display flag

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213779
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1620
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 12066f5a53fc..9fb8c46dc606 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1820,8 +1820,7 @@ bool perform_link_training_with_retries(
 					 */
 					panel_mode = DP_PANEL_MODE_DEFAULT;
 				}
-			} else
-				panel_mode = DP_PANEL_MODE_DEFAULT;
+			}
 		}
 #endif
 
@@ -4650,7 +4649,10 @@ enum dp_panel_mode dp_get_panel_mode(struct dc_link *link)
 		}
 	}
 
-	if (link->dpcd_caps.panel_mode_edp) {
+	if (link->dpcd_caps.panel_mode_edp &&
+		(link->connector_signal == SIGNAL_TYPE_EDP ||
+		 (link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT &&
+		  link->is_internal_display))) {
 		return DP_PANEL_MODE_EDP;
 	}
 

