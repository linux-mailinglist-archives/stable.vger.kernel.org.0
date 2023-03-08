Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3F6B0299
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCHJPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjCHJOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:14:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975A33BDA5
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74A98CE1EF6
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 09:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C6BC433D2;
        Wed,  8 Mar 2023 09:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678266851;
        bh=zBOBOFVgbqkqBtn1TlTnSj8wbwxe0Gfayh2o6ghYSA4=;
        h=Subject:To:Cc:From:Date:From;
        b=QhniqiQECJuf2SPzOe/a+aaHpeEd0sO4IJUCOe1X1wn2J4ZyvBueT593worRsDnbi
         rDZti8l3c8XpB/wORki5hMPfU8wZZGlzPOBT1YWp1mw7UfDRD7nP6Hm9MN1sdtmmrM
         E8JAmoNUCgOFz6GOAfhSwMZ96yYJYxFJh7Ti3kLc=
Subject: FAILED: patch "[PATCH] powerpc/boot: Don't always pass -mcpu=powerpc when building" failed to apply to 6.1-stable tree
To:     pali@kernel.org, christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Mar 2023 10:14:00 +0100
Message-ID: <16782668406257@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x ff7c76f66d8bad4e694c264c789249e1d3a8205d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782668406257@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

ff7c76f66d8b ("powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff7c76f66d8bad4e694c264c789249e1d3a8205d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Wed, 25 Jan 2023 08:39:00 +0100
Subject: [PATCH] powerpc/boot: Don't always pass -mcpu=powerpc when building
 32-bit uImage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When CONFIG_TARGET_CPU is specified then pass its value to the compiler
-mcpu option. This fixes following build error when building kernel with
powerpc e500 SPE capable cross compilers:

    BOOTAS  arch/powerpc/boot/crt0.o
  powerpc-linux-gnuspe-gcc: error: unrecognized argument in option ‘-mcpu=powerpc’
  powerpc-linux-gnuspe-gcc: note: valid arguments to ‘-mcpu=’ are: 8540 8548 native
  make[1]: *** [arch/powerpc/boot/Makefile:231: arch/powerpc/boot/crt0.o] Error 1

Similar change was already introduced for the main powerpc Makefile in
commit 446cda1b21d9 ("powerpc/32: Don't always pass -mcpu=powerpc to the
compiler").

Fixes: 40a75584e526 ("powerpc/boot: Build wrapper for an appropriate CPU")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2ae3ae5887babfdacc34435bff0944b3f336100a.1674632329.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index d32d95aea5d6..295f76df13b5 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -39,13 +39,19 @@ BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		 $(LINUXINCLUDE)
 
 ifdef CONFIG_PPC64_BOOT_WRAPPER
-ifdef CONFIG_CPU_LITTLE_ENDIAN
-BOOTCFLAGS	+= -m64 -mcpu=powerpc64le
+BOOTCFLAGS	+= -m64
 else
-BOOTCFLAGS	+= -m64 -mcpu=powerpc64
+BOOTCFLAGS	+= -m32
 endif
+
+ifdef CONFIG_TARGET_CPU_BOOL
+BOOTCFLAGS	+= -mcpu=$(CONFIG_TARGET_CPU)
+else ifdef CONFIG_PPC64_BOOT_WRAPPER
+ifdef CONFIG_CPU_LITTLE_ENDIAN
+BOOTCFLAGS	+= -mcpu=powerpc64le
 else
-BOOTCFLAGS	+= -m32 -mcpu=powerpc
+BOOTCFLAGS	+= -mcpu=powerpc64
+endif
 endif
 
 BOOTCFLAGS	+= -isystem $(shell $(BOOTCC) -print-file-name=include)

