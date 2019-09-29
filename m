Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6C1C1591
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfI2OBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbfI2OBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762132082F;
        Sun, 29 Sep 2019 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765667;
        bh=g4EIyYRYGSUWt9y0XJmLdDFQ6tAcVEVuhUhDrId1rQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zngbyiuIndT7LLDJuFbT9vgyoqbNG1IigN3GOQ6v4/wDgvd/xV1tmY2gWmuzn+F9Z
         cIrPEMpakccNrh5ukl+wNGeAneISlCYOk/fIeo2RX71HlBa9FpfCevS2TYKzi6mn8O
         y/bia2Pv794CIpwoNECedUjLIeoVqd15yQTmEI/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 10/45] drm/amd/display: readd -msse2 to prevent Clang from emitting libcalls to undefined SW FP routines
Date:   Sun, 29 Sep 2019 15:55:38 +0200
Message-Id: <20190929135027.732791582@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 0f0727d971f6fdf8f1077180d495ddb9928f0c8b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/calcs/Makefile | 4 ++++
 drivers/gpu/drm/amd/display/dc/dml/Makefile   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/calcs/Makefile b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
index 95f332ee3e7e6..16614d73a5fcf 100644
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
diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index d97ca6528f9d9..934ffe1b4b00e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -32,6 +32,10 @@ endif
 
 dml_ccflags := -mhard-float -msse $(cc_stack_align)
 
+ifdef CONFIG_CC_IS_CLANG
+dml_ccflags += -msse2
+endif
+
 CFLAGS_display_mode_lib.o := $(dml_ccflags)
 CFLAGS_display_pipe_clocks.o := $(dml_ccflags)
 CFLAGS_dml1_display_rq_dlg_calc.o := $(dml_ccflags)
-- 
2.20.1



