Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F409433BA9E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhCOOJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234590AbhCOOE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1218364F0A;
        Mon, 15 Mar 2021 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817062;
        bh=t6RUt6HUzB0MgaDyS9B4bHBo4NehUJSKVH0UAGG2iL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irN83YvP4IeyYc8IV7OhdY/gcPSsiheo7SCVRHc7yV2eajuu+a00XAa4rBQtQRWG3
         AfllZd/yys2koJ/vnMHIcMSWjBJR7XupI7oUOZuED3C5Qq2kSM55HoUkYFCB0O2TyV
         s8c2ZoqCKbsmJA2/ArvNVrtG/4ABxZjsaNn4CPJI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 282/306] powerpc: Fix missing declaration of [en/dis]able_kernel_vsx()
Date:   Mon, 15 Mar 2021 14:55:45 +0100
Message-Id: <20210315135517.220340775@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit bd73758803c2eedc037c2268b65a19542a832594 upstream.

Add stub instances of enable_kernel_vsx() and disable_kernel_vsx()
when CONFIG_VSX is not set, to avoid following build failure.

  CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o
  In file included from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services_types.h:29,
                   from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services.h:37,
                   from drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:27:
  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c: In function 'dcn_bw_apply_registry_override':
  ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:64:3: error: implicit declaration of function 'enable_kernel_vsx'; did you mean 'enable_kernel_fp'? [-Werror=implicit-function-declaration]
     64 |   enable_kernel_vsx(); \
        |   ^~~~~~~~~~~~~~~~~
  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:640:2: note: in expansion of macro 'DC_FP_START'
    640 |  DC_FP_START();
        |  ^~~~~~~~~~~
  ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:75:3: error: implicit declaration of function 'disable_kernel_vsx'; did you mean 'disable_kernel_fp'? [-Werror=implicit-function-declaration]
     75 |   disable_kernel_vsx(); \
        |   ^~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:676:2: note: in expansion of macro 'DC_FP_END'
    676 |  DC_FP_END();
        |  ^~~~~~~~~
  cc1: some warnings being treated as errors
  make[5]: *** [drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o] Error 1

This works because the caller is checking if VSX is available using
cpu_has_feature():

  #define DC_FP_START() { \
  	if (cpu_has_feature(CPU_FTR_VSX_COMP)) { \
  		preempt_disable(); \
  		enable_kernel_vsx(); \
  	} else if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP)) { \
  		preempt_disable(); \
  		enable_kernel_altivec(); \
  	} else if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE)) { \
  		preempt_disable(); \
  		enable_kernel_fp(); \
  	} \

When CONFIG_VSX is not selected, cpu_has_feature(CPU_FTR_VSX_COMP)
constant folds to 'false' so the call to enable_kernel_vsx() is
discarded and the build succeeds.

Fixes: 16a9dea110a6 ("amdgpu: Enable initial DCN support on POWER")
Cc: stable@vger.kernel.org # v5.6+
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Incorporate some discussion comments into the change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8d7d285a027e9d21f5ff7f850fa71a2655b0c4af.1615279170.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/switch_to.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -71,6 +71,16 @@ static inline void disable_kernel_vsx(vo
 {
 	msr_check_and_clear(MSR_FP|MSR_VEC|MSR_VSX);
 }
+#else
+static inline void enable_kernel_vsx(void)
+{
+	BUILD_BUG();
+}
+
+static inline void disable_kernel_vsx(void)
+{
+	BUILD_BUG();
+}
 #endif
 
 #ifdef CONFIG_SPE


