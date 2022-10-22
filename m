Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC86D608679
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiJVHt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiJVHtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C3C24AE1A;
        Sat, 22 Oct 2022 00:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7873F60ADA;
        Sat, 22 Oct 2022 07:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CEC433C1;
        Sat, 22 Oct 2022 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424535;
        bh=tsYIEnNeNXBKuktBDiK6adMOHZqbmAxFQCb+rNO0Bnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9p8V9ucd7fkvjnb9j6+/VX4kSpcgClvHZ1WJ5HyTDT6kO6FEfNjaIXve1xzld5VC
         w8LS/HzRBwmOZD67hKHRe1z5VxKqsFwQvf4wB4ULLZCaneZoZQbfrNSmtx9HjX04j7
         BC8Xfdx2Xg7rWcIRvYZDbikhX7RGOJilPOouqF5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 182/717] sh: machvec: Use char[] for section boundaries
Date:   Sat, 22 Oct 2022 09:21:01 +0200
Message-Id: <20221022072447.821113921@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit c5783af354688b24abd359f7086c282ec74de993 ]

As done for other sections, define the extern as a character array,
which relaxes many of the compiler-time object size checks, which would
otherwise assume it's a single long. Solves the following build error:

arch/sh/kernel/machvec.c: error: array subscript 'struct sh_machine_vector[0]' is partly outside array bounds of 'long int[1]' [-Werror=array-bounds]:  => 105:33

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/lkml/alpine.DEB.2.22.394.2209050944290.964530@ramsan.of.borg/
Fixes: 9655ad03af2d ("sh: Fixup machvec support.")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Rich Felker <dalias@libc.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/sections.h |  2 +-
 arch/sh/kernel/machvec.c       | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sh/include/asm/sections.h b/arch/sh/include/asm/sections.h
index 8edb824049b9..0cb0ca149ac3 100644
--- a/arch/sh/include/asm/sections.h
+++ b/arch/sh/include/asm/sections.h
@@ -4,7 +4,7 @@
 
 #include <asm-generic/sections.h>
 
-extern long __machvec_start, __machvec_end;
+extern char __machvec_start[], __machvec_end[];
 extern char __uncached_start, __uncached_end;
 extern char __start_eh_frame[], __stop_eh_frame[];
 
diff --git a/arch/sh/kernel/machvec.c b/arch/sh/kernel/machvec.c
index d606679a211e..57efaf5b82ae 100644
--- a/arch/sh/kernel/machvec.c
+++ b/arch/sh/kernel/machvec.c
@@ -20,8 +20,8 @@
 #define MV_NAME_SIZE 32
 
 #define for_each_mv(mv) \
-	for ((mv) = (struct sh_machine_vector *)&__machvec_start; \
-	     (mv) && (unsigned long)(mv) < (unsigned long)&__machvec_end; \
+	for ((mv) = (struct sh_machine_vector *)__machvec_start; \
+	     (mv) && (unsigned long)(mv) < (unsigned long)__machvec_end; \
 	     (mv)++)
 
 static struct sh_machine_vector * __init get_mv_byname(const char *name)
@@ -87,8 +87,8 @@ void __init sh_mv_setup(void)
 	if (!machvec_selected) {
 		unsigned long machvec_size;
 
-		machvec_size = ((unsigned long)&__machvec_end -
-				(unsigned long)&__machvec_start);
+		machvec_size = ((unsigned long)__machvec_end -
+				(unsigned long)__machvec_start);
 
 		/*
 		 * Sanity check for machvec section alignment. Ensure
@@ -102,7 +102,7 @@ void __init sh_mv_setup(void)
 		 * vector (usually the only one) from .machvec.init.
 		 */
 		if (machvec_size >= sizeof(struct sh_machine_vector))
-			sh_mv = *(struct sh_machine_vector *)&__machvec_start;
+			sh_mv = *(struct sh_machine_vector *)__machvec_start;
 	}
 
 	pr_notice("Booting machvec: %s\n", get_system_type());
-- 
2.35.1



