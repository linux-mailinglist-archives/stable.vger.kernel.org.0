Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8126DD40
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 15:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgIQNzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgIQNzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 09:55:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0836BC061355;
        Thu, 17 Sep 2020 06:54:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bg9so1176299plb.2;
        Thu, 17 Sep 2020 06:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z/K2/i+JXYfZZ5+5bldYLcF42Djb0mZAX58S+kRtJsc=;
        b=bogrH/LctRcjD61IXqaLFLgVpKP+15hGGQXFU1QPJO7NgISDGzRw5nzT8CIMhDNiTP
         ms0m5q0u9jD64WUXmiHzpxULDThbLR7ZBw7SiwFrFDib+wI8IQMLWXgD8Miyh8FicD2r
         Y/Ks2Fla9mIdyxJ2UPyzLc0SzOf26vVpk9FTZO8gAyrgEidVwpvl2G3H0LZOftwTdvx9
         doeY7DZD+4RaTROc4prYRIdRQ3eJx9ONJ9gf5GUo9W+LdGyEABBo/bwUYKg8R2cPGOuw
         Qzm9GIbZXexGEbmCGixOj79XM6bYXy4uCCPwqG1pJrnRJk/AWPCav3NWRVKLBm7RxNuP
         +SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z/K2/i+JXYfZZ5+5bldYLcF42Djb0mZAX58S+kRtJsc=;
        b=QtzQTtRQ+hmTGHCMWqek4xPfG/ILevmp6C7uHb6mRva3urFs/dTgboN9/JWBgSIH0y
         FNfKsdgmI3hooziQdR/NdEujOPIL+N81leEYiBoNkqsd9PU3JKCl0oKhbpUzOIpZ9gwb
         YKaMM+hvUkPf1WE3lWTg2vE7IHixdHffNYnDqVXKOqY6/OmOHHW48ylRe17T37727t7R
         c4PNmlIjDOtG2r1G/F0C3xnqRPtlcEmyiosrH97ce6NCFRBWVTc4c4TV3gT5UPpE6uBH
         XhT4kBf3syIr6k3iPCwMvYW/1oH1wbh7vdYllEtn1dIZbLtghXAmZfGyG2QtvMMvnvLU
         FFiw==
X-Gm-Message-State: AOAM530HopFXU/vXFoicRYy7uHR/NdpnSXJy+WiJfb7cZVJg3PwzSsOL
        zWLDxknHNyYpVhoiXj38qi8=
X-Google-Smtp-Source: ABdhPJxD4C2VPYadg84rIRzWLwt5+D0NW021aBQl3wpvrfSQ6SWd5wfgq05PgBpyp3lINoW2ttqL2w==
X-Received: by 2002:a17:90a:8c88:: with SMTP id b8mr8528564pjo.118.1600350891625;
        Thu, 17 Sep 2020 06:54:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:6ca9:b613:f248:49fa])
        by smtp.gmail.com with ESMTPSA id a12sm17896994pgm.79.2020.09.17.06.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 06:54:51 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Rosen Penev <rosenp@gmail.com>
Subject: [PATCH v3] powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h
Date:   Thu, 17 Sep 2020 06:54:37 -0700
Message-Id: <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200917000757.1232850-1-Tony.Ambardar@gmail.com>
References: <20200917000757.1232850-1-Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A few archs like powerpc have different errno.h values for macros
EDEADLOCK and EDEADLK. In code including both libc and linux versions of
errno.h, this can result in multiple definitions of EDEADLOCK in the
include chain. Definitions to the same value (e.g. seen with mips) do
not raise warnings, but on powerpc there are redefinitions changing the
value, which raise warnings and errors (if using "-Werror").

Guard against these redefinitions to avoid build errors like the following,
first seen cross-compiling libbpf v5.8.9 for powerpc using GCC 8.4.0 with
musl 1.1.24:

  In file included from ../../arch/powerpc/include/uapi/asm/errno.h:5,
                   from ../../include/linux/err.h:8,
                   from libbpf.c:29:
  ../../include/uapi/asm-generic/errno.h:40: error: "EDEADLOCK" redefined [-Werror]
   #define EDEADLOCK EDEADLK

  In file included from toolchain-powerpc_8540_gcc-8.4.0_musl/include/errno.h:10,
                   from libbpf.c:26:
  toolchain-powerpc_8540_gcc-8.4.0_musl/include/bits/errno.h:58: note: this is the location of the previous definition
   #define EDEADLOCK       58

  cc1: all warnings being treated as errors

CC: Stable <stable@vger.kernel.org>
Reported-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
v1 -> v2:
 * clean up commit description formatting

v2 -> v3: (per Michael Ellerman)
 * drop indeterminate 'Fixes' tags, request stable backports instead 
---
 arch/powerpc/include/uapi/asm/errno.h       | 1 +
 tools/arch/powerpc/include/uapi/asm/errno.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/include/uapi/asm/errno.h b/arch/powerpc/include/uapi/asm/errno.h
index cc79856896a1..4ba87de32be0 100644
--- a/arch/powerpc/include/uapi/asm/errno.h
+++ b/arch/powerpc/include/uapi/asm/errno.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_POWERPC_ERRNO_H
 #define _ASM_POWERPC_ERRNO_H
 
+#undef	EDEADLOCK
 #include <asm-generic/errno.h>
 
 #undef	EDEADLOCK
diff --git a/tools/arch/powerpc/include/uapi/asm/errno.h b/tools/arch/powerpc/include/uapi/asm/errno.h
index cc79856896a1..4ba87de32be0 100644
--- a/tools/arch/powerpc/include/uapi/asm/errno.h
+++ b/tools/arch/powerpc/include/uapi/asm/errno.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_POWERPC_ERRNO_H
 #define _ASM_POWERPC_ERRNO_H
 
+#undef	EDEADLOCK
 #include <asm-generic/errno.h>
 
 #undef	EDEADLOCK
-- 
2.25.1

