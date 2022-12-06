Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D00E644362
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiLFMoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiLFMob (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226F92A260
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:43:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C832CB81A12
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F8BC433C1;
        Tue,  6 Dec 2022 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670330611;
        bh=E/w0Xs1kTKC6Res5XQbwc0QkvTTTESLrIxMwxM67GVM=;
        h=From:To:Cc:Subject:Date:From;
        b=sHcaWoImSK//DOmDoHPvCyj4RF5YL5DIsiT4dqEUCw0T5lc5X4j0mmdUqCOYH5Fjq
         ghP6RkLaIu+SrmzaIjTqTcKJ/pMSlgqE4PtsXZAjvE09ANfWgYCTzm27EBvR27Zx8d
         lwjgWNoGBXR20Jsk9TlbAPXdDV6D0ckGR0Wis7oyH1MUftxi7a+zMrYVJ8wcjjNtiW
         l/ljcqpl3tuCgqmfsqvZlJn4V8CYFMCalAEWufURqgp8bRmBP9BbjOiS7odHtYVd9F
         4HjAlcUkEfz8e9snTg5eEQDE0k1TLrotmgShaiiiE2aZuFwfovR1qNk1hHFD0nJYsB
         8MReyLstqDu1g==
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
Subject: [PATCH v5.10 1/1] Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
Date:   Tue,  6 Dec 2022 12:43:20 +0000
Message-Id: <20221206124320.130815-1-lee@kernel.org>
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
[Lee: Back-ported to linux-5.10.y]
Signed-off-by: Lee Jones <lee@kernel.org>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ce796ca869c22..ea0628a0116d0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -298,6 +298,7 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
+	default 1280 if KASAN && !64BIT
 	default 1280 if (!64BIT && PARISC)
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

