Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17285B7323
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiIMPDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiIMPBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:01:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A58E98;
        Tue, 13 Sep 2022 07:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9C461494;
        Tue, 13 Sep 2022 14:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02978C433C1;
        Tue, 13 Sep 2022 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079369;
        bh=M5hartn5sc0ivAOrmjuDqfTK3eYU0BpZ1hEndnoIAjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCImXFWOmsKTCABcw/cidqKjeJ5n5d8vUcbMr3ddpoIFhXJZGinLw/gj4anwbbHVG
         uBK1NfskBDM3UWCVeAPf7QDiFPsQ0NpIMYpzRJahcbL59Meo26zymtLQ9s3jCTZzZY
         l17RdiFdtAlU3neRCpoAQ17xMkFJAS6i7glajl6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 107/108] x86/nospec: Fix i386 RSB stuffing
Date:   Tue, 13 Sep 2022 16:07:18 +0200
Message-Id: <20220913140358.220874709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 332924973725e8cdcc783c175f68cf7e162cb9e5 upstream.

Turns out that i386 doesn't unconditionally have LFENCE, as such the
loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
chips.

Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net
[bwh: Backported to 4.19/5.4:
 - __FILL_RETURN_BUFFER takes an sp parameter
 - Open-code __FILL_RETURN_SLOT]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -44,6 +44,7 @@
  * the optimal version — two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
@@ -64,6 +65,19 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
+	.rept nr;				\
+	call	772f;				\
+	int3;					\
+772:;						\
+	.endr;					\
+	add	$(BITS_PER_LONG/8) * nr, sp;
+#endif
 
 #define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
 	call	881f;				\


