Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280B9540AA2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350952AbiFGSXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352543AbiFGSRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268F13893F;
        Tue,  7 Jun 2022 10:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C1C3617AA;
        Tue,  7 Jun 2022 17:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D215C36B02;
        Tue,  7 Jun 2022 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624340;
        bh=Fx89bDr0xooQi1N967Gfk2wxPKTRWLLtU0MNHtBaIxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FneBxfGRnRwuKOn+qiHEcWtwuKnd76MvdTMomOCLs+VhQY3O52+8lRExSnAHX8cke
         XTRsDPRJp6FJs9JHbJrzvo2gityKzSZBQaaLvRDcNDXOBFXDKRVYYIDq3HF6LmI4re
         +VhO8N8aIL1n8mijyeBjVVtApSsr+f4XGkR8SwsHZ8KioJddP2Kjb5Umz45ZQiD/Z3
         XnRBi9rnaXogV9PjipFDxAUQt87gHlygpKIHIHk2u+ue6Sw7iM1aJCRtuFZtaP0M3A
         O3e4aU1CMs56CzxWrN2RrGZU+suGHGtK81XM5YbM2Va4KyWDcahPv3dVOAXQIYtL/y
         jtZmFZ+yfwmZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 5.18 53/68] objtool: Mark __ubsan_handle_builtin_unreachable() as noreturn
Date:   Tue,  7 Jun 2022 13:48:19 -0400
Message-Id: <20220607174846.477972-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ca5b74603008..a0b4a5874fce 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -184,7 +184,8 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
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

