Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49259CA827
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbfJCQWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390236AbfJCQWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75AD22054F;
        Thu,  3 Oct 2019 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119723;
        bh=63xOMFMQUuzsi+PULzxkPcHXrSObujGwDMEmR4JZZAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SyIaFiwR4pwMk2erj4ItUtn/E9EMbUe1/fSuUpclhHpvFwMLjzRm7gO5ppgKRXgN
         oY9MKolCPh6uKY/3/bwQ6bQ+HXent1zHAsCaeYLoGHGZXNo1nbcv3dInw8jLK3nM8O
         eRa0kpIpzcjibLfDRh3ItCXh/EXgam17Tcx1q/pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Kojedzinszky <richard@kojedz.in>
Subject: [PATCH 4.19 170/211] binfmt_elf: Do not move brk for INTERP-less ET_EXEC
Date:   Thu,  3 Oct 2019 17:53:56 +0200
Message-Id: <20191003154526.183111566@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_elf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1144,7 +1144,8 @@ static int load_elf_binary(struct linux_
 		 * (since it grows up, and may collide early with the stack
 		 * growing down), and into the unused ELF_ET_DYN_BASE region.
 		 */
-		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) && !interpreter)
+		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
+		    loc->elf_ex.e_type == ET_DYN && !interpreter)
 			current->mm->brk = current->mm->start_brk =
 				ELF_ET_DYN_BASE;
 


