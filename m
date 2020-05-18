Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A401D8747
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgERRiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgERRit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494E020878;
        Mon, 18 May 2020 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823528;
        bh=NYb8c7J1Gfowmxh8CILJGefXONSD55TVtFOevI5w1/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yspssO0xEbYpC+8kHMgWJbbeI0iU9h0LKqDJgSlSbXmW2EpLYa8G7yfswLWS1p/n0
         O61Qr9ptjF9Z7uQqOXO+1WNEJXMyMHkTYmEtXXjpbyrJ6JsiQ4A7m2WoZz1D4nr2OC
         FLhmMkGeC1JK95wi9Cpdj66sWk4t3ZYm2yOQE8l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Kojedzinszky <richard@kojedz.in>
Subject: [PATCH 4.4 19/86] binfmt_elf: Do not move brk for INTERP-less ET_EXEC
Date:   Mon, 18 May 2020 19:35:50 +0200
Message-Id: <20200518173454.352345138@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 7be3cb019db1cbd5fd5ffe6d64a23fefa4b6f229 upstream.

When brk was moved for binaries without an interpreter, it should have
been limited to ET_DYN only. In other words, the special case was an
ET_DYN that lacks an INTERP, not just an executable that lacks INTERP.
The bug manifested for giant static executables, where the brk would end
up in the middle of the text area on 32-bit architectures.

Reported-and-tested-by: Richard Kojedzinszky <richard@kojedz.in>
Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_elf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1104,7 +1104,8 @@ static int load_elf_binary(struct linux_
 		 * (since it grows up, and may collide early with the stack
 		 * growing down), and into the unused ELF_ET_DYN_BASE region.
 		 */
-		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) && !interpreter)
+		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
+		    loc->elf_ex.e_type == ET_DYN && !interpreter)
 			current->mm->brk = current->mm->start_brk =
 				ELF_ET_DYN_BASE;
 


