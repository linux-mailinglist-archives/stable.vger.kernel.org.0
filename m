Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B39E644361
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiLFMoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiLFMnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:43:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0D2FC7
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:42:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E511F61711
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117B1C433C1;
        Tue,  6 Dec 2022 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670330564;
        bh=g4aCG0un1nvHcRuO8OuzkyHIBU61ridWlTojlP37dEM=;
        h=From:To:Cc:Subject:Date:From;
        b=AOJRLc3zyWPobKcvnvYO7PrSQqh8pPAiZCaoryzCSdpDjE50Tg9T5v8/ebos22Zce
         TxcvnuaDu7RWMSmZNn+rl6LpkajJDJPw9oX6dldRijanwU1Cy/GlDLxa6rhVdbSi/n
         Flvk143oNDSVH6CL200iW6SLKMWhBGmvsnYjV49bLmr3O15akNMNZMq+g1m5Lr0xr7
         uQNryysHaL1ih7T2DXiANJX02uwMXkkDYn82u4oKUa4Ma+yoK58jIrnzyrbDJ14D/W
         YXKlcHvAlpXduFu+u5rXgsMt8A0X/mhp/6rxizkEm6BrKbt5aI9WvVWHyxoZoz8EVy
         5y2LNTlGaR2jw==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tom Rix <trix@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v5.15 1/1] Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
Date:   Tue,  6 Dec 2022 12:42:23 +0000
Message-Id: <20221206124223.130619-1-lee@kernel.org>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 152fe65f300e1819d59b80477d3e0999b4d5d7d2 upstream.

When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
over the current threshold.  This can mainly be seen on 32-bit
architectures where the present limit (when !GCC) is a lowly 1024-Bytes.

Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[Lee: Back-ported to linux-5.15.y]
Signed-off-by: Lee Jones <lee@kernel.org>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1699b21245586..cfbadc7c919d8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -353,6 +353,7 @@ config FRAME_WARN
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 1536 if (!64BIT && (PARISC || XTENSA))
+	default 1280 if KASAN && !64BIT
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

