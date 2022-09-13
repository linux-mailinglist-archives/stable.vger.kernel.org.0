Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0C5B752E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiIMPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiIMPcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B5F7F118;
        Tue, 13 Sep 2022 07:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0142EB80F1A;
        Tue, 13 Sep 2022 14:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575FFC433D6;
        Tue, 13 Sep 2022 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079587;
        bh=reUpS03sK+iOiluB79gKV2t+j7afT4DYT/IaDQx99M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfzVSm8ObK5D7Y47ziVTNV9v7qgN0xr4MRZTThplWPF182mTfD7CYEvggqrTvKh9v
         ZJUenPFB1qD/dYUcZA0sgwT85RRlMcws0hrNRk6tT9Kkil7jNLUBVhJmqSobT4kYMa
         bGrLglAME3x4QbpfkdUr7cTKnTYGaMUUv+zFknXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 4.19 77/79] x86/nospec: Fix i386 RSB stuffing
Date:   Tue, 13 Sep 2022 16:07:35 +0200
Message-Id: <20220913140352.600717282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

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
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -35,6 +35,7 @@
  * the optimal version — two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
@@ -55,6 +56,19 @@
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
 
 /* Sequence to mitigate PBRSB on eIBRS CPUs */
 #define __ISSUE_UNBALANCED_RET_GUARD(sp)	\


