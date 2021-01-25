Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F73302AD8
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbhAYSyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbhAYSx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048B7206B2;
        Mon, 25 Jan 2021 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600796;
        bh=tfj94+c/lASS20Su3IaR1t9RZpeD0dye6nD7bMZqIBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gg5Ttp/tB49LYSIhIA0fAz9iNWGmavzt/8i3OkbNCBUdh7AUxWegdOzd1lnmbyB9+
         coj7K2Q6i3QLUkNS82A2v7aokHkCboHEh+jdvezOd5n2nL2KNH9vlV+I2+9AheX+k9
         GyWVuSXln5reTQgX3JG56jlAOhGVO8a0Lgd8OktQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ramalingam C <ramalingam.c@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Karthik B S <karthik.b.s@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 153/199] drm/i915/hdcp: Update CP property in update_pipe
Date:   Mon, 25 Jan 2021 19:39:35 +0100
Message-Id: <20210125183222.665223000@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Gupta <anshuman.gupta@intel.com>

commit b3c95d0bdb0855b1f28370629e9eebec6bceac17 upstream.

When crtc state need_modeset is true it is not necessary
it is going to be a real modeset, it can turns to be a
fastset instead of modeset.
This turns content protection property to be DESIRED and hdcp
update_pipe left with property to be in DESIRED state but
actual hdcp->value was ENABLED.

This issue is caught with DP MST setup, where we have multiple
connector in same DP_MST topology. When disabling HDCP on one of
DP MST connector leads to set the crtc state need_modeset to true
for all other crtc driving the other DP-MST topology connectors.
This turns up other DP MST connectors CP property to be DESIRED
despite the actual hdcp->value is ENABLED.
Above scenario fails the DP MST HDCP IGT test, disabling HDCP on
one MST stream should not cause to disable HDCP on another MST
stream on same DP MST topology.

v2:
- Fixed connector->base.registration_state == DRM_CONNECTOR_REGISTERED
  WARN_ON.

v3:
- Commit log improvement. [Uma]
- Added a comment before scheduling prop_work. [Uma]

Fixes: 33f9a623bfc6 ("drm/i915/hdcp: Update CP as per the kernel internal state")
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Tested-by: Karthik B S <karthik.b.s@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111081120.28417-2-anshuman.gupta@intel.com
(cherry picked from commit d276e16702e2d634094f75f69df3b493f359fe31)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -2198,6 +2198,14 @@ void intel_hdcp_update_pipe(struct intel
 		desired_and_not_enabled =
 			hdcp->value != DRM_MODE_CONTENT_PROTECTION_ENABLED;
 		mutex_unlock(&hdcp->mutex);
+		/*
+		 * If HDCP already ENABLED and CP property is DESIRED, schedule
+		 * prop_work to update correct CP property to user space.
+		 */
+		if (!desired_and_not_enabled && !content_protection_type_changed) {
+			drm_connector_get(&connector->base);
+			schedule_work(&hdcp->prop_work);
+		}
 	}
 
 	if (desired_and_not_enabled || content_protection_type_changed)


