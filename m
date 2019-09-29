Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B386AC1563
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfI2ODo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbfI2ODl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D302086A;
        Sun, 29 Sep 2019 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765820;
        bh=6Aj5dbtLhd7kA0KmaquGmsU5Jz5yxPWzd2bJ84wED3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBXFe3yG/TN7SlLM8pY6P5KsTKDB1NZ9sdIQkNg+9f9essi9oMYlKvLKt6zUJGIUB
         1ysg7DELg0/uvpDLfSanX4CRB2mSZ+/1l60lmfg0Y57PDqncqBkfitdg9Q++fmOsII
         Ga0v3LEFL9atuyV7nudPS2RYAIZsDbKlwKqf2QFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 07/25] drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines
Date:   Sun, 29 Sep 2019 15:56:10 +0200
Message-Id: <20190929135011.629505348@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 0f0727d971f6fdf8f1077180d495ddb9928f0c8b upstream.

arch/x86/Makefile disables SSE and SSE2 for the whole kernel.  The
AMDGPU drivers modified in this patch re-enable SSE but not SSE2.  Turn
on SSE2 to support emitting double precision floating point instructions
rather than calls to non-existent (usually available from gcc_s or
compiler_rt) floating point helper routines for Clang.

This was originally landed in:
commit 10117450735c ("drm/amd/display: add -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines")
but reverted in:
commit 193392ed9f69 ("Revert "drm/amd/display: add -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines"")
due to bugreports from GCC builds. Add guards to only do so for Clang.

Link: https://bugs.freedesktop.org/show_bug.cgi?id=109487
Link: https://github.com/ClangBuiltLinux/linux/issues/327

Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/calcs/Makefile |    4 ++++
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile |    4 ++++
 drivers/gpu/drm/amd/display/dc/dml/Makefile   |    4 ++++
 drivers/gpu/drm/amd/display/dc/dsc/Makefile   |    4 ++++
 4 files changed, 16 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/calcs/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
@@ -32,6 +32,10 @@ endif
 
 calcs_ccflags := -mhard-float -msse $(cc_stack_align)
 
+ifdef CONFIG_CC_IS_CLANG
+calcs_ccflags += -msse2
+endif
+
 CFLAGS_dcn_calcs.o := $(calcs_ccflags)
 CFLAGS_dcn_calc_auto.o := $(calcs_ccflags)
 CFLAGS_dcn_calc_math.o := $(calcs_ccflags) -Wno-tautological-compare
--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -18,6 +18,10 @@ endif
 
 CFLAGS_dcn20_resource.o := -mhard-float -msse $(cc_stack_align)
 
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_dcn20_resource.o += -msse2
+endif
+
 AMD_DAL_DCN20 = $(addprefix $(AMDDALPATH)/dc/dcn20/,$(DCN20))
 
 AMD_DISPLAY_FILES += $(AMD_DAL_DCN20)
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -32,6 +32,10 @@ endif
 
 dml_ccflags := -mhard-float -msse $(cc_stack_align)
 
+ifdef CONFIG_CC_IS_CLANG
+dml_ccflags += -msse2
+endif
+
 CFLAGS_display_mode_lib.o := $(dml_ccflags)
 
 ifdef CONFIG_DRM_AMD_DC_DCN2_0
--- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
@@ -9,6 +9,10 @@ endif
 
 dsc_ccflags := -mhard-float -msse $(cc_stack_align)
 
+ifdef CONFIG_CC_IS_CLANG
+dsc_ccflags += -msse2
+endif
+
 CFLAGS_rc_calc.o := $(dsc_ccflags)
 CFLAGS_rc_calc_dpi.o := $(dsc_ccflags)
 CFLAGS_codec_main_amd.o := $(dsc_ccflags)


