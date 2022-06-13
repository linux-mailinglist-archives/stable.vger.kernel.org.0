Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF47548CF2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380337AbiFMN6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380826AbiFMNzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:55:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0907C819A4;
        Mon, 13 Jun 2022 04:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AD24612AB;
        Mon, 13 Jun 2022 11:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980FAC34114;
        Mon, 13 Jun 2022 11:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120161;
        bh=ITQrcrc0jCXcYROcscW1HJKRxPDlx/31nD1+KTlyugk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwaOPJtAnbinJp3CcJ9HU2phL6VdXOM/6I0OKBk21RPByDy4qWY7cK3pRZy6ZS1ne
         CivzB4HT8Z5rBI9mStW12K3WrPI86fhj8nZ6OL18EDnwGiSBf61ll2UpMQlnLXd6Nd
         IGvq1wq9zWfIilc+/U/75Y5HmT3BX9FXIZMNnFYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 272/339] objtool: Mark __ubsan_handle_builtin_unreachable() as noreturn
Date:   Mon, 13 Jun 2022 12:11:37 +0200
Message-Id: <20220613094934.892798516@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

[ Upstream commit 385bd430c011a8cb8278e61c32d602d11e06f414 ]

  fs/ntfs3/ntfs3.prelink.o: warning: objtool: ni_read_frame() falls through to next function ni_readpage_cmpr.cold()

That is in fact:

000000000000124a <ni_read_frame.cold>:
    124a:       44 89 e0                mov    %r12d,%eax
    124d:       0f b6 55 98             movzbl -0x68(%rbp),%edx
    1251:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi        1254: R_X86_64_32S      .data+0x1380
    1258:       48 89 c6                mov    %rax,%rsi
    125b:       e8 00 00 00 00          call   1260 <ni_read_frame.cold+0x16>   125c: R_X86_64_PLT32    __ubsan_handle_shift_out_of_bounds-0x4
    1260:       48 8d 7d cc             lea    -0x34(%rbp),%rdi
    1264:       e8 00 00 00 00          call   1269 <ni_read_frame.cold+0x1f>   1265: R_X86_64_PLT32    __tsan_read4-0x4
    1269:       8b 45 cc                mov    -0x34(%rbp),%eax
    126c:       e9 00 00 00 00          jmp    1271 <ni_read_frame.cold+0x27>   126d: R_X86_64_PC32     .text+0x19109
    1271:       48 8b 75 a0             mov    -0x60(%rbp),%rsi
    1275:       48 63 d0                movslq %eax,%rdx
    1278:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi        127b: R_X86_64_32S      .data+0x13a0
    127f:       89 45 88                mov    %eax,-0x78(%rbp)
    1282:       e8 00 00 00 00          call   1287 <ni_read_frame.cold+0x3d>   1283: R_X86_64_PLT32    __ubsan_handle_shift_out_of_bounds-0x4
    1287:       8b 45 88                mov    -0x78(%rbp),%eax
    128a:       e9 00 00 00 00          jmp    128f <ni_read_frame.cold+0x45>   128b: R_X86_64_PC32     .text+0x19098
    128f:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi        1292: R_X86_64_32S      .data+0x11f0
    1296:       e8 00 00 00 00          call   129b <ni_readpage_cmpr.cold>     1297: R_X86_64_PLT32    __ubsan_handle_builtin_unreachable-0x4

000000000000129b <ni_readpage_cmpr.cold>:

Tell objtool that __ubsan_handle_builtin_unreachable() is a noreturn.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220502091514.GB479834@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 8a0971a620f0..f66e4ac0af94 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -185,7 +185,8 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"do_group_exit",
 		"stop_this_cpu",
 		"__invalid_creds",
-               "cpu_startup_entry",
+		"cpu_startup_entry",
+		"__ubsan_handle_builtin_unreachable",
 	};
 
 	if (!func)
-- 
2.35.1



