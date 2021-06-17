Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3783ABE31
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhFQVfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 17:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhFQVfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 17:35:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89E1C061760
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 14:33:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h16so4559851pjv.2
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 14:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fS1IJ6TzwO6C+OzSRzcjdeJWlMUD6y1F2r8zjTclHRs=;
        b=jNVuog+4ffatfbk+9lGpyumsZBu+LAjqmSc9EpVk91rzyDnwBBGfOVIkhWfUdAGk0Z
         dQgPmqzpHQnzXIW7xBFIOJF8NkIT+e+r5VfM3+vfbZr/wZqAJL06aJhwldhuk9IoxOJI
         2GdW6WIIWznYq7o8TqUsBQFQYYpSPYoHxeV3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fS1IJ6TzwO6C+OzSRzcjdeJWlMUD6y1F2r8zjTclHRs=;
        b=b6jXS8Zdz9gDNYDJDpm9wObW45lrpI7xO1M8Q8+UZs/EYpfnF4XmxPo3+WLrVPP3J9
         GhXcOL712SnI5jnvOVC7CM38ADBcOQEYOimVPph7SRgVfu6RamI7XM6k+oZIFFl7fJqH
         W3Z/RY/ryaAvP+Po0Dl8BRreiIm/jrsNt9gi9U5HkX7FgQqiFLa9bL7chwG/nA8VZfuF
         Jy3Z0FCkVmoSE91T1m1A2LuZfJh2XNsr5w8BTH038MmRGDJWYf/Cg9Nre8pHiKdGyBGM
         MsXLrx9v69HhLiBc7O657RunD5asv4dTvqVsX9Rw6Pt83K31RZ4MP3HGcKrKHbryCrzY
         F37w==
X-Gm-Message-State: AOAM531v0ePj8M5+avf1Ajs3VQJPh/02DvSVf4TVGy371+hKfgh91Uvp
        oXZQ7QzX6mR3r9uP8PlHLdj8Ew==
X-Google-Smtp-Source: ABdhPJxbWQKZLjs+rw64HWqBE7ko7yyXGjKQE49Pupm/Cr9/rCzk+XZ1xIl4rS1QaviH3cca3qmeRg==
X-Received: by 2002:a17:90b:1188:: with SMTP id gk8mr7335611pjb.138.1623965584305;
        Thu, 17 Jun 2021 14:33:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j3sm6070951pfe.98.2021.06.17.14.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:33:03 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-hardening@vger.kernel.org
Subject: [PATCH] drm/i915/display: Do not zero past infoframes.vsc
Date:   Thu, 17 Jun 2021 14:33:01 -0700
Message-Id: <20210617213301.1824728-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; g=159c28c0988fe3dd328148661b4874971d7d94b5; i=nJcT74OCxmrsu5fVKZDiyHDOdGmj9X8nJA8lBJQl7ec=; m=q1YJ++MeJDFcFl+Cf3nxp20mAdZ+kSexLTyJPU0JBMU=; p=LX6t+7jX+yB87pAiW5zd+P27H8PBFA92eg7Pfg2toyg=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDLv40ACgkQiXL039xtwCZo4BAAg6l 3wUzLYLJ3MHZ+4OqpqZBB9HzXAQSuTl+cIaRgktEYXmXjticTEsiuuLw2nE/0aSND5a9mT3YphdEV rcPQ9Kt6R9Ia+Std/Um8I17ooXyzeIp/2ADQZlTgAx9y+oJup9rbxQQiABcLOGZ4LZxzHxry0EsLH 0ByltM1dqT3L9ocCQQYRZf1XXtULUHkHesRRTroCIJLhPff7+SkjYHjBv6tvPYBBb3I2o8gFIEyVx 6/w+MGgxi9Tu7HEuxPquYv9a6JYyQ3aMfGhlj61tl5EHgQNh1AIS1Pp1DXprS11cT4y6FJw9PkwdJ GpmawGNzd+dYN/AMhv9vtlrgcIBxBwEWhglAJRnUgdeXRwDpgjdH+UU/0fC0w9I7A56fzZ1R1Jhsy TMo2IdjskPU+KKUso9RXlpD5HuLCX940sE33xkqJWhqzk2ATnQ0BMqNvrlm7yq1Z3YCkUlPG8Paii 65fo7E/sT7PXgMOnu3YPqyLdbQBi9D/R9sfVp776P32vhUVtxiLM7P3MPf3rA70PlMnNGhylQxByx cj5wr63IbSqHlfRd4xK8NwuqbE6+GJBWKy2Jbg29RhcQptMHc49v8L7gyIiotHSieJJ7HgfH2W2MN 8/zm5lbxidhpb6TkTotHkqmVuawhIt3OLogK1248NkFEZTaISnZhWycT7mWMAelk=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

intel_dp_vsc_sdp_unpack() was using a memset() size (36, struct dp_sdp)
larger than the destination (24, struct drm_dp_vsc_sdp), clobbering
fields in struct intel_crtc_state after infoframes.vsc. Use the actual
target size for the memset().

Fixes: 1b404b7dbb10 ("drm/i915/dp: Read out DP SDPs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 5c9222283044..6cc03b9e4321 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2868,7 +2868,7 @@ static int intel_dp_vsc_sdp_unpack(struct drm_dp_vsc_sdp *vsc,
 	if (size < sizeof(struct dp_sdp))
 		return -EINVAL;
 
-	memset(vsc, 0, size);
+	memset(vsc, 0, sizeof(*vsc));
 
 	if (sdp->sdp_header.HB0 != 0)
 		return -EINVAL;
-- 
2.25.1

