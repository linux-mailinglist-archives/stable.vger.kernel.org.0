Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA55AEAE9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiIFNpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiIFNoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:44:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1372D7F0AB;
        Tue,  6 Sep 2022 06:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8953861552;
        Tue,  6 Sep 2022 13:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7F8C433C1;
        Tue,  6 Sep 2022 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471392;
        bh=24Gtr3ZjFh86hio1nJHGtFL8xDc82Ac6doIxTsAnxmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5mF9Li1YgX0tPYauIcy8Zd3/6xfhdVihcwLlya6dqeCdgp7moxrbOcXD8hoyyxjj
         wtubCtNSWiSPRPJ5y1TxX3vcAnynDMhPZw1l0KEJvlcvAVj/gENFpflBUesM5XMkhK
         J7VHGFWbre/gq4eW2CsOUPV4uSRxvX2GVWk/R1w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun R Murthy <arun.r.murthy@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/107] drm/i915/display: avoid warnings when registering dual panel backlight
Date:   Tue,  6 Sep 2022 15:29:53 +0200
Message-Id: <20220906132822.278140983@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun R Murthy <arun.r.murthy@intel.com>

[ Upstream commit 868e8e5156a1f8d92ca83fdbac6fd52798650792 ]

Commit 20f85ef89d94 ("drm/i915/backlight: use unique backlight device
names") added support for multiple backlight devices on dual panel
systems, but did so with error handling on -EEXIST from
backlight_device_register(). Unfortunately, that triggered a warning in
dmesg all the way down from sysfs_add_file_mode_ns() and
sysfs_warn_dup().

Instead of optimistically always attempting to register with the default
name ("intel_backlight", which we have to retain for backward
compatibility), check if a backlight device with the name exists first,
and, if so, use the card and connector based name.

v2: reworked on top of the patch commit 20f85ef89d94
("drm/i915/backlight: use unique backlight device names")
v3: fixed the ref count leak(Jani N)

Fixes: 20f85ef89d94 ("drm/i915/backlight: use unique backlight device names")
Signed-off-by: Arun R Murthy <arun.r.murthy@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220808035750.3111046-1-arun.r.murthy@intel.com
(cherry picked from commit 4234ea30051200fc6016de10e4d58369e60b38f1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/display/intel_backlight.c    | 26 +++++++++----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_backlight.c b/drivers/gpu/drm/i915/display/intel_backlight.c
index 4b0086ee48519..60f91ac7d1427 100644
--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -966,26 +966,24 @@ int intel_backlight_device_register(struct intel_connector *connector)
 	if (!name)
 		return -ENOMEM;
 
-	bd = backlight_device_register(name, connector->base.kdev, connector,
-				       &intel_backlight_device_ops, &props);
-
-	/*
-	 * Using the same name independent of the drm device or connector
-	 * prevents registration of multiple backlight devices in the
-	 * driver. However, we need to use the default name for backward
-	 * compatibility. Use unique names for subsequent backlight devices as a
-	 * fallback when the default name already exists.
-	 */
-	if (IS_ERR(bd) && PTR_ERR(bd) == -EEXIST) {
+	bd = backlight_device_get_by_name(name);
+	if (bd) {
+		put_device(&bd->dev);
+		/*
+		 * Using the same name independent of the drm device or connector
+		 * prevents registration of multiple backlight devices in the
+		 * driver. However, we need to use the default name for backward
+		 * compatibility. Use unique names for subsequent backlight devices as a
+		 * fallback when the default name already exists.
+		 */
 		kfree(name);
 		name = kasprintf(GFP_KERNEL, "card%d-%s-backlight",
 				 i915->drm.primary->index, connector->base.name);
 		if (!name)
 			return -ENOMEM;
-
-		bd = backlight_device_register(name, connector->base.kdev, connector,
-					       &intel_backlight_device_ops, &props);
 	}
+	bd = backlight_device_register(name, connector->base.kdev, connector,
+				       &intel_backlight_device_ops, &props);
 
 	if (IS_ERR(bd)) {
 		drm_err(&i915->drm,
-- 
2.35.1



