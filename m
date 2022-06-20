Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375A6551A63
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbiFTNF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244051AbiFTNEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F49193DA;
        Mon, 20 Jun 2022 05:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B5561535;
        Mon, 20 Jun 2022 12:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C56C3411B;
        Mon, 20 Jun 2022 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729981;
        bh=1X9QZlKy3N/ytBJj/DbB5zz0kkGXy5zj9pdAlAhiWf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKh5KYl0CPQdbsa0AF6tCi6vdZktNY+p/UIAHZKeC5dbEhSTaHulR3ME9Nx7VZE5F
         z0pvjjomf3qU2h1fDDfBN/yOwDWvLYg9g+E6cJEHHx6vJk2Sc6r/XFTyO7mKulFGuB
         WOD7NqywzMb84LpQ4l6zUkxkIjXR3gp+Pf3IbP0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Scott Wood <oss@buserror.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.18 137/141] powerpc/book3e: get rid of #include <generated/compile.h>
Date:   Mon, 20 Jun 2022 14:51:15 +0200
Message-Id: <20220620124733.608911236@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 7ad4bd887d27c6b6ffbef216f19c19f8fe2b8f52 upstream.

You cannot include <generated/compile.h> here because it is generated
in init/Makefile but there is no guarantee that it happens before
arch/powerpc/mm/nohash/kaslr_booke.c is compiled for parallel builds.

The places where you can reliably include <generated/compile.h> are:

  - init/          (because init/Makefile can specify the dependency)
  - arch/*/boot/   (because it is compiled after vmlinux)

Commit f231e4333312 ("hexagon: get rid of #include <generated/compile.h>")
fixed the last breakage at that time, but powerpc re-added this.

<generated/compile.h> was unneeded because 'build_str' is almost the
same as 'linux_banner' defined in init/version.c

Let's copy the solution from MIPS.
(get_random_boot() in arch/mips/kernel/relocate.c)

Fixes: 6a38ea1d7b94 ("powerpc/fsl_booke/32: randomize the kernel image offset")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220604085050.4078927-1-masahiroy@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/nohash/kaslr_booke.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/kdump.h>
 #include <mm/mmu_decl.h>
-#include <generated/compile.h>
 #include <generated/utsrelease.h>
 
 struct regions {
@@ -36,10 +35,6 @@ struct regions {
 	int reserved_mem_size_cells;
 };
 
-/* Simplified build-specific string for starting entropy. */
-static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
-
 struct regions __initdata regions;
 
 static __init void kaslr_get_cmdline(void *fdt)
@@ -70,7 +65,8 @@ static unsigned long __init get_boot_see
 {
 	unsigned long hash = 0;
 
-	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	/* build-specific string for starting entropy. */
+	hash = rotate_xor(hash, linux_banner, strlen(linux_banner));
 	hash = rotate_xor(hash, fdt, fdt_totalsize(fdt));
 
 	return hash;


