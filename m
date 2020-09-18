Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2520C26F460
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgIRDOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIRCBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4373921973;
        Fri, 18 Sep 2020 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394506;
        bh=6cjJOA2M3eiMBSZe3NwpL92h0qu9NZbYN2525X0lxrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl72sP8RmhwoX43FoZxZ6r5/gPXVXndjeJ+omttxT2wWkw0dJbstqYS9RQg3pmEm3
         pVQRHC3UstXSkwZW1woXtQh/MFOHfyhYCRcSLGFcB4FjgbQBqOAKsBrNgc2sOUwEjA
         Ru2YdnLiKongJEF03IdDkmwr19CdKTxzD8qKMUWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 030/330] powerpc/64s: Always disable branch profiling for prom_init.o
Date:   Thu, 17 Sep 2020 21:56:10 -0400
Message-Id: <20200918020110.2063155-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

