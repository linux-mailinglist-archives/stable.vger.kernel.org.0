Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C34A40BF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348465AbiAaK7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358344AbiAaK7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B24BC06174E;
        Mon, 31 Jan 2022 02:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DA7760ABE;
        Mon, 31 Jan 2022 10:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D8C340EF;
        Mon, 31 Jan 2022 10:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626741;
        bh=e2WQ35VBoBcBt40QoBPEn2xr4K/4V24VvJRY9NjJxNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHuIPhkLJZWoMK+mp/q41pUouxEsgTrE5AcBWm1Z+BcHDRJ52U2R8u0l03h3WHQGI
         XpzG0qcWpSNOswuH21RDu75Tt1FP18CpG74DZQqAxqw6AzW2cgZYcMQuLtqRmJ/+ht
         y1dFrzTLEauY1y7QsOJBq+aTxurtZ97QKXLjn2lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 24/64] powerpc/32: Fix boot failure with GCC latent entropy plugin
Date:   Mon, 31 Jan 2022 11:56:09 +0100
Message-Id: <20220131105216.481851495@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit bba496656a73fc1d1330b49c7f82843836e9feb1 upstream.

Boot fails with GCC latent entropy plugin enabled.

This is due to early boot functions trying to access 'latent_entropy'
global data while the kernel is not relocated at its final
destination yet.

As there is no way to tell GCC to use PTRRELOC() to access it,
disable latent entropy plugin in early_32.o and feature-fixups.o and
code-patching.o

Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Cc: stable@vger.kernel.org # v4.9+
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215217
Link: https://lore.kernel.org/r/2bac55483b8daf5b1caa163a45fa5f9cdbe18be4.1640178426.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/Makefile |    1 +
 arch/powerpc/lib/Makefile    |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -13,6 +13,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_early_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -16,6 +16,9 @@ CFLAGS_code-patching.o += -DDISABLE_BRAN
 CFLAGS_feature-fixups.o += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += alloc.o code-patching.o feature-fixups.o pmem.o
 
 ifndef CONFIG_KASAN


