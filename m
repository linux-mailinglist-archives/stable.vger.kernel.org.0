Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318DBF862
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfD3LkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbfD3LkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7903521707;
        Tue, 30 Apr 2019 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624411;
        bh=VcpKBqHheq+0zxr5mfTmUUIAIN1pPJCWkgC44Ioi6eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juKXwUexu3IftoKNqljaZkbaGflbOE7LE6+CJVtEonplZAWFt0pG0hUoo9ODsJXxN
         irGGQBoiXyPYDkLhDjP/U4oFcJIyS7ClnEn7TV0HPotE2sgkJa6EWKFu86xAIBMa8e
         Jq/nRF9ZQzXhHNkv+50FcFp/rVsrxMVLHUWlbuw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 4.9 04/41] MIPS: scall64-o32: Fix indirect syscall number load
Date:   Tue, 30 Apr 2019 13:38:15 +0200
Message-Id: <20190430113525.306156222@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Jarno <aurelien@aurel32.net>

commit 79b4a9cf0e2ea8203ce777c8d5cfa86c71eae86e upstream.

Commit 4c21b8fd8f14 (MIPS: seccomp: Handle indirect system calls (o32))
added indirect syscall detection for O32 processes running on MIPS64,
but it did not work correctly for big endian kernel/processes. The
reason is that the syscall number is loaded from ARG1 using the lw
instruction while this is a 64-bit value, so zero is loaded instead of
the syscall number.

Fix the code by using the ld instruction instead. When running a 32-bit
processes on a 64 bit CPU, the values are properly sign-extended, so it
ensures the value passed to syscall_trace_enter is correct.

Recent systemd versions with seccomp enabled whitelist the getpid
syscall for their internal  processes (e.g. systemd-journald), but call
it through syscall(SYS_getpid). This fix therefore allows O32 big endian
systems with a 64-bit kernel to run recent systemd versions.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: <stable@vger.kernel.org> # v3.15+
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/scall64-o32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -125,7 +125,7 @@ trace_a_syscall:
 	subu	t1, v0,  __NR_O32_Linux
 	move	a1, v0
 	bnez	t1, 1f /* __NR_syscall at offset 0 */
-	lw	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
+	ld	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
 	.set	pop
 
 1:	jal	syscall_trace_enter


