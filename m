Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDBF487638
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 12:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347005AbiAGLHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 06:07:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237725AbiAGLHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 06:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641553656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mErlQ9bFbWCh8pEI+M0nh3UElgFrVyLNdlmQovZz1FE=;
        b=XQrqtJLfC7yoOodnMylFN8HTiwKMGpZn4HYW9KK554ly2Xuk4aLBPhLPrSAyj+35Jq/pl8
        jh6iE6sNyOqrjWD+8HT/Bnrq/71jwOTULcTgqm6zT6LJ5zOQdw0W1ZgvOnmh6x6gm4w/D3
        1umiAYT0W9OV2N7Vx8LxoQc+omA4HfA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-VkAYQFaiMz-eRqs48LTZ9A-1; Fri, 07 Jan 2022 06:07:35 -0500
X-MC-Unique: VkAYQFaiMz-eRqs48LTZ9A-1
Received: by mail-wm1-f70.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so4525277wmq.0
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 03:07:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mErlQ9bFbWCh8pEI+M0nh3UElgFrVyLNdlmQovZz1FE=;
        b=X+VD0ra/FCs4i5qAIEUMXWIMyFx4Nv/sFPnOfPrBz4OzYT/DDtRBfGgZ7AjtpamQLp
         lUcCIQSJzKPq8gw7c0hkvGietuTxjenanDTuMqKiOtDoIrUaC2cEqvGnuwD7GP+b9tTm
         JYJbds59BgLnksxObeyfB8I1VXfio2hM9MGHN03GkGwnUUJccRyF2JIXjZ7R3QRxUj5i
         S8OdKdKBtM+VCE5+r1HrRHkAzD5rtm7jzoF7yXDc2Ogd21wMY5dXskBfrgVRjuVGXkpg
         cCe8Q8gvlYGmPbmuL1DQuPkh26g7eO77snYwoKbjX4ky5fuetqApFqGO3gKdUh0n8fbp
         kaVg==
X-Gm-Message-State: AOAM531y98IW0QYDTQNcdYODfW1m5jCRR+CnqVCp3FQOoIsyGunEmm+v
        r2xB7H204ielFbYMRPwq0szwEGEEOYN8ezO17bxQsbvauSxjom7Hlv8KrGXVJclGA9lOMaWOzWZ
        itnpkBMR4yGXctBwv
X-Received: by 2002:adf:d1ef:: with SMTP id g15mr56009298wrd.198.1641553654029;
        Fri, 07 Jan 2022 03:07:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpfs8sNGNszizzpb8wIqMXaS0IM36pG7DV7riTr9kWpDEc6r6DU/cu0qurtWMt/rqjTZw+Ug==
X-Received: by 2002:adf:d1ef:: with SMTP id g15mr56009285wrd.198.1641553653870;
        Fri, 07 Jan 2022 03:07:33 -0800 (PST)
Received: from minerva.home ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id r9sm9337273wmq.18.2022.01.07.03.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 03:07:33 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Kris Karas <bugs-a21@moonlit-rail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/2] video: vga16fb: Only probe for EGA and VGA 16 color graphic cards
Date:   Fri,  7 Jan 2022 12:07:23 +0100
Message-Id: <20220107110723.323276-3-javierm@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107110723.323276-1-javierm@redhat.com>
References: <20220107110723.323276-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The vga16fb framebuffer driver only supports Enhanced Graphics Adapter
(EGA) and Video Graphics Array (VGA) 16 color graphic cards.

But it doesn't check if the adapter is one of those or if a VGA16 mode
is used. This means that the driver will be probed even if a VESA BIOS
Extensions (VBE) or Graphics Output Protocol (GOP) interface is used.

This issue has been present for a long time but it was only exposed by
commit d391c5827107 ("drivers/firmware: move x86 Generic System
Framebuffers support") since the platform device registration to match
the {vesa,efi}fb drivers is done later as a consequence of that change.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215001
Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Kris Karas <bugs-a21@moonlit-rail.com>
---

 drivers/video/fbdev/vga16fb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/video/fbdev/vga16fb.c b/drivers/video/fbdev/vga16fb.c
index 3347c9b6a332..72b6aeceeff8 100644
--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -1422,6 +1422,18 @@ static int __init vga16fb_init(void)
 
 	vga16fb_setup(option);
 #endif
+
+	/* only EGA and VGA in 16 color graphic mode are supported */
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EGAC &&
+	    screen_info.orig_video_isVGA != VIDEO_TYPE_VGAC)
+		return -ENODEV;
+
+	if (screen_info.orig_video_mode != 0x0D &&	/* 320x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x0E &&	/* 640x200/4 (EGA) */
+	    screen_info.orig_video_mode != 0x10 &&	/* 640x350/4 (EGA) */
+	    screen_info.orig_video_mode != 0x12)	/* 640x480/4 (VGA) */
+		return -ENODEV;
+
 	ret = platform_driver_register(&vga16fb_driver);
 
 	if (!ret) {
-- 
2.33.1

