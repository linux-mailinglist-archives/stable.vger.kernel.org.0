Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15216302AE3
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbhAYSzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbhAYSzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685F722482;
        Mon, 25 Jan 2021 18:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600927;
        bh=KHg7s5SxfV4NaBS9V1rBKCd3P05h8M0LBryiyrJDq/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytTbDNp4VPP+cgrSpGuN/7mFtvrtABnTWHIj61GKKURoBqDXreHaoZb3PbaDJKN5g
         c4TEF8mM38mIiGPKS4aPV063A34ikFqHiqmDZml9bnH5ULxv3mo0fWAOMHPXWnAHu7
         mIp7uX5baigIvkCjIQvmZOfK1kIWduv5sLLW2e3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Paul <seanpaul@chromium.org>,
        Ramalingam C <ramalingam.c@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Karthik B S <karthik.b.s@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 194/199] drm/i915/hdcp: Get conn while content_type changed
Date:   Mon, 25 Jan 2021 19:40:16 +0100
Message-Id: <20210125183224.358407923@linuxfoundation.org>
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

commit 8662e1119a7d1baa1b2001689b2923e9050754bd upstream.

Get DRM connector reference count while scheduling a prop work
to avoid any possible destroy of DRM connector when it is in
DRM_CONNECTOR_REGISTERED state.

Fixes: a6597faa2d59 ("drm/i915: Protect workers against disappearing connectors")
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Tested-by: Karthik B S <karthik.b.s@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111081120.28417-3-anshuman.gupta@intel.com
(cherry picked from commit b3c6661aad979ec3d4f5675cf3e6a35828607d6a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -2187,6 +2187,7 @@ void intel_hdcp_update_pipe(struct intel
 	if (content_protection_type_changed) {
 		mutex_lock(&hdcp->mutex);
 		hdcp->value = DRM_MODE_CONTENT_PROTECTION_DESIRED;
+		drm_connector_get(&connector->base);
 		schedule_work(&hdcp->prop_work);
 		mutex_unlock(&hdcp->mutex);
 	}


