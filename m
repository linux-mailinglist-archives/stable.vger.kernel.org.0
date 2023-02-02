Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536E9687486
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 05:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjBBEo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 23:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBBEoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 23:44:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29647A488;
        Wed,  1 Feb 2023 20:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44C26CE2774;
        Thu,  2 Feb 2023 04:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF37C4339C;
        Thu,  2 Feb 2023 04:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675313029;
        bh=RlJYO0lbBiRRVAS7XhsN7Zwl+KQ8V40jkMt3z+fFE5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kz1lKWvLC+IAwkHWiuA7r63D1dz/g0mDOUSL8A2p64cyWM/eX76tWeM3KN58NNsb5
         6qjlXEswftJqGG6glbdQ0ilFIQ//9e+6KwS4q4kLBaMNQ3ff4LSU69RVS6S92/X0kk
         w0xdkhn16qvJd9/RJARoPscoFE1dwCNUAAzcPN7Dsr0Uv2iTwHL/UhdFPVfknI+df8
         wHxz+fB0WL7gKJw7tXZ1O+vPMA6hf/86aTJEFL3pK+PCmaUiqsY/VIlXT57OL6vqa4
         3rUzVtcl1LYC8+K/nULYpKDjgYKOpXjEmLOHsql1RdQIEYBNcNmN+FREKgBmTk3EPE
         rWjxjTbtnbTUg==
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
Subject: [PATCH 5.4 05/17] objtool: Add a missing comma to avoid string concatenation
Date:   Wed,  1 Feb 2023 20:42:43 -0800
Message-Id: <20230202044255.128815-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
References: <20230202044255.128815-1-ebiggers@kernel.org>
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
index 14be7d261ae7a..dfd67243faac0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -144,7 +144,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_and_make_dead"
+		"rewind_stack_and_make_dead",
 		"cpu_bringup_and_idle",
 	};
 
-- 
2.39.1

