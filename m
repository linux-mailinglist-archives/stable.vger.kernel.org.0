Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7457641640
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 11:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLCK75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 05:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLCK7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 05:59:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAFE5214F
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 02:59:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F3E060BAD
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 10:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D8BC433C1;
        Sat,  3 Dec 2022 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670065188;
        bh=LkEg1vyll+ABw7vfSjMGFV7S5aCTDu8R9T5s4913YSE=;
        h=Subject:To:Cc:From:Date:From;
        b=rUSzL/i5W9PHBmMnGKbTxQgO6VWSmQ4l5Y4fbgqvhKy8i/EMv6JfOO10FT1b9XvBv
         X/8QbwYAqSoP8IQMTyMEpQkR2FWJ297EJnS1swTMlUnFIWYo/dfoZYcBAo/QfGKsS8
         WQAYZUXnYPz3udvSaisflS1lD91DeFbNSLKvRZWw=
Subject: FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 4.9-stable tree
To:     lee@kernel.org, Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, akpm@linux-foundation.org,
        alexander.deucher@amd.com, arnd@arndb.de, christian.koenig@amd.com,
        daniel@ffwll.ch, harry.wentland@amd.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, stable@vger.kernel.org,
        sunpeng.li@amd.com, trix@redhat.com, tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 11:59:36 +0100
Message-ID: <1670065176129161@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
8d192bec534b ("parisc: Increase FRAME_WARN to 2048 bytes on parisc")
867050247e29 ("xtensa: increase size of gcc stack frame check")
55b70eed81cb ("parisc: Increase size of gcc stack frame check")
432654df90f2 ("parisc: Fix too large frame size warnings")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 152fe65f300e1819d59b80477d3e0999b4d5d7d2 Mon Sep 17 00:00:00 2001
From: Lee Jones <lee@kernel.org>
Date: Fri, 25 Nov 2022 12:07:50 +0000
Subject: [PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when
 KASAN is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a1005415f0f4..580e453e284e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -399,6 +399,7 @@ config FRAME_WARN
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 2048 if PARISC
 	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help

