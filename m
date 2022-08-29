Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6515A4A04
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiH2LcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiH2LbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:31:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E416CF7F;
        Mon, 29 Aug 2022 04:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC8D61185;
        Mon, 29 Aug 2022 11:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14400C433C1;
        Mon, 29 Aug 2022 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771915;
        bh=SjK8YthD50v9y6edsXYSTabrhgyU4hJiAfB4Nscbk8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGRgFLhR6hCzQiJ/HNg2UormGM4N8XpJ2gM3BgE2Ze6/d9HxYWXGmUFAX26v49sG6
         VP/16ksYbx/6OY8eH/yhnIq0DIEtGH9YDVyd4mDObBXqtVLi6g2fjRId3FFJFxAlZh
         oqpMkttyA7njn+nkMZeYr8mS1nlIEscCf8sxNxZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.19 139/158] x86/nospec: Fix i386 RSB stuffing
Date:   Mon, 29 Aug 2022 12:59:49 +0200
Message-Id: <20220829105814.907576893@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -50,6 +50,7 @@
  * the optimal version - two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr)			\
 	mov	$(nr/2), reg;				\
 771:							\
@@ -60,6 +61,17 @@
 	jnz	771b;					\
 	/* barrier for jnz misprediction */		\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr)			\
+	.rept nr;					\
+	__FILL_RETURN_SLOT;				\
+	.endr;						\
+	add	$(BITS_PER_LONG/8) * nr, %_ASM_SP;
+#endif
 
 /*
  * Stuff a single RSB slot.


