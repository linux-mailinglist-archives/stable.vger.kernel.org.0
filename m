Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5644D63E
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 12:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhKKMBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:01:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233128AbhKKMBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636631911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GpCy36el8L/qh4Uk9yDbL7KgAnUqMJxvY/v6l31jKkQ=;
        b=aBvTABNtxY/gwmMLtyaON0YTr+St53/hSkfqr+l9v8dSloJI6go8Ueh9tpIhjaa4PxmtBF
        PuEMS3sfASAalXf2M2NBkRR+g+T6LhH7uD0JbDQxtgthuzdEvVjVLCIB9H6h7djD41+wAg
        QVbPujz+hovAO/kKd1NKGydRayFOFZg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-BJ-DrifEPJi8hXSEjEOB8g-1; Thu, 11 Nov 2021 06:58:30 -0500
X-MC-Unique: BJ-DrifEPJi8hXSEjEOB8g-1
Received: by mail-wm1-f69.google.com with SMTP id b133-20020a1c808b000000b0032cdd691994so4682782wmd.1
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 03:58:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GpCy36el8L/qh4Uk9yDbL7KgAnUqMJxvY/v6l31jKkQ=;
        b=o+7SNjDQrh4XA/37K3egShKjKaKBnoeggcweI9n1oLdiPtlC4Oh3cc0VjQTyzJEt11
         55eViFnCfRCaiF9BNsPordd/8hc6qJB897GdLZAWXCQSjVb4Ny0xgiNO5tnXfB5FX7Wf
         DhjIC7kfj4MUy42fWlaaGTZRa8LOtwsLYIZcP+Rs3JbNzqpOyOF/0MG3UIW1jT2L2yTc
         o6expg6oB46NMspecjMraOaMlin+OnhMvq5bT+eCylHqYq6KPqq0Xe3EoUaJcSb2Cmuj
         0Gsihy4F/FKB582CR2+zkhm9AfSf2ST85shPaHlyNNUsbqB6AGQwagtxnlpUGaWv/2HD
         esNQ==
X-Gm-Message-State: AOAM530iH/IsWWsJRca05OxaPlA8wBEa9nb+fjU6KNehLpOLlRz7sc52
        T6bQaIdk9segUF6bbgE16w7K4Tj2Svsi1LOhTWxZAuBq2H/shsZblG6iiRuNdYXYWTnNNGnZT2B
        rSd2LoMmS708a6gLD
X-Received: by 2002:adf:ecce:: with SMTP id s14mr8119958wro.98.1636631909109;
        Thu, 11 Nov 2021 03:58:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfoIxf570FYpycJGE2UH3Ewq0I2fnG+SXfzWg9ZPKr71MsC8o/krxHefoSdTddnQ59oHIKuw==
X-Received: by 2002:adf:ecce:: with SMTP id s14mr8119917wro.98.1636631908877;
        Thu, 11 Nov 2021 03:58:28 -0800 (PST)
Received: from minerva.redhat.com ([92.176.231.106])
        by smtp.gmail.com with ESMTPSA id l7sm3588756wry.86.2021.11.11.03.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 03:58:23 -0800 (PST)
From:   Javier Martinez Canillas <fmartine@redhat.com>
X-Google-Original-From: Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Jones <pjones@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        linux-fbdev@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Ilya Trukhanov <lahvuun@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3] fbdev: Prevent probing generic drivers if a FB is already registered
Date:   Thu, 11 Nov 2021 12:57:57 +0100
Message-Id: <20211111115757.1351045-1-javierm@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The efifb and simplefb drivers just render to a pre-allocated frame buffer
and rely on the display hardware being initialized before the kernel boots.

But if another driver already probed correctly and registered a fbdev, the
generic drivers shouldn't be probed since an actual driver for the display
hardware is already present.

This is more likely to occur after commit d391c5827107 ("drivers/firmware:
move x86 Generic System Framebuffers support") since the "efi-framebuffer"
and "simple-framebuffer" platform devices are registered at a later time.

Link: https://lore.kernel.org/r/20211110200253.rfudkt3edbd3nsyj@lahvuun/
Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
Reported-by: Ilya Trukhanov <lahvuun@gmail.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---

Changes in v3:
- Cc <stable@vger.kernel.org> since a Fixes: tag is not enough (gregkh).

Changes in v2:
- Add a Link: tag with a reference to the bug report (Thorsten Leemhuis).
- Add a comment explaining why the probe fails earlier (Daniel Vetter).
- Add a Fixes: tag for stable to pick the fix (Daniel Vetter).
- Add Daniel Vetter's Reviewed-by: tag.
- Improve the commit message and mention the culprit commit

 drivers/video/fbdev/efifb.c    | 11 +++++++++++
 drivers/video/fbdev/simplefb.c | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git drivers/video/fbdev/efifb.c drivers/video/fbdev/efifb.c
index edca3703b964..ea42ba6445b2 100644
--- drivers/video/fbdev/efifb.c
+++ drivers/video/fbdev/efifb.c
@@ -351,6 +351,17 @@ static int efifb_probe(struct platform_device *dev)
 	char *option = NULL;
 	efi_memory_desc_t md;
 
+	/*
+	 * Generic drivers must not be registered if a framebuffer exists.
+	 * If a native driver was probed, the display hardware was already
+	 * taken and attempting to use the system framebuffer is dangerous.
+	 */
+	if (num_registered_fb > 0) {
+		dev_err(&dev->dev,
+			"efifb: a framebuffer is already registered\n");
+		return -EINVAL;
+	}
+
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
 		return -ENODEV;
 
diff --git drivers/video/fbdev/simplefb.c drivers/video/fbdev/simplefb.c
index 62f0ded70681..b63074fd892e 100644
--- drivers/video/fbdev/simplefb.c
+++ drivers/video/fbdev/simplefb.c
@@ -407,6 +407,17 @@ static int simplefb_probe(struct platform_device *pdev)
 	struct simplefb_par *par;
 	struct resource *mem;
 
+	/*
+	 * Generic drivers must not be registered if a framebuffer exists.
+	 * If a native driver was probed, the display hardware was already
+	 * taken and attempting to use the system framebuffer is dangerous.
+	 */
+	if (num_registered_fb > 0) {
+		dev_err(&pdev->dev,
+			"simplefb: a framebuffer is already registered\n");
+		return -EINVAL;
+	}
+
 	if (fb_get_options("simplefb", NULL))
 		return -ENODEV;
 
-- 
2.33.1

