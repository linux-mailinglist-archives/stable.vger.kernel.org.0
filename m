Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4704F2E1E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245441AbiDEIzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240909AbiDEIci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8C113D60;
        Tue,  5 Apr 2022 01:25:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8503B81BAF;
        Tue,  5 Apr 2022 08:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A587C385A1;
        Tue,  5 Apr 2022 08:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147107;
        bh=cpsnT1zebhl17DiwBKb127RWcxcMG89F+sCYUs5gNuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8zdsxufEmf7NeRBqE98Vv2PWEGmoCrNEj2ELnIHPxul20pgWcvzufuJKngxnQh/T
         K7IpTguOu2L36FC/Lt7o7zy9Lw0rgt2ipThkMKEf8nkPB02n2TSYD2TcSt1UDt/Fsf
         jIJf7ctHvTzElOuNzx5vEw9oE8n6/CNtHlcbRkkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.17 0966/1126] drm/dp: Fix off-by-one in register cache size
Date:   Tue,  5 Apr 2022 09:28:33 +0200
Message-Id: <20220405070435.860956354@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit d4da1f27396fb1dde079447a3612f4f512caed07 upstream.

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
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220225035610.2552144-2-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_dp_helper.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


