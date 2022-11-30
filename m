Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D7B63E3B5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiK3Wv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiK3Wvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8855D1F609;
        Wed, 30 Nov 2022 14:51:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 241DB61D53;
        Wed, 30 Nov 2022 22:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EF4C433D6;
        Wed, 30 Nov 2022 22:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848710;
        bh=YEXcZh2hOnrutTFjMcvXJ7B95vvTadjKtK+eduTf+yM=;
        h=Date:To:From:Subject:From;
        b=hfnHqvIxhah1IDqb+dyw5CWGIO4bd9rPaalzdISur5aUSR9SgF1nOxIbUW1DJf6ox
         hcks5GMl4JejUfvNjglh6Vq035rfh+/HJd0MYRP3CHQZL+c+h287Hzb5yJ5MqkH5xP
         TUj5tpzSBR4yvlIfanh177sK9nx4eRu5+KceaeEQ=
Date:   Wed, 30 Nov 2022 14:51:49 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        tzimmermann@suse.de, trix@redhat.com, sunpeng.li@amd.com,
        stable@vger.kernel.org, Rodrigo.Siqueira@amd.com,
        ndesaulniers@google.com, nathan@kernel.org, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, harry.wentland@amd.com,
        daniel@ffwll.ch, christian.koenig@amd.com, arnd@arndb.de,
        alexander.deucher@amd.com, airlied@gmail.com, lee@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch removed from -mm tree
Message-Id: <20221130225150.79EF4C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
has been removed from the -mm tree.  Its filename was
     drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lee Jones <lee@kernel.org>
Subject: drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
Date: Fri, 25 Nov 2022 12:07:49 +0000

Patch series "Fix a bunch of allmodconfig errors", v2.

Since b339ec9c229aa ("kbuild: Only default to -Werror if COMPILE_TEST")
WERROR now defaults to COMPILE_TEST meaning that it's enabled for
allmodconfig builds.  This leads to some interesting build failures when
using Clang, each resolved in this set.

With this set applied, I am able to obtain a successful allmodconfig Arm
build.


This patch (of 2):

calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 ||
ARM64) architectures built with Clang (all released versions), whereby the
stack frame gets blown up to well over 5k.  This would cause an immediate
kernel panic on most architectures.  We'll revert this when the following
bug report has been resolved:
https://github.com/llvm/llvm-project/issues/41896.

Link: https://lkml.kernel.org/r/20221125120750.3537134-1-lee@kernel.org
Link: https://lkml.kernel.org/r/20221125120750.3537134-2-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Lee Jones <lee@kernel.org>
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
---

 drivers/gpu/drm/amd/display/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/Kconfig~drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame
+++ a/drivers/gpu/drm/amd/display/Kconfig
@@ -5,6 +5,7 @@ menu "Display Engine Configuration"
 config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
+	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	select DRM_AMD_DC_DCN if (X86 || PPC_LONG_DOUBLE_128)
 	help
@@ -12,6 +13,12 @@ config DRM_AMD_DC
 	  support for AMDGPU. This adds required support for Vega and
 	  Raven ASICs.
 
+	  calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 || ARM64)
+	  architectures built with Clang (all released versions), whereby the stack
+	  frame gets blown up to well over 5k.  This would cause an immediate kernel
+	  panic on most architectures.  We'll revert this when the following bug report
+	  has been resolved: https://github.com/llvm/llvm-project/issues/41896.
+
 config DRM_AMD_DC_DCN
 	def_bool n
 	help
_

Patches currently in -mm which might be from lee@kernel.org are


