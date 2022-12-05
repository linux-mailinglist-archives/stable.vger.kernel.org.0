Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E91643193
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiLETQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiLETPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:15:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC60925E85
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 718FC61326
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA06C433C1;
        Mon,  5 Dec 2022 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267722;
        bh=g/SOH7vgQxbLgAEvP+geatIZCVFwyqXjMZkXzhjPKbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ML4D1yBNn2kaB0ntxCJm6+LYs2xgCz1GkrjsgC8oxq514sQbY8DTv619mBEjKQch+
         3LFnq+qNjlywK6Zzg5PmLzApLsMQR4Tx+grrtvCgKfeeojuOrgQiZ6y6W8wffBPBNA
         xVyx6VDwnD6g249pQeVHmK7oaW0pqKaGFvMyq1Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 4.14 28/77] kconfig: display recursive dependency resolution hint just once
Date:   Mon,  5 Dec 2022 20:09:19 +0100
Message-Id: <20221205190801.866714071@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit e3b03bf29d6b99fab7001fb20c33fe54928c157a upstream.

Commit 1c199f2878f6 ("kbuild: document recursive dependency limitation
/ resolution") probably intended to show a hint along with "recursive
dependency detected!" error, but it missed to add {...} guard, and the
hint is displayed in every loop of the dep_stack traverse, annoyingly.

This error was detected by GCC's -Wmisleading-indentation when switching
to build-time generation of lexer/parser.

scripts/kconfig/symbol.c: In function ‘sym_check_print_recursive’:
scripts/kconfig/symbol.c:1150:3: warning: this ‘if’ clause does not guard... [-Wmisleading-indentation]
   if (stack->sym == last_sym)
   ^~
scripts/kconfig/symbol.c:1153:4: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
    fprintf(stderr, "For a resolution refer to Documentation/kbuild/kconfig-language.txt\n");
    ^~~~~~~

I could simply add {...} to surround the three fprintf(), but I rather
chose to move the hint after the loop to make the whole message readable.

Fixes: 1c199f2878f6 ("kbuild: document recursive dependency limitation / resolution"
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/symbol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1150,8 +1150,7 @@ static void sym_check_print_recursive(st
 		if (stack->sym == last_sym)
 			fprintf(stderr, "%s:%d:error: recursive dependency detected!\n",
 				prop->file->name, prop->lineno);
-			fprintf(stderr, "For a resolution refer to Documentation/kbuild/kconfig-language.txt\n");
-			fprintf(stderr, "subsection \"Kconfig recursive dependency limitations\"\n");
+
 		if (stack->expr) {
 			fprintf(stderr, "%s:%d:\tsymbol %s %s value contains %s\n",
 				prop->file->name, prop->lineno,
@@ -1181,6 +1180,11 @@ static void sym_check_print_recursive(st
 		}
 	}
 
+	fprintf(stderr,
+		"For a resolution refer to Documentation/kbuild/kconfig-language.txt\n"
+		"subsection \"Kconfig recursive dependency limitations\"\n"
+		"\n");
+
 	if (check_top == &cv_stack)
 		dep_stack_remove();
 }


