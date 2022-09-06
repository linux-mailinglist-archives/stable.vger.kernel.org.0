Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D132E5AECD6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiIFOAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbiIFN7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADB5832DB;
        Tue,  6 Sep 2022 06:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93D6B61548;
        Tue,  6 Sep 2022 13:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEE6C433D7;
        Tue,  6 Sep 2022 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471739;
        bh=VZDeB/Ki8EK3bieBo8O/ewpnaxgWI/VoASZ8LVQkFUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHVw00TEuqGrfSP+HEmimPeNUetdjtEFupy2lk8dRnlicQCDhRtYpo8/TBU8cNJYO
         kVs36O+9klYPaUIrifGVDeYzTc7oj/bR0iANwbTG7d0qYZuazxYtTS/4ps/dLchx04
         cyAhMsMyd/d51wWG89X9zBws8sVcgcQR6du4x4tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun R Murthy <arun.r.murthy@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 021/155] drm/i915/display: avoid warnings when registering dual panel backlight
Date:   Tue,  6 Sep 2022 15:29:29 +0200
Message-Id: <20220906132830.318992995@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index c8e1fc53a881f..79f8a586623dc 100644
--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -970,26 +970,24 @@ int intel_backlight_device_register(struct intel_connector *connector)
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



