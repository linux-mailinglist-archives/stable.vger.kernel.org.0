Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC1E101909
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfKSFWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfKSFWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6FB21939;
        Tue, 19 Nov 2019 05:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140940;
        bh=uXdI3PPqMJMLILLma3LnSa5THZKkaW21eCix6Zy1suM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzF1pMsk/hWztkd/rG/5wy4WRabFPCNMJuspYWv7prGtWLB6t14Z4egOJnjhmH8lw
         VyKYswSPlb0Ll4pCqi5AZNIiahvf9vVYbISVpAt8To2eRwuAUKm4MN2kPsJq3lmam1
         kLzdEY4oN/4laFSV1YHi0+bTbGS4qQdXtRriO/ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Lee <shawn.c.lee@intel.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 37/48] drm/i915: update rawclk also on resume
Date:   Tue, 19 Nov 2019 06:19:57 +0100
Message-Id: <20191119051017.804535722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 2f216a8507153578efc309c821528a6b81628cd2 upstream.

Since CNP it's possible for rawclk to have two different values, 19.2
and 24 MHz. If the value indicated by SFUSE_STRAP register is different
from the power on default for PCH_RAWCLK_FREQ, we'll end up having a
mismatch between the rawclk hardware and software states after
suspend/resume. On previous platforms this used to work by accident,
because the power on defaults worked just fine.

Update the rawclk also on resume. The natural place to do this would be
intel_modeset_init_hw(), however VLV/CHV need it done before
intel_power_domains_init_hw(). Thus put it there even if it feels
slightly out of place.

v2: Call intel_update_rawclck() in intel_power_domains_init_hw() for all
    platforms (Ville).

Reported-by: Shawn Lee <shawn.c.lee@intel.com>
Cc: Shawn Lee <shawn.c.lee@intel.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Shawn Lee <shawn.c.lee@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191101142024.13877-1-jani.nikula@intel.com
(cherry picked from commit 59ed05ccdded5eb18ce012eff3d01798ac8535fa)
Cc: <stable@vger.kernel.org> # v4.15+
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display_power.c |    3 +++
 drivers/gpu/drm/i915/i915_drv.c                    |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4345,6 +4345,9 @@ void intel_power_domains_init_hw(struct
 
 	power_domains->initializing = true;
 
+	/* Must happen before power domain init on VLV/CHV */
+	intel_update_rawclk(i915);
+
 	if (INTEL_GEN(i915) >= 11) {
 		icl_display_core_init(i915, resume);
 	} else if (IS_CANNONLAKE(i915)) {
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -708,9 +708,6 @@ static int i915_load_modeset_init(struct
 	if (ret)
 		goto cleanup_vga_client;
 
-	/* must happen before intel_power_domains_init_hw() on VLV/CHV */
-	intel_update_rawclk(dev_priv);
-
 	intel_power_domains_init_hw(dev_priv, false);
 
 	intel_csr_ucode_init(dev_priv);


