Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7571372929
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 12:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhEDKqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 06:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhEDKqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 06:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 198BC611AB;
        Tue,  4 May 2021 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620125114;
        bh=MQBVXYI4JNJL3H8Ev1c0zij2OqljXom3tPD8zsNDclQ=;
        h=From:To:Cc:Subject:Date:From;
        b=OCUS/xwUUPxUBs02l4upzMUXrg3f73KSpVjWAeJiTI9k09G8M4pQ0U1gcF7yFzOJL
         /ZgMRZ1diVtiLPRZi4vyrshSKxgjR4goDBvSqSCPPR2HHS6ctYQ403wnkybFi59zxk
         fSH74eS24ZmWZZEQXXYFvjKr9VMFz/yZYK1G2KIAg654P2lbUj3P47BdexCj6zfGrv
         QPn6J9X5IBytFRP14rUKWAo536E0Ntf19J5yVEk2IEXDh0R53LoROxlths9AISKd6A
         R9fsVjCGlOHU5aAB8mELrqG6MJADdjk1fLthc23PRkZavxgmGor/LmX8JH/21dX2af
         6jDzA3zGA2MHQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] [stable v5.4] avoid __memcat_p link failure
Date:   Tue,  4 May 2021 12:44:33 +0200
Message-Id: <20210504104441.1317138-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The kernel test robot reports a link error when the stm driver is a
loadable module on any v5.4 kernel:

> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!

This was fixed in mainline with commit 7273ad2b08f8 ("kbuild: link
lib-y objects to vmlinux forcibly when CONFIG_MODULES=y"), which
is fairly intrusive.

Fix the v5.4 specific issue with a minimal subset of that patch,
linking only the failing object into the kernel. Kernels before v4.20
are not affected.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://groups.google.com/g/clang-built-linux/c/H-PrABqYShg
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index c5892807e06f..3b8977aed1b4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -31,7 +31,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
-	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o
+	 nmi_backtrace.o nodemask.o win_minmax.o
 
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -46,7 +46,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o \
 	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
-	 generic-radix-tree.o
+	 generic-radix-tree.o memcat_p.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
-- 
2.29.2

