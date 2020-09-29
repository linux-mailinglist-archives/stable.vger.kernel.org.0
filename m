Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8227C9EA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgI2MOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730105AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5570D23B17;
        Tue, 29 Sep 2020 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379203;
        bh=6cjJOA2M3eiMBSZe3NwpL92h0qu9NZbYN2525X0lxrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIrN7FAjleIHthCmMeSDxP5vI0WVMfOY4HgcQ9iBhh5E/0aObwAPzBqYHvR7yK/cv
         FP9tHKXyVA4jm2Hh3SgaF7Gzft7sRhmz8ytD/AqouO9bJvlVsS6ElPGbM4Y7+1PYCZ
         nYF9IXptilordRMgr6TYAZjhHG63gYYG5pD+X8zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/388] powerpc/64s: Always disable branch profiling for prom_init.o
Date:   Tue, 29 Sep 2020 12:55:59 +0200
Message-Id: <20200929110011.847638043@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 6266a4dadb1d0976490fdf5af4f7941e36f64e80 ]

Otherwise the build fails because prom_init is calling symbols it's
not allowed to, eg:

  Error: External symbol 'ftrace_likely_update' referenced from prom_init.c
  make[3]: *** [arch/powerpc/kernel/Makefile:197: arch/powerpc/kernel/prom_init_check] Error 1

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191106051129.7626-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index dc0780f930d5b..59260eb962916 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -19,6 +19,7 @@ CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 
 CFLAGS_prom_init.o += $(call cc-option, -fno-stack-protector)
+CFLAGS_prom_init.o += -DDISABLE_BRANCH_PROFILING
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
@@ -36,7 +37,6 @@ KASAN_SANITIZE_btext.o := n
 ifdef CONFIG_KASAN
 CFLAGS_early_32.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_cputable.o += -DDISABLE_BRANCH_PROFILING
-CFLAGS_prom_init.o += -DDISABLE_BRANCH_PROFILING
 CFLAGS_btext.o += -DDISABLE_BRANCH_PROFILING
 endif
 
-- 
2.25.1



