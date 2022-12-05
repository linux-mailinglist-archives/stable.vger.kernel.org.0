Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1C643352
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiLETfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiLETfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:35:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A642A27E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091D1B80EFD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46641C433D6;
        Mon,  5 Dec 2022 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268682;
        bh=22sV16iO9OXMHqC4fxl0K5hJrO0PQhkdL3lQVMmLX60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vc/L9xryCugC3T16TtRmyYEIMvS6IXzW9htS54Tb9nvW0PsZq6VPI2omviqfjmXte
         8JK5TJmFxI5/uoXymyhns5gqUzH4DskSwvOGQpVB8fchwLAu6Dbi2iG3rw2C3StxjU
         TZrABeSDcwQnsWqHzbmntV/bhAf7LQq7NuT6LEq4=
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
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 66/92] drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
Date:   Mon,  5 Dec 2022 20:10:19 +0100
Message-Id: <20221205190805.695561613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

commit 6f6cb1714365a07dbc66851879538df9f6969288 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -5,6 +5,7 @@ menu "Display Engine Configuration"
 config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
+	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	select DRM_AMD_DC_DCN if (X86 || PPC64) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
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


