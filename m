Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA36E404E
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 09:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDQHB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 03:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDQHB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 03:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00205212F
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 00:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F74461EA9
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AA2C433EF;
        Mon, 17 Apr 2023 07:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681714913;
        bh=mLwYEw6VZttVf7Oq23YK8qoHJCcfoeRzQw6IjlK/VEc=;
        h=Subject:To:Cc:From:Date:From;
        b=bcnSoEypn2hZwALakQE7V9qsXVVZM2f2blNOoVTKf6vyZRfciHzAwU1bbIzyZ19Y0
         +fDA6+OGI6BxMRJIIH3QzyGwo/+bBWqzj8Wd98tEeTcotgdWwkdCWB9jIF5BDkc5vu
         rcDaO32vx+7demWTHOyQJqPv09oI8nBiIcy3stCc=
Subject: FAILED: patch "[PATCH] purgatory: fix disabling debug info" failed to apply to 6.1-stable tree
To:     hi@alyssa.is, masahiroy@kernel.org, ndesaulniers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Apr 2023 09:01:47 +0200
Message-ID: <2023041747-monogram-playpen-8e77@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
git cherry-pick -x d83806c4c0cccc0d6d3c3581a11983a9c186a138
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041747-monogram-playpen-8e77@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

d83806c4c0cc ("purgatory: fix disabling debug info")
56e0790c7f9e ("RISC-V: add infrastructure to allow different str* implementations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d83806c4c0cccc0d6d3c3581a11983a9c186a138 Mon Sep 17 00:00:00 2001
From: Alyssa Ross <hi@alyssa.is>
Date: Sun, 26 Mar 2023 18:21:21 +0000
Subject: [PATCH] purgatory: fix disabling debug info

Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
-Wa versions of both of those if building with Clang and GNU as.  As a
result, debug info was being generated for the purgatory objects, even
though the intention was that it not be.

Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Cc: stable@vger.kernel.org
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index d16bf715a586..5730797a6b40 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -84,12 +84,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..82fec66d46d2 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)

