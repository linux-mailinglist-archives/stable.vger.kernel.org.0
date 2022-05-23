Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F695531CF2
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbiEWREA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiEWRD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:03:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC355253F;
        Mon, 23 May 2022 10:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A72FB811E9;
        Mon, 23 May 2022 17:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555E5C385AA;
        Mon, 23 May 2022 17:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325434;
        bh=xhmdDEoKotcUO/7eHbPi3dL9BFugG1l1EDjl/avpqzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQshdhbMzS+bzOeKolBu1yo1ol0px+ResS9cwCQ6aV8+KIwUFIDyf79TqpQOhhSdv
         /p9bJsQeP3+JB/UkA8RRgpq1vgIXPhHvtgaxeSMR/GZAOp5eRVsqLJGQMCY7s0jLm5
         ufvdWsbax5/c5tjn9OY2qWVyLkZGIFxJiLdNHP24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/25] um: Cleanup syscall_handler_t definition/cast, fix warning
Date:   Mon, 23 May 2022 19:03:20 +0200
Message-Id: <20220523165745.101254298@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
References: <20220523165743.398280407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit f4f03f299a56ce4d73c5431e0327b3b6cb55ebb9 ]

The syscall_handler_t type for x86_64 was defined as 'long (*)(void)',
but always cast to 'long (*)(long, long, long, long, long, long)' before
use. This now triggers a warning (see below).

Define syscall_handler_t as the latter instead, and remove the cast.
This simplifies the code, and fixes the warning.

Warning:
In file included from ../arch/um/include/asm/processor-generic.h:13
                 from ../arch/x86/um/asm/processor.h:41
                 from ../include/linux/rcupdate.h:30
                 from ../include/linux/rculist.h:11
                 from ../include/linux/pid.h:5
                 from ../include/linux/sched.h:14
                 from ../include/linux/ptrace.h:6
                 from ../arch/um/kernel/skas/syscall.c:7:
../arch/um/kernel/skas/syscall.c: In function ‘handle_syscall’:
../arch/x86/um/shared/sysdep/syscalls_64.h:18:11: warning: cast between incompatible function types from ‘long int (*)(void)’ to ‘long int (*)(long int,  long int,  long int,  long int,  long int,  long int)’ [
-Wcast-function-type]
   18 |         (((long (*)(long, long, long, long, long, long)) \
      |           ^
../arch/x86/um/asm/ptrace.h:36:62: note: in definition of macro ‘PT_REGS_SET_SYSCALL_RETURN’
   36 | #define PT_REGS_SET_SYSCALL_RETURN(r, res) (PT_REGS_AX(r) = (res))
      |                                                              ^~~
../arch/um/kernel/skas/syscall.c:46:33: note: in expansion of macro ‘EXECUTE_SYSCALL’
   46 |                                 EXECUTE_SYSCALL(syscall, regs));
      |                                 ^~~~~~~~~~~~~~~

Signed-off-by: David Gow <davidgow@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/shared/sysdep/syscalls_64.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/um/shared/sysdep/syscalls_64.h b/arch/x86/um/shared/sysdep/syscalls_64.h
index 8a7d5e1da98e..1e6875b4ffd8 100644
--- a/arch/x86/um/shared/sysdep/syscalls_64.h
+++ b/arch/x86/um/shared/sysdep/syscalls_64.h
@@ -10,13 +10,12 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 
-typedef long syscall_handler_t(void);
+typedef long syscall_handler_t(long, long, long, long, long, long);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	(((long (*)(long, long, long, long, long, long)) \
-	  (*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
+	(((*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
 		 		      UPT_SYSCALL_ARG2(&regs->regs), \
 				      UPT_SYSCALL_ARG3(&regs->regs), \
 				      UPT_SYSCALL_ARG4(&regs->regs), \
-- 
2.35.1



