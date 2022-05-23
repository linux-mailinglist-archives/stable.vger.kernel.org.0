Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6025317A0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbiEWRMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbiEWRKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE16D1B6;
        Mon, 23 May 2022 10:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BA1614F5;
        Mon, 23 May 2022 17:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5D3C385A9;
        Mon, 23 May 2022 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325803;
        bh=xhmdDEoKotcUO/7eHbPi3dL9BFugG1l1EDjl/avpqzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6GVaBdNz1kA574X1LLnePWB53r6P8K2UjmJMbvsFsKhyoTG7Gry9zmgsxYiLhy5M
         mLvvuxQxLAbgiPWysYTNNWMrYUCTqUt2POFfNUeOv0BAGpZyOiyHPZO5cU8MiwNm+V
         RPVBy5piLCib9VcsFyFGrBiS9+uS8SShT9yVBCfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/44] um: Cleanup syscall_handler_t definition/cast, fix warning
Date:   Mon, 23 May 2022 19:04:46 +0200
Message-Id: <20220523165753.908913811@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
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



