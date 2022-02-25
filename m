Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B214C3CD0
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 04:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiBYD4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 22:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiBYD4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 22:56:46 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D300E3399
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 19:56:15 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 12so3566862pgd.0
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 19:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wk96NA7fBBf+GyTYV14x3h1hBbK9x+rw14Wy3R8RPw=;
        b=WI1Iw8CD3INJc5SOxZ4asph5F4Y1tJBVVMB309PBq+VhJ5NfXeUONS3KtwM69ReiyH
         vYpQcMlu5y40+FqGqnXpRE+LLJLt/RifIQxtLUn/3o8nnB14Ge0K+56b9IE5he8iA1iA
         X1KJ6KYiykAdxhlekZPzP3u5mD7yY7P6vhFNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wk96NA7fBBf+GyTYV14x3h1hBbK9x+rw14Wy3R8RPw=;
        b=TdBcqqcX7JxFI+ONAZuXH8Ah2rgRcBHoLbrum0VLbFkVhtsMCxWWc450phMjqkk5js
         gRHbP/w8kerrb195CiUsa5O8UWUqpVmcPRwD0kLm73u0HgAoImHP+FJPTeIDFfJdcMo3
         0g+ypJX7h1BH6o5uNrm5NeFO2AE1hrUDZLrOYcykfbKxtX93SFAxBU6+cEKGnLGKkEv7
         gGnXBOBh/wqXTy1F0slfquOu2DevwNCFij3s6K3IkCBh/Z1Im5K2LpmnFTbDqGR0K7Vn
         HuV0BTSvqZd52tvIGEKY5Ir0zWm65CeRtJkBkYbLp9XddJOSSdsX1BvGZr9gO5xJba9b
         1M5A==
X-Gm-Message-State: AOAM533NErwfL/lwlTR5Gpi4WWRzAasSdQBirmtZrQYn5obRyeh8cM0/
        ziouoxdPO8oG6qMqXtoXTlwurA==
X-Google-Smtp-Source: ABdhPJze+EfYqPAnvJYyUK/5wdo3hsmPSf+5Itf33O+kpUIDjV5N1yWZU6u5IhBNjnyui2DRHho1kA==
X-Received: by 2002:a63:5148:0:b0:373:c8d7:f23f with SMTP id r8-20020a635148000000b00373c8d7f23fmr4611264pgl.509.1645761374746;
        Thu, 24 Feb 2022 19:56:14 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm1058315pfl.70.2022.02.24.19.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 19:56:14 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Kees Cook <keescook@chromium.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3 1/2] drm/dp: Fix off-by-one in register cache size
Date:   Thu, 24 Feb 2022 19:56:09 -0800
Message-Id: <20220225035610.2552144-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225035610.2552144-1-keescook@chromium.org>
References: <20220225035610.2552144-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2186; h=from:subject; bh=XnOsDK/+y5ut9JOHl+TySo3UIYwEhWHbEO6qaNRWGSY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiGFNZW/hRfwrRCOANpF+kIRDX8smczwuFLS61jR5x Go4dvSGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYhhTWQAKCRCJcvTf3G3AJovDD/ 4yUTMY28Mu3JJTBRXMY90Hwl/Lk8weWvE5upj/7BL/Ska+gAQoQJoEy1CvFmOr/qZ7HYAvGC7Y1meE aix4GNRbGGBCyXTajDyr0+52/U6mOJie3uoOvDtEZM25Uu/2xfHJQF/sUMgnNAfpgmdMZ96VcTTgd9 NLHu72Fg8wGY0TPxf5L/qX8hPQ3I/iMYh3olD1hH1UvaAG+Y2jY17o1P3n6DNuk2BYfomdDTEBbTrJ JnEhtvp1QDXGUMm8FzoxsKQx3u6cZveroMSL03TtuxU9zU+WFZhjZpUbNjzx/1PeY6YHIpA4whU9Ny 8vjW9A/kA8B7w8Kb6gK0ii8l2PpC3Dpx7S7nCXxqUwie19Ao2s5HII4wQAQm/dUTHEpNeGGf18iYUw kOLvwDmKTfNqqKYICXhmTB48qmYBRHIE1yJub5tsfc7+FvIY0UtwJEsaQLObUvWP1AU7LI1KJybv65 y1vTNTiiZ7IrCg0GgreFQ6Zil6IVniHPmGCFBAhd0Z+xP7UX8dU3Blminv/hZVi35o84bny+qeDybp bBXASiW8AadMr7Z79vtunngz2zsRrRP8R0L2tPV+bwDG36AhArVrlKhMpiAxjbTEDHKMjwglkdKoB2 wpyFMtu3uHSjyi0moyYrG9s19iR3UXMSJJA76tTiUI3uC7wBW8LV3eJNV9tQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Fixes: e2e16da398d9 ("drm/dp_helper: Add support for Configuring DSC for HDMI2.1 Pcon")
Cc: stable@vger.kernel.org
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/lkml/20211214001849.GA62559@embeddedor/
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220105173310.2420598-1-keescook@chromium.org
---
 include/drm/dp/drm_dp_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/dp/drm_dp_helper.h b/include/drm/dp/drm_dp_helper.h
index 69487bd8ed56..2a0e75e69e80 100644
--- a/include/drm/dp/drm_dp_helper.h
+++ b/include/drm/dp/drm_dp_helper.h
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

