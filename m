Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F36C19CF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjCTPiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjCTPiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEBFE077
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4396161593
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53681C4339B;
        Mon, 20 Mar 2023 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326175;
        bh=rsc6DeU+Ch57SmvyZGQKPDccSe/DsX+OxfnQCkjRClk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgqrcAqA1dg/URaaQUbzBSIUPniFUtsKnlpfI9qIocq2Lcp8D1H3Cai1FvUG4t4Wf
         TeqP4O2BaCQj9FQ+/3dKICPx4VGjIJ7c9/6zW3Dg/DY6s3YYZ2GspBOyaaTrhmBbqs
         wScTPvU99Uepl27aTWhRCxjrzr6lV3ea7vOLc6uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.2 188/211] powerpc/boot: Dont always pass -mcpu=powerpc when building 32-bit uImage
Date:   Mon, 20 Mar 2023 15:55:23 +0100
Message-Id: <20230320145521.392170709@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit ff7c76f66d8bad4e694c264c789249e1d3a8205d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/Makefile |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -39,13 +39,19 @@ BOOTCFLAGS    := -Wall -Wundef -Wstrict-
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


