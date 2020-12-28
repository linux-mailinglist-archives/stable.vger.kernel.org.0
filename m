Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1C72E4331
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407091AbgL1PeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391542AbgL1Nwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19D3208B3;
        Mon, 28 Dec 2020 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163529;
        bh=jUQzN0sNy2IEQHh9giQ+uMRFIT9nlCAy8quVANockp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNSuFCsY2WRNuFBwznsFoo/rbyVL0n2X1LxJsgVwOX73x4PYad7N6cvjRPJEWnyNs
         +UnzUq1R35DZsxIwulzjW9EH9LSXxlSN5SE+fXtAFcKrIcsxZf1+CHyoCNdQt5CIhb
         D0VQ931M60RBCewMHjaHNZUaVzxk/GFQBjc+aQFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Barret Rhoden <brho@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 318/453] initramfs: fix clang build failure
Date:   Mon, 28 Dec 2020 13:49:14 +0100
Message-Id: <20201228124952.512063851@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 55d5b7dd6451b58489ce384282ca5a4a289eb8d5 ]

There is only one function in init/initramfs.c that is in the .text
section, and it is marked __weak.  When building with clang-12 and the
integrated assembler, this leads to a bug with recordmcount:

  ./scripts/recordmcount  "init/initramfs.o"
  Cannot find symbol for section 2: .text.
  init/initramfs.o: failed

I'm not quite sure what exactly goes wrong, but I notice that this
function is only ever called from an __init function, and normally
inlined.  Marking it __init as well is clearly correct and it leads to
recordmcount no longer complaining.

Link: https://lkml.kernel.org/r/20201204165742.3815221-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 5feee4f616d55..00a32799a38b0 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -527,7 +527,7 @@ extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
-void __weak free_initrd_mem(unsigned long start, unsigned long end)
+void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
 			"initrd");
-- 
2.27.0



