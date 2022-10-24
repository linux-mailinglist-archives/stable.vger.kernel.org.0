Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B5A60B82B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiJXTm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiJXTlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:41:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B18020991;
        Mon, 24 Oct 2022 11:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 903D9B811CE;
        Mon, 24 Oct 2022 11:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC364C433B5;
        Mon, 24 Oct 2022 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612499;
        bh=Oo5dzfgUvi7RFuvhID2RTEtBjZh0y9xtz/tZcCFnyi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo/aFpVorSzGJCC/yMtCya7QWiF1qIG2+tva80cUYp6J4PrUq1KHYnI14XY3+wlQm
         JvNBeSnd+5yyaI0dCUiGSHNjDahxHZsV/cWPioM7Ue8qTBKjtM7bTHO724eMiAwHv7
         FbQwsojzLhjVQMqIGroBs8ZPiGWWNHKSTWIf03OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Straub <lukasstraub2@web.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 4.19 011/229] um: Cleanup syscall_handler_t cast in syscalls_32.h
Date:   Mon, 24 Oct 2022 13:28:50 +0200
Message-Id: <20221024112959.505038051@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Straub <lukasstraub2@web.de>

[ Upstream commit 61670b4d270c71219def1fbc9441debc2ac2e6e9 ]

Like in f4f03f299a56ce4d73c5431e0327b3b6cb55ebb9
"um: Cleanup syscall_handler_t definition/cast, fix warning",
remove the cast to to fix the compiler warning.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/shared/sysdep/syscalls_32.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/um/shared/sysdep/syscalls_32.h b/arch/x86/um/shared/sysdep/syscalls_32.h
index 68fd2cf526fd..f6e9f84397e7 100644
--- a/arch/x86/um/shared/sysdep/syscalls_32.h
+++ b/arch/x86/um/shared/sysdep/syscalls_32.h
@@ -6,10 +6,9 @@
 #include <asm/unistd.h>
 #include <sysdep/ptrace.h>
 
-typedef long syscall_handler_t(struct pt_regs);
+typedef long syscall_handler_t(struct syscall_args);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) \
-	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
-- 
2.35.1



