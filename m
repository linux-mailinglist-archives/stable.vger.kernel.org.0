Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4426438A60F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhETKXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235912AbhETKVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6A3611BD;
        Thu, 20 May 2021 09:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504080;
        bh=nM82XFwB+Hv0Rbe30sfFpEmwyRJEFZjJt83JZ6zhF7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpQe3BzKvYEHi93vM/bGZJM+b+Y+kdct3T4qahhKdj1WyjRO+lOjT7yZ81xPLbkkU
         ul8V2fjqgbuGQVTbWA5qJmb6nieK8MLWf05py5VNyZ3+tUa/Ca43IEt9sl9/b1MSRO
         Df72SVTl/0jNC1uGbIu2JcUHBYC6EkIOsErJsAN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rosen Penev <rosenp@gmail.com>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 083/323] powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h
Date:   Thu, 20 May 2021 11:19:35 +0200
Message-Id: <20210520092122.933422194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

commit 7de21e679e6a789f3729e8402bc440b623a28eae upstream.

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

Cc: Stable <stable@vger.kernel.org>
Reported-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200917135437.1238787-1-Tony.Ambardar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/uapi/asm/errno.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/include/uapi/asm/errno.h
+++ b/arch/powerpc/include/uapi/asm/errno.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_POWERPC_ERRNO_H
 #define _ASM_POWERPC_ERRNO_H
 
+#undef	EDEADLOCK
 #include <asm-generic/errno.h>
 
 #undef	EDEADLOCK


