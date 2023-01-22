Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE19676D25
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjAVNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAVNZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:25:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C911A4BF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:25:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB39B80A53
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C78C433D2;
        Sun, 22 Jan 2023 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393939;
        bh=mB/+S0ejfL6g9lCefvVeBPQfhqF+LpPtp4LPfM6SbDo=;
        h=Subject:To:Cc:From:Date:From;
        b=Ode7IDT/BeB0vG1hksl9Qy7ZRFzP2LAh62BeB02cv/hB/WcC93i5kZpkPjc/EoVOU
         Ehxu4ZKKRJeilVvxAhMaLcFRRN/G9udq9IlxRD6XcThinl9LIqXHEdjnijblyz8io/
         Mr8Do0C3s3+YY7CuD7oJS/1HGnuS8la8rOL05aM0=
Subject: FAILED: patch "[PATCH] drm/i915: Allow switching away via vga-switcheroo if" failed to apply to 5.15-stable tree
To:     tzimmermann@suse.de, Jason@zx2c4.com, Julia.Lawall@inria.fr,
        alexander.deucher@amd.com, andi.shyti@linux.intel.com,
        andrzej.hajda@intel.com, ankit.k.nautiyal@intel.com,
        imre.deak@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        jose.souza@intel.com, jouni.hogander@intel.com,
        lucas.demarchi@intel.com, manasi.d.navare@intel.com,
        matthew.d.roper@intel.com, radhakrishna.sripada@intel.com,
        ramalingam.c@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, stanislav.lisovskiy@intel.com,
        tvrtko.ursulin@linux.intel.com, uma.shankar@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:25:37 +0100
Message-ID: <16743939375168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a273e95721e9 ("drm/i915: Allow switching away via vga-switcheroo if uninitialized")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a273e95721e96885971a05f1b34cb6d093904d9d Mon Sep 17 00:00:00 2001
From: Thomas Zimmermann <tzimmermann@suse.de>
Date: Mon, 16 Jan 2023 12:54:23 +0100
Subject: [PATCH] drm/i915: Allow switching away via vga-switcheroo if
 uninitialized
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Always allow switching away via vga-switcheroo if the display is
uninitalized. Instead prevent switching to i915 if the device has
not been initialized.

This issue was introduced by commit 5df7bd130818 ("drm/i915: skip
display initialization when there is no display") protected, which
protects code paths from being executed on uninitialized devices.
In the case of vga-switcheroo, we want to allow a switch away from
i915's device. So run vga_switcheroo_process_delayed_switch() and
test in the switcheroo callbacks if the i915 device is available.

Fixes: 5df7bd130818 ("drm/i915: skip display initialization when there is no display")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: "Jouni Högander" <jouni.hogander@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: "José Roberto de Souza" <jose.souza@intel.com>
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20230116115425.13484-2-tzimmermann@suse.de

diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index 69103ae37779..b5700681432d 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1073,8 +1073,7 @@ static void i915_driver_lastclose(struct drm_device *dev)
 
 	intel_fbdev_restore_mode(dev);
 
-	if (HAS_DISPLAY(i915))
-		vga_switcheroo_process_delayed_switch();
+	vga_switcheroo_process_delayed_switch();
 }
 
 static void i915_driver_postclose(struct drm_device *dev, struct drm_file *file)
diff --git a/drivers/gpu/drm/i915/i915_switcheroo.c b/drivers/gpu/drm/i915/i915_switcheroo.c
index 23777d500cdf..f45bd6b6cede 100644
--- a/drivers/gpu/drm/i915/i915_switcheroo.c
+++ b/drivers/gpu/drm/i915/i915_switcheroo.c
@@ -19,6 +19,10 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "DRM not initialized, aborting switch.\n");
 		return;
 	}
+	if (!HAS_DISPLAY(i915)) {
+		dev_err(&pdev->dev, "Device state not initialized, aborting switch.\n");
+		return;
+	}
 
 	if (state == VGA_SWITCHEROO_ON) {
 		drm_info(&i915->drm, "switched on\n");
@@ -44,7 +48,7 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 	 * locking inversion with the driver load path. And the access here is
 	 * completely racy anyway. So don't bother with locking for now.
 	 */
-	return i915 && atomic_read(&i915->drm.open_count) == 0;
+	return i915 && HAS_DISPLAY(i915) && atomic_read(&i915->drm.open_count) == 0;
 }
 
 static const struct vga_switcheroo_client_ops i915_switcheroo_ops = {

