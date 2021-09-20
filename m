Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE441250E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353587AbhITSlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381955AbhITSjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D254363335;
        Mon, 20 Sep 2021 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159042;
        bh=cUnrVoZkYFdeVv9AZG38BzbZO66hQK6kHGVOAECMSRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ5ic9cALE0aCCpu67srXXzGHbl1w6ukVfktpxIELN6VVCPu6/nMwUmil5dn5UT0E
         XVUOgCam9wAMI0Ao/Ef4GhnlwrEGqAS1rE3BcsI+O9dBCB0GXfIe2IfoKQW2CLZQzP
         5z/lPm/oyj8SecI4/Bv090hJeUH35CnchfXFt3ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Cooper Chiou <cooper.chiou@intel.com>,
        William Tseng <william.tseng@intel.com>,
        Lee Shawn C <shawn.c.lee@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 049/168] drm/i915/dp: return proper DPRX link training result
Date:   Mon, 20 Sep 2021 18:43:07 +0200
Message-Id: <20210920163923.250441951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Shawn C <shawn.c.lee@intel.com>

commit 9af4bf2171c1a9e3f2ebb21140c0e34e60b2a22a upstream.

After DPRX link training, intel_dp_link_train_phy() did not
return the training result properly. If link training failed,
i915 driver would not run into link train fallback function.
And no hotplug uevent would be received by user space application.

Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode link training")
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Cooper Chiou <cooper.chiou@intel.com>
Cc: William Tseng <william.tseng@intel.com>
Signed-off-by: Lee Shawn C <shawn.c.lee@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210706152541.25021-1-shawn.c.lee@intel.com
(cherry picked from commit dab1b47e57e053b2a02c22ead8e7449f79961335)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -848,7 +848,7 @@ intel_dp_link_train_all_phys(struct inte
 	}
 
 	if (ret)
-		intel_dp_link_train_phy(intel_dp, crtc_state, DP_PHY_DPRX);
+		ret = intel_dp_link_train_phy(intel_dp, crtc_state, DP_PHY_DPRX);
 
 	if (intel_dp->set_idle_link_train)
 		intel_dp->set_idle_link_train(intel_dp, crtc_state);


