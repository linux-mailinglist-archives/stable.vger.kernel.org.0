Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48B566C5A4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbjAPQIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjAPQHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B25927D5F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFAF2B8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FECC433D2;
        Mon, 16 Jan 2023 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885139;
        bh=+vMm84llW0ldy7b0SOEWmyn973X4w9FDka0RM6nxWk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqKmfuO6fy1yib1+Q49Mtjwh8ZVcEYY0lrGxeC1fr1SToFlBPwpLGkjZ5mTe7Q9/A
         jeizAdQHqgXNbknSnqs0u16x5XESFUQ7YR44Y2hKvkJzghsfaO8NHIqGPRIhhjsLXq
         AwDUOeHvjG87hSEAQaM7N0VhI7yyEFRx7DnzTLkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/86] tools/nolibc: restore mips branch ordering in the _start block
Date:   Mon, 16 Jan 2023 16:51:39 +0100
Message-Id: <20230116154749.749364999@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 184177c3d6e023da934761e198c281344d7dd65b ]

Depending on the compiler used and the optimization options, the sbrk()
test was crashing, both on real hardware (mips-24kc) and in qemu. One
such example is kernel.org toolchain in version 11.3 optimizing at -Os.

Inspecting the sys_brk() call shows the following code:

  0040047c <sys_brk>:
    40047c:       24020fcd        li      v0,4045
    400480:       27bdffe0        addiu   sp,sp,-32
    400484:       0000000c        syscall
    400488:       27bd0020        addiu   sp,sp,32
    40048c:       10e00001        beqz    a3,400494 <sys_brk+0x18>
    400490:       00021023        negu    v0,v0
    400494:       03e00008        jr      ra

It is obviously wrong, the "negu" instruction is placed in beqz's
delayed slot, and worse, there's no nop nor instruction after the
return, so the next function's first instruction (addiu sip,sip,-32)
will also be executed as part of the delayed slot that follows the
return.

This is caused by the ".set noreorder" directive in the _start block,
that applies to the whole program. The compiler emits code without the
delayed slots and relies on the compiler to swap instructions when this
option is not set. Removing the option would require to change the
startup code in a way that wouldn't make it look like the resulting
code, which would not be easy to debug. Instead let's just save the
default ordering before changing it, and restore it at the end of the
_start block. Now the code is correct:

  0040047c <sys_brk>:
    40047c:       24020fcd        li      v0,4045
    400480:       27bdffe0        addiu   sp,sp,-32
    400484:       0000000c        syscall
    400488:       10e00002        beqz    a3,400494 <sys_brk+0x18>
    40048c:       27bd0020        addiu   sp,sp,32
    400490:       00021023        negu    v0,v0
    400494:       03e00008        jr      ra
    400498:       00000000        nop

Fixes: 66b6f755ad45 ("rcutorture: Import a copy of nolibc") #5.0
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/arch-mips.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
index 1a124790c99f..5d647afa42e6 100644
--- a/tools/include/nolibc/arch-mips.h
+++ b/tools/include/nolibc/arch-mips.h
@@ -192,6 +192,7 @@ struct sys_stat_struct {
 asm(".section .text\n"
     ".weak __start\n"
     ".set nomips16\n"
+    ".set push\n"
     ".set    noreorder\n"
     ".option pic0\n"
     ".ent __start\n"
@@ -210,6 +211,7 @@ asm(".section .text\n"
     "li $v0, 4001\n"              // NR_exit == 4001
     "syscall\n"
     ".end __start\n"
+    ".set pop\n"
     "");
 
 #endif // _NOLIBC_ARCH_MIPS_H
-- 
2.35.1



