Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1213564349A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiLETsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbiLETrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8422FE2
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76796B811CF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96831C433D6;
        Mon,  5 Dec 2022 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269464;
        bh=gvGi59pYABP8Hcn9Lf1ApobhryjhuLlYEiQrCzuscC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iByYplnUS8H8x68vhcboZnSkutFwyhb4U3Q7hJuikI+3QGLjBf4Sym2VixYut8S+p
         fZgJaPR4t79WXXRHKs9PA8hE+Jw6yt9/k66dz97oNR436+Mj+xANA6eCg9p6MNpQM5
         otWC02vag6aukK29QAz4Ew9j9l9pK2Zmy4roM0Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/153] Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
Date:   Mon,  5 Dec 2022 20:11:00 +0100
Message-Id: <20221205190812.553927050@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit 152fe65f300e1819d59b80477d3e0999b4d5d7d2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3ab05ca63c6e..6d79e7c3219c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -255,6 +255,7 @@ config FRAME_WARN
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 2048 if PARISC
 	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
-- 
2.35.1



