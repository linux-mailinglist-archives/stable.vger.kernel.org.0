Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE36948574F
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 18:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiAERdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 12:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiAERdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 12:33:20 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C1C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 09:33:20 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g22so36098226pgn.1
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 09:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nmndt0VkOAtLY1ci31WXQCy4a4STYE251ahE/JdWZjQ=;
        b=eGxZrueRzdgW6cCKEy5n7l9h9+Trx6i1sxweYwIV+uq3y7jPGFmZO3nxIQTLbWZVZR
         NVt1H/t6VulG15QjjsQa1aqGYU2ihZMcCEuPKygXC22IOj7s8C+wFjdzyYPaExyW16ol
         NY+4RPtFN5b3SHVtUAEuSa2IZvZ4cs6FbOqTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nmndt0VkOAtLY1ci31WXQCy4a4STYE251ahE/JdWZjQ=;
        b=y51WjkVjfvYnAhfkdkShQ53GSiHRl9gtGnJRTIJ732RsgUn0Kk8UufwUhRBGyuNZPg
         E2DZuNQxmgEz0/PCs9Pwz2NTmBElXGGBR0TNCiA42ROL1fkFICM/SHZeB4YqY0kxMR7Z
         uadUNlYU8tL/5cQCoP91sBbwyh29z6Kr6mCjVvaAr1ZIHOksb6SHur4Sjh5PP2bUmZAJ
         /65UYolQi4BfYLylthKXYq5gSaG62kakUuRzu5KksI+w3GsmZjmJh19MSA4HsMyDAI+V
         V4YCZB6MRpL5wLY2YbPC0pWcbshkyaPR7+ZWmo4GrCdu3qNYHIbh8QHmxRK9dxNbthi/
         vQSg==
X-Gm-Message-State: AOAM533J6EO/vsgntUp7FerRUalyxF/esWL2tv9l0OPieraR9avbb2Mg
        HdGBxq0auTUWKGq31mA28qp67Q==
X-Google-Smtp-Source: ABdhPJwvWsluov2M3xQQOKdxaYmcA3f5D7ugC6+xoOxa4jnEW4fDKXegJU9tgmb/4zVjisJ12Eip3A==
X-Received: by 2002:a63:8148:: with SMTP id t69mr49651559pgd.318.1641403999583;
        Wed, 05 Jan 2022 09:33:19 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f125sm35804175pfa.28.2022.01.05.09.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 09:33:19 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] drm/dp: Fix off-by-one in register cache size
Date:   Wed,  5 Jan 2022 09:33:10 -0800
Message-Id: <20220105173310.2420598-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2221; h=from:subject; bh=FKzoP1+Ajq0adEYhRP1CewNZxc4TZAiLM0jC2P8yyAU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh1dZWy/nQqWmat0jak1V87p/MQZdy6f8jwBwkG+sK M0Gs7VmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYdXWVgAKCRCJcvTf3G3AJsg9EA CWwI79Dlno4hKxtgvfxb3hGWq5EXAlfZTvAB90dWpess3EFCDDOE5cMKYQKou0opRccmgGwFu0fsPU xTl46z/W9IbbXs5vyTBOJCydBaNUjj/lwR9P7bgXfa0gBoI6WnmZ7gohQ49+LZNEZ4wNJXWFlYzAQ/ s21o7BKnGXrawgnBMpfwz5cUx+rH6xDhJVUZlyJkv4XaRM5iRpLRUB0ViymOvZWZ0iKybHiQcIY8uT QquwLVd/s6X0FmjUuDCbyUbPbgoejl2eVJ6Ugl8cYkm7DwwnJCvG59i6zh+ScjR67ys0ROtApqK7qq NV+g9WC2LY1I+/pAgkTDQqqMD8DUQoKB1hi4qM9o4f9B7bAQW6u98q7bSh55IysN3PSacybx5c+S5g xd920HE37gmARNaJPxZrLm+gVsU3vWtzP4j1FGDZ/hhXb7L+MR5b6iQJl9z/n1Sw9eZRDtz7SdkVOT nmbCgSFtZFyAVGqR3rv9u7KggNppfVXjT+sFCu9UwvwF+uqMWyCHJq0uHEgurEzSFCt25qnartDo2x qxdPe7pjfWgdLa3pGKC4q9FtscpvfXBS/zuuAABJ5sj2Hxhcq8D7Ql0JnuyFTzJexzA8q9iX3gDjBC 2HgLW/d4RUMU9gJcxXqGMY9iXVgEro5Ko3q6xKzx+RkyOZ0SOZ1shTquvgNw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pcon_dsc_dpcd array holds 13 registers (0x92 through 0x9E). Fix the
math to calculate the max size. Found from a -Warray-bounds build:

drivers/gpu/drm/drm_dp_helper.c: In function 'drm_dp_pcon_dsc_bpp_incr':
drivers/gpu/drm/drm_dp_helper.c:3130:28: error: array subscript 12 is outside array bounds of 'const u8[12]' {aka 'const unsigned char[12]'} [-Werror=array-bounds]
 3130 |         buf = pcon_dsc_dpcd[DP_PCON_DSC_BPP_INCR - DP_PCON_DSC_ENCODER];
      |               ~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/drm_dp_helper.c:3126:39: note: while referencing 'pcon_dsc_dpcd'
 3126 | int drm_dp_pcon_dsc_bpp_incr(const u8 pcon_dsc_dpcd[DP_PCON_DSC_ENCODER_CAP_SIZE])
      |                              ~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Fixes: e2e16da398d9 ("drm/dp_helper: Add support for Configuring DSC for HDMI2.1 Pcon")
Cc: stable@vger.kernel.org
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/lkml/20211214001849.GA62559@embeddedor/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v1: https://lore.kernel.org/lkml/20211203084333.3105038-1-keescook@chromium.org/
v2:
 - add reviewed-by
 - add cc:stable
---
 include/drm/drm_dp_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
index 30359e434c3f..472dac376284 100644
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -456,7 +456,7 @@ struct drm_panel;
 #define DP_FEC_CAPABILITY_1			0x091   /* 2.0 */
 
 /* DP-HDMI2.1 PCON DSC ENCODER SUPPORT */
-#define DP_PCON_DSC_ENCODER_CAP_SIZE        0xC	/* 0x9E - 0x92 */
+#define DP_PCON_DSC_ENCODER_CAP_SIZE        0xD	/* 0x92 through 0x9E */
 #define DP_PCON_DSC_ENCODER                 0x092
 # define DP_PCON_DSC_ENCODER_SUPPORTED      (1 << 0)
 # define DP_PCON_DSC_PPS_ENC_OVERRIDE       (1 << 1)
-- 
2.30.2

