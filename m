Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2703F67A30B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbjAXTfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbjAXTfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:35:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D756A6C;
        Tue, 24 Jan 2023 11:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5390DB816D8;
        Tue, 24 Jan 2023 19:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07CFC433D2;
        Tue, 24 Jan 2023 19:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674588919;
        bh=a4BsyzggSYFLYmAD9g4fj3o8Vt6Azs6mBye6UuGoSWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSkFOwZBkGu39SEnS1HLu1pS5/MlTqwMAzrEkkkvIZha7jBLKpbj7hrjSoFbbMCeJ
         5bgOw2kAUxy5ogZUhYrwd8FeqhkFw2JN74fSjH9RtB0mtmk1XaezOmCB6fAsk+kGjM
         jSCZvBq84f3RMXT0Tq7GwfFo1+Y0kr5twzQrWuzHlrOLeUaPG9brz/K1NfYQNKg8x0
         Wa18430Knk+v84mvTPMHCeLWYmZgt3snPCccSM9SJbAaCcplKFq8YlQVcxQMORClOn
         z+DVnXSVi0HRZh6js+W305W5/hpDCAI77wA3yLdZbwbEJAGlEn8fQ1GRVCtzjfHr2U
         8LUYhlImfd1cg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 07/20] objtool: Add a missing comma to avoid string concatenation
Date:   Tue, 24 Jan 2023 11:29:51 -0800
Message-Id: <20230124193004.206841-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124193004.206841-1-ebiggers@kernel.org>
References: <20230124193004.206841-1-ebiggers@kernel.org>
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
index 3c2baeb86c578..985bcc5cea8a4 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -176,7 +176,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_and_make_dead"
+		"rewind_stack_and_make_dead",
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
-- 
2.39.1

