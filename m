Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE06D6DD7
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 22:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbjDDUSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 16:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjDDUSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 16:18:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284A93C2F
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 13:18:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ew6so135404742edb.7
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 13:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680639530; x=1683231530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSDlWgg4ingjdHiQtrqp7fyydG+cf1eYuIpjxsoT8KE=;
        b=BZMfJkDernfSAFgiG2D1K/OJlBO0sGpNgbSqRX/wFoyu1ANUN61Asrv+zOmfVAmief
         T/99u4DDTQsofV3mKbT52gDDKT+kPNNBBGFmHmzW3alte7c+OCAecZWi8QcnLU1kTlP0
         ZXJ5HQfdKmhJtwFIx0MTaZQaTRg2Eh8sozT+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680639530; x=1683231530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSDlWgg4ingjdHiQtrqp7fyydG+cf1eYuIpjxsoT8KE=;
        b=eqwktUXbmpATU9Z7f/UIRr6YysdGzcJ7QKOnRSm1fBdYDwfRHhSZo1ITzEw14wKfhT
         VkvnltxJ6FjYoWf4yUsmtMUdRZD5WNZ4o8a9aZGWUswos/90ws8qqEZFoQDaBCGM9irh
         M0XD86snJrvOxC/h3dfAeT55Agj0iS4eWWsP1YOnpJ+qd80YHfJtPYjOBZ+LnqzGQxd7
         s1AGSGpMmR6y4hYX+Bs8Hf3sVWbXroQua7GZ9L64EFoQ6HfsVkCadQSkYbqsT6RnkGQ9
         8s85TN/bYFsoM89bMmnGQxmiMmaocEqBrx/2ML4eSbVsuOv7ja4kO913I0G5Ir7XGASa
         rQJA==
X-Gm-Message-State: AAQBX9ewR3iZwECVet/hqLHN1+zPMEZ3AwaZ1zigtmQB7ICpaVswcVLJ
        nXDDjcWq38ymAxSrVLuvCRMwLPfFAWIHno6fPjo=
X-Google-Smtp-Source: AKy350bwR7CNufOWdbV4piMo4MTC9qKIpfr0yQ4Go3etFT7ffNsUzWgAiLsXpgKelDApaaRd1+W/ZA==
X-Received: by 2002:a05:6402:4413:b0:502:92d:4f50 with SMTP id y19-20020a056402441300b00502092d4f50mr872075eda.1.1680639530588;
        Tue, 04 Apr 2023 13:18:50 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id u12-20020a50c04c000000b004d8d2735251sm6367986edd.43.2023.04.04.13.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:18:50 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Aaron Plattner <aplattner@nvidia.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 7/8] video/aperture: Only remove sysfb on the default vga pci device
Date:   Tue,  4 Apr 2023 22:18:41 +0200
Message-Id: <20230404201842.567344-7-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230404201842.567344-1-daniel.vetter@ffwll.ch>
References: <20230404201842.567344-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of calling aperture_remove_conflicting_devices() to remove the
conflicting devices, just call to aperture_detach_devices() to detach
the device that matches the same PCI BAR / aperture range. Since the
former is just a wrapper of the latter plus a sysfb_disable() call,
and now that's done in this function but only for the primary devices.

This fixes a regression introduced by ee7a69aa38d8 ("fbdev: Disable
sysfb device registration when removing conflicting FBs"), where we
remove the sysfb when loading a driver for an unrelated pci device,
resulting in the user loosing their efifb console or similar.

Note that in practice this only is a problem with the nvidia blob,
because that's the only gpu driver people might install which does not
come with an fbdev driver of it's own. For everyone else the real gpu
driver will restore a working console.

Also note that in the referenced bug there's confusion that this same
bug also happens on amdgpu. But that was just another amdgpu specific
regression, which just happened to happen at roughly the same time and
with the same user-observable symptoms. That bug is fixed now, see
https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15

Note that we should not have any such issues on non-pci multi-gpu
issues, because I could only find two such cases:
- SoC with some external panel over spi or similar. These panel
  drivers do not use drm_aperture_remove_conflicting_framebuffers(),
  so no problem.
- vga+mga, which is a direct console driver and entirely bypasses all
  this.

For the above reasons the cc: stable is just notionally, this patch
will need a backport and that's up to nvidia if they care enough.

v2:
- Explain a bit better why other multi-gpu that aren't pci shouldn't
  have any issues with making all this fully pci specific.

v3
- polish commit message (Javier)

Fixes: ee7a69aa38d8 ("fbdev: Disable sysfb device registration when removing conflicting FBs")
Tested-by: Aaron Plattner <aplattner@nvidia.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
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
index 8f1437339e49..2394c2d310f8 100644
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
 
 	if (primary) {
-- 
2.40.0

