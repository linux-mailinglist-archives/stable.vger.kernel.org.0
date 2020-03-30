Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6D19813E
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgC3QaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:30:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42828 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729444AbgC3QaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:30:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id e1so6919195plt.9;
        Mon, 30 Mar 2020 09:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YsFnz05oWNhz5mB25S0tg2/lHQPk1r/Q+IZIha4yD4g=;
        b=JdZ85hCh2IWweTJsm7TzpgIDVDkqZMFiJ+soe2dtRVw6YicrOBkvlKPkhTq29ZW2q3
         LGHD/qq7NoF4kxJIVDnch7KkDxZpWVdl4u7BlMUezqA2PUD4QC4DxtoC4k0MyTfLYdQo
         onZ8VKcp/N0FWGcg+j2eO48HWbCCZtbQ7hWMqueYERIGBOAqJAHTclXc6wb6zYDXtTpt
         2lyoJFmLWR9XElkF19sxjdnD94c2wm1WJRIXjTwNKK6WgnIg2DxPYVF3WNucsOh5tDsV
         DgtiF7nF/El97+EG7aVc5CO8fvSQ/YisP6ysf4xN5rm6CoynBRFFue8jCWiRsE13Lp/W
         kutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YsFnz05oWNhz5mB25S0tg2/lHQPk1r/Q+IZIha4yD4g=;
        b=VHi7ur2inAEyeaTFeYJGFvGtrYPyWSb+feNxmlrEVcorGxGt2WZgwQjS1eHKVElngq
         wxqLEunZdJRjq6tNpK0MErgXHh7ZLUoXVvVSNNdOlxT4QguZuEdgFF6KkS4fMqQgEhl7
         HUTdyc6ToDPqa2/rnqDoBpjkD36Krl6KyZyDv6TjAgE04JVHvefZoHMTItfp41cyyyd3
         PJswcvPxb4/tKO4OEXAM5cA5TED1vgShb/P654oFZJJTdNzIplK8tYeb2qelf5qCTko6
         lX3hT3VzUxLTRilJZa3PTBF5N9lyldewjRdvntQBM1kWfNHc4EJQL4KuN49GlsRDf6NQ
         EgfQ==
X-Gm-Message-State: AGi0Pub153AU5asy+VILnrkksWyQsl9SXLMdZANLbJgfxm1ED20HlTiF
        ba/rARQY9ViATxumZkLMTdtAIlWY
X-Google-Smtp-Source: APiQypLKwTWLKPEXmnURAH+r7lBTLubzxQ5KTakvKvOjLME40mOemJSUjBpb3ALb+AXhqu6rB+Ycpg==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr50155pjw.128.1585585813996;
        Mon, 30 Mar 2020 09:30:13 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id mu15sm14398pjb.30.2020.03.30.09.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:30:13 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     linux-kernel@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] drm/i915: Disable Panel Self Refresh (PSR) by default
Date:   Mon, 30 Mar 2020 09:30:06 -0700
Message-Id: <20200330163006.4064-2-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200330163006.4064-1-sultan@kerneltoast.com>
References: <20200330163006.4064-1-sultan@kerneltoast.com>
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
correctly on any consumer hardware right now. PSR was enabled by default
in 5.0 for capable hardware, so this patch just restores the previous
functionality of PSR being disabled by default.

More info is available on the freedesktop bug:
https://gitlab.freedesktop.org/drm/intel/issues/425

Cc: <stable@vger.kernel.org> # 5.4.x, 5.5.x
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/i915_params.c | 3 +--
 drivers/gpu/drm/i915/i915_params.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
index 1dd1f3652795..0c4661fcf011 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -85,8 +85,7 @@ i915_param_named_unsafe(enable_hangcheck, bool, 0600,
 
 i915_param_named_unsafe(enable_psr, int, 0600,
 	"Enable PSR "
-	"(0=disabled, 1=enabled) "
-	"Default: -1 (use per-chip default)");
+	"(-1=use per-chip default, 0=disabled [default], 1=enabled) ");
 
 i915_param_named_unsafe(force_probe, charp, 0400,
 	"Force probe the driver for specified devices. "
diff --git a/drivers/gpu/drm/i915/i915_params.h b/drivers/gpu/drm/i915/i915_params.h
index 31b88f297fbc..4a9a3df7d292 100644
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

