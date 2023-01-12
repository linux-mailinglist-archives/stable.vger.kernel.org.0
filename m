Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF97E668424
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 21:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjALUm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 15:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbjALUmG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 15:42:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24FB76AC1
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:12:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 012FC3505B;
        Thu, 12 Jan 2023 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673554320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xar8pXmKetwoRnV4ZeNTqm/Qm8vEkDqxH/VsBrUwJNk=;
        b=Z+QnjGBIIoGox++T8uxpUQvjwxAz6q1i5vREEJbrkwZPKoOy8ToZpO27py5ZoYo4/p/C+o
        s3WY9Dc5j6Sk4gAKvKHJXAzgIx9YoRwsHm1ds4T5HJPwP8Hs/d5AbVHzRNTmfv1nb4uIFD
        qOLMrP30AFQfX+YmjYRCKvEqijZfALU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673554320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xar8pXmKetwoRnV4ZeNTqm/Qm8vEkDqxH/VsBrUwJNk=;
        b=DD7Gn41GmJLkZ7NHm+O5eXrCtxRwkUWH0xOhxn/ovcpmvuLKpfTN0KrYt1kpfSYeGiN8su
        HBv5WeoRW6mf+KBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51EAE1377D;
        Thu, 12 Jan 2023 20:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sDo0E49pwGMGKgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 12 Jan 2023 20:11:59 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     alexander.deucher@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        bskeggs@redhat.com, kherbst@redhat.com, lyude@redhat.com,
        evan.quan@amd.com, jose.souza@intel.com
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Stanley Yang <Stanley.Yang@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>,
        Xiaojian Du <Xiaojian.Du@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] drm/fb-helper: Set framebuffer for vga-switcheroo clients
Date:   Thu, 12 Jan 2023 21:11:55 +0100
Message-Id: <20230112201156.26849-3-tzimmermann@suse.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112201156.26849-1-tzimmermann@suse.de>
References: <20230112201156.26849-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set the framebuffer info for drivers that support VGA switcheroo. Only
affects the amdgpu and nouveau drivers, which use VGA switcheroo and
generic fbdev emulation. For other drivers, this does nothing.

This fixes a potential regression in the console code. Both, amdgpu and
nouveau, invoked vga_switcheroo_client_fb_set() from their internal fbdev
code. But the call got lost when the drivers switched to the generic
emulation.

Fixes: 087451f372bf ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Fixes: 4a16dd9d18a0 ("drm/nouveau/kms: switch to drm fbdev helpers")
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Evan Quan <evan.quan@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Stanley Yang <Stanley.Yang@amd.com>
Cc: "Tianci.Yin" <tianci.yin@amd.com>
Cc: Xiaojian Du <Xiaojian.Du@amd.com>
Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: YiPeng Chai <YiPeng.Chai@amd.com>
Cc: Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>
Cc: Bokun Zhang <Bokun.Zhang@amd.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Solomon Chiu <solomon.chiu@amd.com>
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: "Marek Olšák" <marek.olsak@amd.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.17+
---
 drivers/gpu/drm/drm_fb_helper.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 427631706128..5e445c61252d 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -30,7 +30,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/console.h>
+#include <linux/pci.h>
 #include <linux/sysrq.h>
+#include <linux/vga_switcheroo.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_drv.h>
@@ -1940,6 +1942,7 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 					 int preferred_bpp)
 {
 	struct drm_client_dev *client = &fb_helper->client;
+	struct drm_device *dev = fb_helper->dev;
 	struct drm_fb_helper_surface_size sizes;
 	int ret;
 
@@ -1961,6 +1964,11 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 		return ret;
 
 	strcpy(fb_helper->fb->comm, "[fbcon]");
+
+	/* Set the fb info for vgaswitcheroo clients. Does nothing otherwise. */
+	if (dev_is_pci(dev->dev))
+		vga_switcheroo_client_fb_set(to_pci_dev(dev->dev), fb_helper->info);
+
 	return 0;
 }
 
-- 
2.39.0

