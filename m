Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A942310BC48
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732998AbfK0VTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733079AbfK0VKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC95A2154A;
        Wed, 27 Nov 2019 21:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889045;
        bh=eaBjrtbhJ62pLWppLNZsKpx+Q5x1JcT00JxRyiiPxLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghkfq75TvaicnQZ/AQHY/ZwWjpSHCk1ud+dCohrxqxFF//pM/XoLQ//jISwUPo/D0
         E1GVoQgNnMKcnH34eilvXtef/lalwKK9ggjC7ap2DkLsv3vvfhhAVPDgXjCodUpJAC
         ylY4z5FNidjP8nF2IsmiOsZT20vR7YM21+V/Ohfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.3 62/95] selftests/x86/mov_ss_trap: Fix the SYSENTER test
Date:   Wed, 27 Nov 2019 21:32:19 +0100
Message-Id: <20191127202928.046038424@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 8caa016bfc129f2c925d52da43022171d1d1de91 upstream.

For reasons that I haven't quite fully diagnosed, running
mov_ss_trap_32 on a 32-bit kernel results in an infinite loop in
userspace.  This appears to be because the hacky SYSENTER test
doesn't segfault as desired; instead it corrupts the program state
such that it infinite loops.

Fix it by explicitly clearing EBP before doing SYSENTER.  This will
give a more reliable segfault.

Fixes: 59c2a7226fc5 ("x86/selftests: Add mov_to_ss test")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/x86/mov_ss_trap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/x86/mov_ss_trap.c
+++ b/tools/testing/selftests/x86/mov_ss_trap.c
@@ -257,7 +257,8 @@ int main()
 			err(1, "sigaltstack");
 		sethandler(SIGSEGV, handle_and_longjmp, SA_RESETHAND | SA_ONSTACK);
 		nr = SYS_getpid;
-		asm volatile ("mov %[ss], %%ss; SYSENTER" : "+a" (nr)
+		/* Clear EBP first to make sure we segfault cleanly. */
+		asm volatile ("xorl %%ebp, %%ebp; mov %[ss], %%ss; SYSENTER" : "+a" (nr)
 			      : [ss] "m" (ss) : "flags", "rcx"
 #ifdef __x86_64__
 				, "r11"


