Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6AB665F6F
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjAKPlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 10:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbjAKPli (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 10:41:38 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB62BA1
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 07:41:36 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so2805145wml.0
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 07:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6J5rucn+hYvg3m1RRrffzZkT45tj6msLk6PzkRA+oVc=;
        b=UVhq2xNFtKTEbVePhTQcD+DkCgbC/RTrE0C4YZitCzyqe4S737uZqLY3u5UyA5WYdh
         DU1EQp1fcY/CsFWajQS4me7Fr87/4MjvTP/R0kLn9HFvOw1ZaYON/UzLgbPfAX349II2
         SzM9iGgw+0+m+eT166Z18NC4dIm8W4gJUqyaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6J5rucn+hYvg3m1RRrffzZkT45tj6msLk6PzkRA+oVc=;
        b=R5WRRkzLBp9ANjB4FfhuoBzg2RZSn9aZENFgfV9FnZ1k6vFWPK8uDfFpT9M2/XhHCk
         2Mz/jUPdXXMhlrT6GoloBiVs+pM1PzdhTQMLeL2lfu//V8Hu+PAfUaYiVwtGDe9POmBU
         hoZ0fKD1E5ZMvD1WuIHP7ArfAZmCbAn/PyfD3lfVdDmr89Mou1G9mYm+zFbSEabEePy0
         0VG7kULfEqOcVMxxc90l/yH2mtwJ0LBcgOrDEqHzSVBWZem7xF+PLNU2FHKxiKXdvJBP
         gK5Tos54PllZVi2WQGdw64fuRoURrsWFoWtu95L4LBtXAd2sc5zmzh0jdYjBAUkDrmK4
         HyeA==
X-Gm-Message-State: AFqh2kqx12AkFRuCdntavtJzAJu7ZAE8JqqjAnXsu25r2zGJovvPv0Jv
        5uMCfAQHekvkt05kazMN6uUv/g==
X-Google-Smtp-Source: AMrXdXvBiLYhTqGktmEP4PMNp1JbLfml6xV45lGs5rGOwSwmCAckYzjJbZ16o4yMyZHtvwGJu10yJg==
X-Received: by 2002:a05:600c:3b8f:b0:3d0:480b:ac53 with SMTP id n15-20020a05600c3b8f00b003d0480bac53mr55362290wms.12.1673451695486;
        Wed, 11 Jan 2023 07:41:35 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b003d9e74dd9b2sm15936149wmq.9.2023.01.11.07.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 07:41:34 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Aaron Plattner <aplattner@nvidia.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 11/11] video/aperture: Only remove sysfb on the default vga pci device
Date:   Wed, 11 Jan 2023 16:41:12 +0100
Message-Id: <20230111154112.90575-11-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a regression introduced by ee7a69aa38d8 ("fbdev: Disable
sysfb device registration when removing conflicting FBs"), where we
remove the sysfb when loading a driver for an unrelated pci device,
resulting in the user loosing their efifb console or similar.

Note that in practice this only is a problem with the nvidia blob,
because that's the only gpu driver people might install which does not
come with an fbdev driver of it's own. For everyone else the real gpu
driver will restor a working console.

Also note that in the referenced bug there's confusion that this same
bug also happens on amdgpu. But that was just another amdgpu specific
regression, which just happened to happen at roughly the same time and
with the same user-observable symptons. That bug is fixed now, see
https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15

For the above reasons the cc: stable is just notionally, this patch
will need a backport and that's up to nvidia if they care enough.

References: https://bugzilla.kernel.org/show_bug.cgi?id=216303#c28
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org> # v5.19+ (if someone else does the backport)
---
 drivers/video/aperture.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index ba565515480d..a1821d369bb1 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -321,15 +321,16 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
 
 	primary = pdev == vga_default_device();
 
+	if (primary)
+		sysfb_disable();
+
 	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
 		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
 			continue;
 
 		base = pci_resource_start(pdev, bar);
 		size = pci_resource_len(pdev, bar);
-		ret = aperture_remove_conflicting_devices(base, size, name);
-		if (ret)
-			return ret;
+		aperture_detach_devices(base, size);
 	}
 
 	if (!primary)
-- 
2.39.0

