Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B39B6811A9
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbjA3OPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbjA3OPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3770B1ABE3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F9BB80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F103C4339B;
        Mon, 30 Jan 2023 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088143;
        bh=Mc4MWRN7tzO1+3uBygRSvBjRFmkGqfd9XzSUxBgzD2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iSyADvtBA2QW9W+Gg/giD5TbW/CQ/ajWT2FvB2mcy4dGFEf4epedoOQxobdj74ud
         gh/RTjbo60p6jp8JHfKDix4+GxZN/ZWSYmJoepIp4y/yuuABuw4sKloBuuMvshtgtv
         CXc+/umyBF7C8nKxGisnC38EJPcjzz21BEVmfLKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/204] objtool: Add a missing comma to avoid string concatenation
Date:   Mon, 30 Jan 2023 14:51:34 +0100
Message-Id: <20230130134322.202689226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 82ade76dcef2..758c0ba8de35 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -177,7 +177,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_and_make_dead"
+		"rewind_stack_and_make_dead",
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
-- 
2.39.0



