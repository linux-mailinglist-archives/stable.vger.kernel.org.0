Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04E849720E
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiAWOYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:24:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWOYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:24:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0F6B80CF1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B71C340E2;
        Sun, 23 Jan 2022 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947851;
        bh=VYHtY6ntn0KJtow7aG8j9kFUlouDQ9HjiO8Lmq7I2CI=;
        h=Subject:To:Cc:From:Date:From;
        b=1JSCJM5WlZdkHmahSDRrftiAh8O2dDKQ2livPbeXoOnpvRPWSM9kJVYCQZ6gRaz8P
         L54U4JI07OA6dyhmtWjUmRB1iuF1Ocuqp5tebOOQdPyEBfHUqXOFJTfW/kb9cqXjxT
         EHgIlcU15J1piYj5S42A/9h5bjxVBSP/JsnfGgJo=
Subject: FAILED: patch "[PATCH] lkdtm: Fix content of section containing" failed to apply to 4.14-stable tree
To:     christophe.leroy@csgroup.eu, arnd@arndb.de,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:24:08 +0100
Message-ID: <164294784819088@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bc93a22a19eb2b68a16ecf04cdf4b2ed65aaf398 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Fri, 8 Oct 2021 18:58:40 +0200
Subject: [PATCH] lkdtm: Fix content of section containing
 lkdtm_rodata_do_nothing()

On a kernel without CONFIG_STRICT_KERNEL_RWX, running EXEC_RODATA
test leads to "Illegal instruction" failure.

Looking at the content of rodata_objcopy.o, we see that the
function content zeroes only:

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	00 00 00 00 	.long 0x0

Add the contents flag in order to keep the content of the section
while renaming it.

	Disassembly of section .rodata:

	0000000000000000 <.lkdtm_rodata_do_nothing>:
	   0:	4e 80 00 20 	blr

Fixes: e9e08a07385e ("lkdtm: support llvm-objcopy")
Cc: stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/8900731fbc05fb8b0de18af7133a8fc07c3c53a1.1633712176.git.christophe.leroy@csgroup.eu

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index aa12097668d3..e2984ce51fe4 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -20,7 +20,7 @@ CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-			--rename-section .noinstr.text=.rodata,alloc,readonly,load
+			--rename-section .noinstr.text=.rodata,alloc,readonly,load,contents
 targets += rodata.o rodata_objcopy.o
 $(obj)/rodata_objcopy.o: $(obj)/rodata.o FORCE
 	$(call if_changed,objcopy)

