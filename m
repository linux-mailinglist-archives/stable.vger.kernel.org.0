Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B750572351
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiGLSo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiGLSoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58CFD7B90;
        Tue, 12 Jul 2022 11:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12BE76186E;
        Tue, 12 Jul 2022 18:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F77C3411C;
        Tue, 12 Jul 2022 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651330;
        bh=HAUe1xX18R+K6PokYOpqGZLlTgYNlzycxBTgy03jkzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsZ9EsBbMmD9WOgwo+0FTodzL+Y5FWLklNt18P6ZYb0muGvSbPif4G+9QdsUJQbu7
         Hqp96KHi9rEnsRsU6BdDYRVTTrjrPGOw0jtc62dvzmn3QCmuR416H2KG3Gr4b+yZaO
         J5LfsNNuhYRczn0YfuX137nb4hZ3OLQYwVKs6qII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 013/130] x86/alternative: Support ALTERNATIVE_TERNARY
Date:   Tue, 12 Jul 2022 20:37:39 +0200
Message-Id: <20220712183247.012031960@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit e208b3c4a9748b2c17aa09ba663b5096ccf82dce upstream.

Add ALTERNATIVE_TERNARY support for replacing an initial instruction
with either of two instructions depending on a feature:

  ALTERNATIVE_TERNARY "default_instr", FEATURE_NR,
                      "feature_on_instr", "feature_off_instr"

which will start with "default_instr" and at patch time will,
depending on FEATURE_NR being set or not, patch that with either
"feature_on_instr" or "feature_off_instr".

 [ bp: Add comment ontop. ]

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210311142319.4723-7-jgross@suse.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -179,6 +179,11 @@ static inline int alternatives_text_rese
 	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
 	".popsection\n"
 
+/* If @feature is set, patch in @newinstr_yes, otherwise @newinstr_no. */
+#define ALTERNATIVE_TERNARY(oldinstr, feature, newinstr_yes, newinstr_no) \
+	ALTERNATIVE_2(oldinstr, newinstr_no, X86_FEATURE_ALWAYS,	\
+		      newinstr_yes, feature)
+
 #define ALTERNATIVE_3(oldinsn, newinsn1, feat1, newinsn2, feat2, newinsn3, feat3) \
 	OLDINSTR_3(oldinsn, 1, 2, 3)						\
 	".pushsection .altinstructions,\"a\"\n"					\
@@ -210,6 +215,9 @@ static inline int alternatives_text_rese
 #define alternative_2(oldinstr, newinstr1, feature1, newinstr2, feature2) \
 	asm_inline volatile(ALTERNATIVE_2(oldinstr, newinstr1, feature1, newinstr2, feature2) ::: "memory")
 
+#define alternative_ternary(oldinstr, feature, newinstr_yes, newinstr_no) \
+	asm_inline volatile(ALTERNATIVE_TERNARY(oldinstr, feature, newinstr_yes, newinstr_no) ::: "memory")
+
 /*
  * Alternative inline assembly with input.
  *
@@ -380,6 +388,11 @@ static inline int alternatives_text_rese
 	.popsection
 .endm
 
+/* If @feature is set, patch in @newinstr_yes, otherwise @newinstr_no. */
+#define ALTERNATIVE_TERNARY(oldinstr, feature, newinstr_yes, newinstr_no) \
+	ALTERNATIVE_2 oldinstr, newinstr_no, X86_FEATURE_ALWAYS,	\
+	newinstr_yes, feature
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_ALTERNATIVE_H */


