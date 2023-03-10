Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866E86B458A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjCJOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjCJOe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AE01BADF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3056661745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32469C4339C;
        Fri, 10 Mar 2023 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458864;
        bh=r4sQguZ+i/cZlqPM1CYzJ3qXU0fSxlMDDzyhokLGqzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWFhNHR/7J9JGNN+APqzA1h16oHJW9t0qIgCgujMfmR1g9a7A9ZHgh4yu8etkG6Ux
         IuQfdk28hSZrgVOK1jujhsH0m2Z7uorksHSI/fcGfdyMiAJ2Cyq9nt7zpBXIB9gi3k
         aOPntw+GZP7fvuYXHVrxFM5h0MDsNGGCrGxk3tlE=
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
Subject: [PATCH 5.4 169/357] powerpc: Remove linker flag from KBUILD_AFLAGS
Date:   Fri, 10 Mar 2023 14:37:38 +0100
Message-Id: <20230310133742.178515761@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 95183a717eb67..6c32ea6dc7558 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -93,7 +93,7 @@ aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
 
 ifeq ($(HAS_BIARCH),y)
 KBUILD_CFLAGS	+= -m$(BITS)
-KBUILD_AFLAGS	+= -m$(BITS) -Wl,-a$(BITS)
+KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
-- 
2.39.2



