Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474344D4B65
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbiCJOVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244472AbiCJOTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:19:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BB1C1CBF;
        Thu, 10 Mar 2022 06:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDB5CB82676;
        Thu, 10 Mar 2022 14:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C607FC340EB;
        Thu, 10 Mar 2022 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921748;
        bh=DvEI6aRgVGSp13qeZIvZaOfCgzZ25LrHDBt0QKYNd0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTU4MddBPFYOTzKHtSSh7tvmjaa95J9H0E1cYUvTussJZkGPp49zF++eGM4io5ySK
         C/5vNe3K0tUvY8NfK2+RO+oYBaUQ+DkOwRaN98YlEcwpkJlD7T9JHysMZGFeBreDRS
         S70RR7Ml1B3rIRxpfxEM86xOsHVf/RwCPmFlWTUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meelis Roos <mroos@linux.ee>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 27/38] x86/build: Fix compiler support check for CONFIG_RETPOLINE
Date:   Thu, 10 Mar 2022 15:13:40 +0100
Message-Id: <20220310140808.928982540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 25896d073d8a0403b07e6dec56f58e6c33678207 upstream.

It is troublesome to add a diagnostic like this to the Makefile
parse stage because the top-level Makefile could be parsed with
a stale include/config/auto.conf.

Once you are hit by the error about non-retpoline compiler, the
compilation still breaks even after disabling CONFIG_RETPOLINE.

The easiest fix is to move this check to the "archprepare" like
this commit did:

  829fe4aa9ac1 ("x86: Allow generating user-space headers without a compiler")

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Fixes: 4cd24de3a098 ("x86/retpoline: Make CONFIG_RETPOLINE depend on compiler support")
Link: http://lkml.kernel.org/r/1543991239-18476-1-git-send-email-yamada.masahiro@socionext.com
Link: https://lkml.org/lkml/2018/12/4/206
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -221,9 +221,6 @@ ifdef CONFIG_RETPOLINE
     RETPOLINE_CFLAGS_CLANG := -mretpoline-external-thunk
 
     RETPOLINE_CFLAGS += $(call cc-option,$(RETPOLINE_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_CFLAGS_CLANG)))
-    ifeq ($(RETPOLINE_CFLAGS),)
-      $(error You are building kernel with non-retpoline compiler, please update your compiler.)
-    endif
     KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
 endif
 
@@ -240,6 +237,13 @@ archprepare:
 ifeq ($(CONFIG_KEXEC_FILE),y)
 	$(Q)$(MAKE) $(build)=arch/x86/purgatory arch/x86/purgatory/kexec-purgatory.c
 endif
+ifdef CONFIG_RETPOLINE
+ifeq ($(RETPOLINE_CFLAGS),)
+	@echo "You are building kernel with non-retpoline compiler." >&2
+	@echo "Please update your compiler." >&2
+	@false
+endif
+endif
 
 ###
 # Kernel objects


