Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5AE541A76
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352403AbiFGVdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380913AbiFGVb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ADA22C465;
        Tue,  7 Jun 2022 12:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B66E36159D;
        Tue,  7 Jun 2022 19:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C1FC385A5;
        Tue,  7 Jun 2022 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628617;
        bh=DcRn6q8y0NgSCOb94r8hd95eiVL3HNDoJDtQsoRxYRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZ/TvKFruhKCbXAh7aMibWYvquLPL6aptvJ8NqM9OozgIwF0VXx7vvAQqBZhIcUmd
         X5ugS+KfwXasIORzwGjbyl4psDwbbIGVD9Fs7HQFii9kfL+zEibD8Fd2fysT/jt9Hw
         099t2lC+XRIXORYAg6+JfHMKNJ9aLxvw8jfKJEZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 394/879] linkage: Fix issue with missing symbol size
Date:   Tue,  7 Jun 2022 18:58:32 +0200
Message-Id: <20220607165014.300965465@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 3ff5f7840979aa36d47a6a00694826c78d63bf3c ]

Occasionally, typically when a function doesn't end with 'ret', an
alias on that function will have 0 size.

The difference between what GCC generates and our linkage magic, is
that GCC doesn't appear to provide .size for the alias'ed symbol at
all. And indeed, removing this directive cures the issue.

Additionally, GCC also doesn't emit .type for alias symbols either, so
also omit that.

Fixes: e0891269a8c2 ("linkage: add SYM_FUNC_ALIAS{,_LOCAL,_WEAK}()")
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220506121631.437480085@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/linkage.h | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index acb1ad2356f1..1feab6136b5b 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -171,12 +171,9 @@
 
 /* SYM_ALIAS -- use only if you have to */
 #ifndef SYM_ALIAS
-#define SYM_ALIAS(alias, name, sym_type, linkage)			\
-	linkage(alias) ASM_NL						\
-	.set alias, name ASM_NL						\
-	.type alias sym_type ASM_NL					\
-	.set .L__sym_size_##alias, .L__sym_size_##name ASM_NL		\
-	.size alias, .L__sym_size_##alias
+#define SYM_ALIAS(alias, name, linkage)			\
+	linkage(alias) ASM_NL				\
+	.set alias, name ASM_NL
 #endif
 
 /* === code annotations === */
@@ -261,7 +258,7 @@
  */
 #ifndef SYM_FUNC_ALIAS
 #define SYM_FUNC_ALIAS(alias, name)					\
-	SYM_ALIAS(alias, name, SYM_T_FUNC, SYM_L_GLOBAL)
+	SYM_ALIAS(alias, name, SYM_L_GLOBAL)
 #endif
 
 /*
@@ -269,7 +266,7 @@
  */
 #ifndef SYM_FUNC_ALIAS_LOCAL
 #define SYM_FUNC_ALIAS_LOCAL(alias, name)				\
-	SYM_ALIAS(alias, name, SYM_T_FUNC, SYM_L_LOCAL)
+	SYM_ALIAS(alias, name, SYM_L_LOCAL)
 #endif
 
 /*
@@ -277,7 +274,7 @@
  */
 #ifndef SYM_FUNC_ALIAS_WEAK
 #define SYM_FUNC_ALIAS_WEAK(alias, name)				\
-	SYM_ALIAS(alias, name, SYM_T_FUNC, SYM_L_WEAK)
+	SYM_ALIAS(alias, name, SYM_L_WEAK)
 #endif
 
 /* SYM_CODE_START -- use for non-C (special) functions */
-- 
2.35.1



