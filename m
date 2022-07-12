Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37EE57233F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiGLSqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiGLSpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ABBDB2E2;
        Tue, 12 Jul 2022 11:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 395EFB81BBB;
        Tue, 12 Jul 2022 18:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C67C3411C;
        Tue, 12 Jul 2022 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651352;
        bh=l0kO0QEUe8EFVtCdORKJzuiIYU1+sCDa53haTUQKWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJg3Al14bssennG7Fm5cCOMiBT4+hONK/mv+P7u94Xy/5XY67Tn6ouLwUX6woViaC
         ewD6x+PGzyBMs+k7bf9by3K2aDcVvRuuv2yT5kDlsD0XFwd+6tmi6QyVof6VmCZngI
         134D4lZjPXolbwtpOnCwm3cFvvBxXxR9hWd8zZMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 051/130] x86/asm: Fix register order
Date:   Tue, 12 Jul 2022 20:38:17 +0200
Message-Id: <20220712183248.791781759@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit a92ede2d584a2e070def59c7e47e6b6f6341c55c upstream.

Ensure the register order is correct; this allows for easy translation
between register number and trampoline and vice-versa.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120309.978573921@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/GEN-for-each-reg.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/GEN-for-each-reg.h
+++ b/arch/x86/include/asm/GEN-for-each-reg.h
@@ -1,11 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * These are in machine order; things rely on that.
+ */
 #ifdef CONFIG_64BIT
 GEN(rax)
-GEN(rbx)
 GEN(rcx)
 GEN(rdx)
+GEN(rbx)
+GEN(rsp)
+GEN(rbp)
 GEN(rsi)
 GEN(rdi)
-GEN(rbp)
 GEN(r8)
 GEN(r9)
 GEN(r10)
@@ -16,10 +21,11 @@ GEN(r14)
 GEN(r15)
 #else
 GEN(eax)
-GEN(ebx)
 GEN(ecx)
 GEN(edx)
+GEN(ebx)
+GEN(esp)
+GEN(ebp)
 GEN(esi)
 GEN(edi)
-GEN(ebp)
 #endif


