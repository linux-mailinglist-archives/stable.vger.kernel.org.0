Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AC64ABA1B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiBGLXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiBGLJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:09:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EED9C043188;
        Mon,  7 Feb 2022 03:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C185261261;
        Mon,  7 Feb 2022 11:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F117C004E1;
        Mon,  7 Feb 2022 11:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232193;
        bh=+DizvWClW/CV/X7Q1K0svABf404QPj0PYFO9jr/kB0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaKsrfQz74RMr0wQFNhQPyAdYT0XiuN0cIllN2w8oboqG9IAa8RA3JVz2TtGkwTu7
         LFu80xvhFbkyPNYipYw0W7ol+9uUp68qEo13rZ/XbkEzZTY6OjYSUUsDadv3p88xdj
         2mJrTWoi5JGhIldVBdz8LEtUtZeKDNBBklwtjYG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 14/48] powerpc/32: Fix boot failure with GCC latent entropy plugin
Date:   Mon,  7 Feb 2022 12:05:47 +0100
Message-Id: <20220207103752.809184786@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -14,6 +14,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
+CFLAGS_setup_32.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_prom_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 CFLAGS_btext.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -9,6 +9,9 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_
 CFLAGS_REMOVE_code-patching.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_feature-fixups.o = $(CC_FLAGS_FTRACE)
 
+CFLAGS_code-patching.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+CFLAGS_feature-fixups.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
+
 obj-y += string.o alloc.o crtsavres.o code-patching.o \
 	 feature-fixups.o
 


