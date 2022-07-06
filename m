Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD686568D95
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbiGFPeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiGFPeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:34:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BBB27CF3;
        Wed,  6 Jul 2022 08:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0871CB81DA0;
        Wed,  6 Jul 2022 15:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07D2C341CB;
        Wed,  6 Jul 2022 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121562;
        bh=SuF4v3Uz5uTNz8Vjlm3/PnuewX3rlJ5M1kikWnOZ87c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTBeXQz0oNYhMI0zlHUhM/ekv3yFAi3QwatUqmX4b8QXGv+ZAp3b/jvA/rdta9CKh
         V7yZhuxGfS9FqS/V+f2fLSYqRq4pJ/h+EG5W7+RvzkO3EEMWWRle4Zss69Wu+EPMTY
         Ym3q0bhYAEcB+Q/BJCxAB8yymR35FdYbrGQqNAJ/b7PLIq36h4LCBgzYW/eRi1UipI
         gRAssySm7bkanMfols7CqIZK+09Ux7N64q1QGnnd9IT38aKUYHIjGzMlZn5ZGvsKHz
         b2yt59zFU6DUxQAxI1Exb5jpG46r9UtMHlp7hhNgL4GaF8pfduCdp7amQ46Om2RiYy
         G/YCsqNLgmnrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        tzimmermann@suse.de, bp@suse.de, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/18] firmware: sysfb: Add sysfb_disable() helper function
Date:   Wed,  6 Jul 2022 11:31:47 -0400
Message-Id: <20220706153153.1598076-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153153.1598076-1-sashal@kernel.org>
References: <20220706153153.1598076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit bde376e9de3c0bc55eedc8956b0f114c05531595 ]

This can be used by subsystems to unregister a platform device registered
by sysfb and also to disable future platform device registration in sysfb.

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220607182338.344270-3-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../driver-api/firmware/other_interfaces.rst  |  6 +++
 drivers/firmware/sysfb.c                      | 54 ++++++++++++++++---
 include/linux/sysfb.h                         | 12 +++++
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/firmware/other_interfaces.rst b/Documentation/driver-api/firmware/other_interfaces.rst
index b81794e0cfbb..06ac89adaafb 100644
--- a/Documentation/driver-api/firmware/other_interfaces.rst
+++ b/Documentation/driver-api/firmware/other_interfaces.rst
@@ -13,6 +13,12 @@ EDD Interfaces
 .. kernel-doc:: drivers/firmware/edd.c
    :internal:
 
+Generic System Framebuffers Interface
+-------------------------------------
+
+.. kernel-doc:: drivers/firmware/sysfb.c
+   :export:
+
 Intel Stratix10 SoC Service Layer
 ---------------------------------
 Some features of the Intel Stratix10 SoC require a level of privilege
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index b032f40a92de..1f276f108cc9 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -34,21 +34,59 @@
 #include <linux/screen_info.h>
 #include <linux/sysfb.h>
 
+static struct platform_device *pd;
+static DEFINE_MUTEX(disable_lock);
+static bool disabled;
+
+static bool sysfb_unregister(void)
+{
+	if (IS_ERR_OR_NULL(pd))
+		return false;
+
+	platform_device_unregister(pd);
+	pd = NULL;
+
+	return true;
+}
+
+/**
+ * sysfb_disable() - disable the Generic System Framebuffers support
+ *
+ * This disables the registration of system framebuffer devices that match the
+ * generic drivers that make use of the system framebuffer set up by firmware.
+ *
+ * It also unregisters a device if this was already registered by sysfb_init().
+ *
+ * Context: The function can sleep. A @disable_lock mutex is acquired to serialize
+ *          against sysfb_init(), that registers a system framebuffer device.
+ */
+void sysfb_disable(void)
+{
+	mutex_lock(&disable_lock);
+	sysfb_unregister();
+	disabled = true;
+	mutex_unlock(&disable_lock);
+}
+EXPORT_SYMBOL_GPL(sysfb_disable);
+
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
 	struct simplefb_platform_data mode;
-	struct platform_device *pd;
 	const char *name;
 	bool compatible;
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&disable_lock);
+	if (disabled)
+		goto unlock_mutex;
 
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
 		pd = sysfb_create_simplefb(si, &mode);
 		if (!IS_ERR(pd))
-			return 0;
+			goto unlock_mutex;
 	}
 
 	/* if the FB is incompatible, create a legacy framebuffer device */
@@ -60,8 +98,10 @@ static __init int sysfb_init(void)
 		name = "platform-framebuffer";
 
 	pd = platform_device_alloc(name, 0);
-	if (!pd)
-		return -ENOMEM;
+	if (!pd) {
+		ret = -ENOMEM;
+		goto unlock_mutex;
+	}
 
 	sysfb_apply_efi_quirks(pd);
 
@@ -73,9 +113,11 @@ static __init int sysfb_init(void)
 	if (ret)
 		goto err;
 
-	return 0;
+	goto unlock_mutex;
 err:
 	platform_device_put(pd);
+unlock_mutex:
+	mutex_unlock(&disable_lock);
 	return ret;
 }
 
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index 708152e9037b..8ba8b5be5567 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -55,6 +55,18 @@ struct efifb_dmi_info {
 	int flags;
 };
 
+#ifdef CONFIG_SYSFB
+
+void sysfb_disable(void);
+
+#else /* CONFIG_SYSFB */
+
+static inline void sysfb_disable(void)
+{
+}
+
+#endif /* CONFIG_SYSFB */
+
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
-- 
2.35.1

