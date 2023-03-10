Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9D6B4991
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjCJPOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbjCJPNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA489EFA5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C26B822EC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6142C433D2;
        Fri, 10 Mar 2023 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460235;
        bh=mEdj9Kckm62gN05ro/Gc8LlqJ3MsJ9BISpdhc8drYXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2Dt7J3ikNsD7RS1zbDuvaLAPIyExgTSnaTWwSlqnj9k5nkwfc/uK2XX0qonbLnD0
         cY1zdNzZiEjTABNH2I+vanW5fZa18ejYVDTiJI/sDwvc3vMmUrzDePTcJdqsIxq0iU
         jo+0l9d1uecFe1cwGYzTodDwdgvFTAf5qUchKU6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/529] powerpc: Remove linker flag from KBUILD_AFLAGS
Date:   Fri, 10 Mar 2023 14:36:50 +0100
Message-Id: <20230310133817.339872025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 31f48f16264bc70962fb3e7ec62da64d0a2ba04a ]

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
points out that KBUILD_AFLAGS contains a linker flag, which will be
unused:

  clang: error: -Wl,-a32: 'linker' input unused [-Werror,-Wunused-command-line-argument]

This was likely supposed to be '-Wa,-a$(BITS)'. However, this change is
unnecessary, as all supported versions of clang and gcc will pass '-a64'
or '-a32' to GNU as based on the value of '-m'; the behavior of the
latest stable release of the oldest supported major version of each
compiler is shown below and each compiler's latest release exhibits the
same behavior (GCC 12.2.0 and Clang 15.0.6).

  $ powerpc64-linux-gcc --version | head -1
  powerpc64-linux-gcc (GCC) 5.5.0

  $ powerpc64-linux-gcc -m64 -### -x assembler-with-cpp -c -o /dev/null /dev/null &| grep 'as '
  .../as -a64 -mppc64 -many -mbig -o /dev/null /tmp/cctwuBzZ.s

  $ powerpc64-linux-gcc -m32 -### -x assembler-with-cpp -c -o /dev/null /dev/null &| grep 'as '
  .../as -a32 -mppc -many -mbig -o /dev/null /tmp/ccaZP4mF.sg

  $ clang --version | head -1
  Ubuntu clang version 11.1.0-++20211011094159+1fdec59bffc1-1~exp1~20211011214622.5

  $ clang --target=powerpc64-linux-gnu -fno-integrated-as -m64 -### \
    -x assembler-with-cpp -c -o /dev/null /dev/null &| grep gnu-as
   "/usr/bin/powerpc64-linux-gnu-as" "-a64" "-mppc64" "-many" "-o" "/dev/null" "/tmp/null-80267c.s"

  $ clang --target=powerpc64-linux-gnu -fno-integrated-as -m64 -### \
    -x assembler-with-cpp -c -o /dev/null /dev/null &| grep gnu-as
   "/usr/bin/powerpc64-linux-gnu-as" "-a32" "-mppc" "-many" "-o" "/dev/null" "/tmp/null-ab8f8d.s"

Remove this flag altogether to avoid future issues.

Fixes: 1421dc6d4829 ("powerpc/kbuild: Use flags variables rather than overriding LD/CC/AS")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 6122541412961..a3f66ade09b32 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -92,7 +92,7 @@ aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
 
 ifeq ($(HAS_BIARCH),y)
 KBUILD_CFLAGS	+= -m$(BITS)
-KBUILD_AFLAGS	+= -m$(BITS) -Wl,-a$(BITS)
+KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
-- 
2.39.2



