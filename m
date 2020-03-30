Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745B81972CD
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 05:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgC3DbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 23:31:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38345 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgC3DbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 23:31:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id w3so6186509plz.5
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 20:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RP4sogAjLFxzd4//fXGW951tKyUqDRPaNOLYGNCpjt8=;
        b=bHGAwRl/1HcaNZk9w4mvs36XwX/YB8QXFluH37bE7MHWQWFjk9aPaSr9Nw85hZ9EQL
         Mf4iFbmAlfYc1ibRxYgHFmPhCMd4/6gXMdDgHmml1F3DduOVOlnDcqfQzLZPiabdPpO+
         s1xoxQBr5MyuA9Q2PyNoUYZ1zDi8zPu3jStRiZrybt00PZ6iPVJey61jfbYwTB8ckBrv
         ZO3xTzygpGhz1JuLfi6YEV63l0Eoa9DJmw6zgdOw5HFen7y6YYvlYvo/lcQrYLWVmqwG
         Wo5urAJbm1jo6xwI2ZfVclpj3tNFu2lEtBOJ/BucbR6u7Ae3Vx02eq6+02XQWYha1uDX
         7jCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=RP4sogAjLFxzd4//fXGW951tKyUqDRPaNOLYGNCpjt8=;
        b=RcFHEjwA6oT07/ocX7o1Nd9yaD1UOxdQ++fbBg4uby+leuHcJSgT32rPy8ZaAo0S7v
         7FHuz83+iDTkhZw7fzNKfx/daa/UjHdDaE2JvGlcUz03Djwbd2kQpYoMbXs+GBw+jnLP
         CHPIMYDfDurN2ar+hRV8AtQB1BFK7hc2DBzfge9jKzagmWDAx4tojKybXsgXdivM7quH
         CIohupQDpiM+Ai2CYlgkGwAlJEZaExlMh+CG5G/NMtemXvobpY6Z2AH9WTCKrlwTn9N9
         62VNp70ECbMjJNlPXynxexs/jeMcpLpdIosncUBL/xSnyDgktkgrBIqHpA6dZQxbnbBB
         wcIg==
X-Gm-Message-State: ANhLgQ0b9L9D5d9LxvQTbYpenSk0K8lMxVaYqX4QukfWqNK7/wsJYw1x
        HL4Zd8PetvFwL4YoOqQbQtcAVhPh
X-Google-Smtp-Source: ADFU+vs8Kh7c6PoIl7+wgDMXOlItq51K8Ny1Bo762H2MNph9jmb/eIPg/ojidLopQ6NLQCQFM+6mGQ==
X-Received: by 2002:a17:90a:8d17:: with SMTP id c23mr12993498pjo.187.1585539068587;
        Sun, 29 Mar 2020 20:31:08 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id y193sm8512447pgd.87.2020.03.29.20.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 20:31:08 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     stable@vger.kernel.org
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 1/2] drm/i915: Disable Panel Self Refresh (PSR) by default
Date:   Sun, 29 Mar 2020 20:30:56 -0700
Message-Id: <20200330033057.2629052-2-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200330033057.2629052-1-sultan@kerneltoast.com>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

On all Dell laptops with panels and chipsets that support PSR (an
esoteric power-saving mechanism), both PSR1 and PSR2 cause flickering
and graphical glitches, sometimes to the point of making the laptop
unusable. Many laptops don't support PSR so it isn't known if PSR works
correctly on any consumer hardware as of 5.4. PSR was enabled by default
in 5.0 for capable hardware, so this patch just restores the previous
functionality of PSR being disabled by default.

More info is available on the freedesktop bug:
https://gitlab.freedesktop.org/drm/intel/issues/425

Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/i915_params.c | 3 +--
 drivers/gpu/drm/i915/i915_params.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
index 296452f9efe4..4a0d37f7cf49 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -84,8 +84,7 @@ i915_param_named_unsafe(enable_hangcheck, bool, 0600,
 
 i915_param_named_unsafe(enable_psr, int, 0600,
 	"Enable PSR "
-	"(0=disabled, 1=enabled) "
-	"Default: -1 (use per-chip default)");
+	"(-1=use per-chip default, 0=disabled [default], 1=enabled) ");
 
 i915_param_named_unsafe(force_probe, charp, 0400,
 	"Force probe the driver for specified devices. "
diff --git a/drivers/gpu/drm/i915/i915_params.h b/drivers/gpu/drm/i915/i915_params.h
index d29ade3b7de6..715888811593 100644
--- a/drivers/gpu/drm/i915/i915_params.h
+++ b/drivers/gpu/drm/i915/i915_params.h
@@ -50,7 +50,7 @@ struct drm_printer;
 	param(int, vbt_sdvo_panel_type, -1) \
 	param(int, enable_dc, -1) \
 	param(int, enable_fbc, -1) \
-	param(int, enable_psr, -1) \
+	param(int, enable_psr, 0) \
 	param(int, disable_power_well, -1) \
 	param(int, enable_ips, 1) \
 	param(int, invert_brightness, 0) \
-- 
2.26.0

