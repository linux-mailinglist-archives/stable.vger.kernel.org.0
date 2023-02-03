Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DEF688BBC
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 01:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjBCA2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 19:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjBCA2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 19:28:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57731233E0;
        Thu,  2 Feb 2023 16:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4CBE61D38;
        Fri,  3 Feb 2023 00:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B9CC433A7;
        Fri,  3 Feb 2023 00:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675384085;
        bh=gMkaknhHOUOvbO7ZN04Mon7pIpUm85+6r8AS4b1iOcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no1pyuVnYmMPw+FlEWw7leFN33IgSuFQvQ03xKn3qyG8Do7RJzD0/t1cjhHav9sZL
         /QVdpKhwMra2fIgQkgI+cZlCKSoRmnrmvvOY6bBiBMqr98SmI+NOYQvOQHExxK67DZ
         hAgYtIHm8qOcsh7u1aSacyPn6+Jsyr8Hab6PmtbA6UJ/XlkCASn6u/vZ7fnVX62/Hs
         li7ViTQeFy1Xy/r4GA3Wh5VRvPpUw/CBC4YRx1AQYw76X7/iWGFhjRd/GWkjFxJOa9
         W/zjAe8IN8bmV79Z/g5+ltMKix3R89L3TSL5AkDBu+Lz+Y0FXJ1L+WTK4Yf684Tmwa
         94GSnpKBLfG2w==
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
Subject: [PATCH 4.19 v2 04/15] objtool: Add a missing comma to avoid string concatenation
Date:   Thu,  2 Feb 2023 16:27:06 -0800
Message-Id: <20230203002717.49198-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203002717.49198-1-ebiggers@kernel.org>
References: <20230203002717.49198-1-ebiggers@kernel.org>
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
index 0477190557107..55f3e7fa1c5d0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -168,7 +168,7 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_and_make_dead"
+		"rewind_stack_and_make_dead",
 	};
 
 	if (func->bind == STB_WEAK)
-- 
2.39.1

