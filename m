Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B9165D5DC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjADOhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbjADOgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:36:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A82CF2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F7E5B81674
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E9BC433EF;
        Wed,  4 Jan 2023 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672842997;
        bh=Sce1VyNJuzicKXc7eNpKuKvS40rDfLX6oS1L7r1ps+I=;
        h=Subject:To:Cc:From:Date:From;
        b=s+D7SNenv0HeeZBqI1MX8S01DrNFn0hkgew5bCcl5eCcDqPq5vMbJAEIY8gTemfm+
         d1gP1x6yss4GILsVN3jv7kMxX/2LO9JV549HgfviS1dFUybKiAmBITpnfiTg462dTn
         4nYN/cvdgtMpcPqNZbTE11terymjCVo/VzGidWow=
Subject: FAILED: patch "[PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4" failed to apply to 5.15-stable tree
To:     jfalempe@redhat.com, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:36:20 +0100
Message-ID: <167284298023672@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

b389286d0234 ("drm/mgag200: Fix PLL setup for G200_SE_A rev >=4")
877507bb954e ("drm/mgag200: Provide per-device callbacks for PIXPLLC")
8aeeb3144fe2 ("drm/mgag200: Provide per-device callbacks for BMC synchronization")
f639f74a7895 ("drm/mgag200: Add per-device callbacks")
1baf9127c482 ("drm/mgag200: Replace simple-KMS with regular atomic helpers")
4f4dc37e374c ("drm/mgag200: Reorganize before dropping simple-KMS helpers")
ed2ef21f1089 ("drm/mgag200: Store primary plane's color format in CRTC state")
2d70b9a1482e ("drm/mgag200: Acquire I/O-register lock in atomic_commit_tail function")
1ee181fe958a ("drm/mgag200: Move DAC-register setup into model-specific code")
44373151ab42 ("drm/mgag200: Split mgag200_modeset_init()")
98da4b99a052 ("drm/mgag200: Store maximum resolution and memory bandwidth in device info")
21e74bf99596 ("drm/mgag200: Store HW_BUG_NO_STARTADD flag in device info")
b9a577a407d9 ("drm/mgag200: Add struct mgag200_device_info")
b62d943e9686 ("drm/mgag200: Implement new init logic")
d45e32c9d98c ("drm/mgag200: Call mgag200_device_probe_vram() from per-model init")
ce19021fd99a ("drm/mgag200: Move PCI-option setup into model-specific code")
85397f6bc4ff ("drm/mgag200: Initialize each model in separate function")
73f54d5d9682 ("drm/mgag200: Remove special case for G200SE with <2 MiB")
475e2b970cc3 ("drm/mgag200: Split up connector's mode_valid helper")
69340e529a06 ("drm/mgag200: Test memory requirements in drm_mode_config_funcs.mode_valid")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b389286d0234e1edbaf62ed8bc0892a568c33662 Mon Sep 17 00:00:00 2001
From: Jocelyn Falempe <jfalempe@redhat.com>
Date: Thu, 13 Oct 2022 15:28:10 +0200
Subject: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4

For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
or "signal out of range" on VGA display.
previous code had "m |= 0x80" which was changed to
m |= ((pixpllcn & BIT(8)) >> 1);

Tested on G200_SE_A rev 42

This line of code was moved to another file with
commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for
PIXPLLC") but can be easily backported before this commit.

v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
    * Add a comment to explain that this bit must be set (Thomas)

Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013132810.521945-1-jfalempe@redhat.com

diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c b/drivers/gpu/drm/mgag200/mgag200_g200se.c
index be389ed91cbd..bd6e573c9a1a 100644
--- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
@@ -284,7 +284,8 @@ static void mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 

