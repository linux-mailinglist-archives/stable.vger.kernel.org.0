Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B18688BE0
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjBCAfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBCAfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:35:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85856384F;
        Thu,  2 Feb 2023 16:35:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6395061D4A;
        Fri,  3 Feb 2023 00:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D1C433A8;
        Fri,  3 Feb 2023 00:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384524;
        bh=Q1iK07+TfUGftVW45xfnQtsOGOOjDYaWhjdzlKJkRcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzWVcBWpbkKGjiEs5IuYVj2pTpiqZIxYjIxFTadGmuWgHfCQA/1/nDEHB8WwXqefI
         YaUZjh0KqqrEP0Z9OrUmra9UHr9i35yn7IEafLLmVzz6N1zyuqr6VPermlWzh7wMUp
         7pO+p2n0zmGFaH7TZA/3DXS5BngX1xxzkmQFR/3SAAw3rCcWZlfHbZ0SfYqWYXk2bL
         goyxJTwuhK4B+Ts6VUFrNbJe3Te2J9V2kxpLS6JBGPk2Z/NrGUOPzGPu6SKhHUlwgm
         lhFLQDDuidFNimVBYZHYNpwKOfsYUJ7C6YJEvTI3lMAe4Sgics7lA1ohA/Yr1q1ZVs
         0ayFrusU69Ztg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 4.14 v2 04/15] objtool: Add a missing comma to avoid string concatenation
Date:   Thu,  2 Feb 2023 16:33:43 -0800
Message-Id: <20230203003354.85691-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203003354.85691-1-ebiggers@kernel.org>
References: <20230203003354.85691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 1fb466dff904e4a72282af336f2c355f011eec61 upstream.

Recently the kbuild robot reported two new errors:

>> lib/kunit/kunit-example-test.o: warning: objtool: .text.unlikely: unexpected end of section
>> arch/x86/kernel/dumpstack.o: warning: objtool: oops_end() falls through to next function show_opcodes()

I don't know why they did not occur in my test setup but after digging
it I realized I had accidentally dropped a comma in
tools/objtool/check.c when I renamed rewind_stack_do_exit to
rewind_stack_and_make_dead.

Add that comma back to fix objtool errors.

Link: https://lkml.kernel.org/r/202112140949.Uq5sFKR1-lkp@intel.com
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9048b02b54474..e93c061654a79 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -167,7 +167,7 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"lbug_with_loc",
 		"fortify_panic",
 		"machine_real_restart",
-		"rewind_stack_and_make_dead"
+		"rewind_stack_and_make_dead",
 	};
 
 	if (func->bind == STB_WEAK)
-- 
2.39.1

