Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC474579ED8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbiGSNG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiGSNGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:06:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DF99FE34;
        Tue, 19 Jul 2022 05:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E58D4B81B8A;
        Tue, 19 Jul 2022 12:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516B9C341C6;
        Tue, 19 Jul 2022 12:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233598;
        bh=OrhNMh7u0BUFRUmsuOS9cc2oRviFxpbijjzVLAeCK6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hudXPT6WYC8LKKN8QUERkrR5aYqra9T7p4A6zIu64shjCt6aRqHpOBhl96jpxZ+R2
         Mi/YDef9s8oTIYl9yO9tteppRpnwnK7l/U0FpP9O9naVzkta1Va0MwCObsQ/mYiHnn
         7nnATqICVPQvC2Y/+R9wxdPs4D2a20yz+OL2LafA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 175/231] firmware: sysfb: Make sysfb_create_simplefb() return a pdev pointer
Date:   Tue, 19 Jul 2022 13:54:20 +0200
Message-Id: <20220719114728.880971728@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 9e121040e54abef9ed5542e5fdfa87911cd96204 ]

This function just returned 0 on success or an errno code on error, but it
could be useful for sysfb_init() callers to have a pointer to the device.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220607182338.344270-2-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/sysfb.c          |  4 ++--
 drivers/firmware/sysfb_simplefb.c | 16 ++++++++--------
 include/linux/sysfb.h             | 10 +++++-----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 2bfbb05f7d89..b032f40a92de 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -46,8 +46,8 @@ static __init int sysfb_init(void)
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
-		ret = sysfb_create_simplefb(si, &mode);
-		if (!ret)
+		pd = sysfb_create_simplefb(si, &mode);
+		if (!IS_ERR(pd))
 			return 0;
 	}
 
diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index bda8712bfd8c..a353e27f83f5 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -57,8 +57,8 @@ __init bool sysfb_parse_mode(const struct screen_info *si,
 	return false;
 }
 
-__init int sysfb_create_simplefb(const struct screen_info *si,
-				 const struct simplefb_platform_data *mode)
+__init struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+						     const struct simplefb_platform_data *mode)
 {
 	struct platform_device *pd;
 	struct resource res;
@@ -76,7 +76,7 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 		base |= (u64)si->ext_lfb_base << 32;
 	if (!base || (u64)(resource_size_t)base != base) {
 		printk(KERN_DEBUG "sysfb: inaccessible VRAM base\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/*
@@ -93,7 +93,7 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	length = mode->height * mode->stride;
 	if (length > size) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 	length = PAGE_ALIGN(length);
 
@@ -104,11 +104,11 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	res.start = base;
 	res.end = res.start + length - 1;
 	if (res.end <= res.start)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	pd = platform_device_alloc("simple-framebuffer", 0);
 	if (!pd)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	sysfb_apply_efi_quirks(pd);
 
@@ -124,10 +124,10 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	if (ret)
 		goto err_put_device;
 
-	return 0;
+	return pd;
 
 err_put_device:
 	platform_device_put(pd);
 
-	return ret;
+	return ERR_PTR(ret);
 }
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index b0dcfa26d07b..708152e9037b 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -72,8 +72,8 @@ static inline void sysfb_apply_efi_quirks(struct platform_device *pd)
 
 bool sysfb_parse_mode(const struct screen_info *si,
 		      struct simplefb_platform_data *mode);
-int sysfb_create_simplefb(const struct screen_info *si,
-			  const struct simplefb_platform_data *mode);
+struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+					      const struct simplefb_platform_data *mode);
 
 #else /* CONFIG_SYSFB_SIMPLE */
 
@@ -83,10 +83,10 @@ static inline bool sysfb_parse_mode(const struct screen_info *si,
 	return false;
 }
 
-static inline int sysfb_create_simplefb(const struct screen_info *si,
-					 const struct simplefb_platform_data *mode)
+static inline struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+							    const struct simplefb_platform_data *mode)
 {
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 #endif /* CONFIG_SYSFB_SIMPLE */
-- 
2.35.1



