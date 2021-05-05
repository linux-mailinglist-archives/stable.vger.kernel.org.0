Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3190B3739E7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhEEMGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhEEMGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1705961154;
        Wed,  5 May 2021 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216311;
        bh=EZ91tBBeYNpgMvqnjztljXaqTqj0kUPnLzpKRLHH8Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZX5QMRoSHpm1EcZMmrvJNc0/6ECUdBNafq9pKWP9xqiGESRqQmNigLQwh/7yxlkU6
         HuXRaR7ZM1r8MjfIsD4VO6uekpkiPKECe5VFnUDo/h44hzokjLf0GtX+lpDXZ9ZZjO
         hBdL0CAWN0rPOd8mVbLYODqPdaD9y+AwJz/nLZ1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 09/21] avoid __memcat_p link failure
Date:   Wed,  5 May 2021 14:04:23 +0200
Message-Id: <20210505112325.030497699@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Makefile
+++ b/lib/Makefile
@@ -31,7 +31,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
-	 nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o
+	 nmi_backtrace.o nodemask.o win_minmax.o
 
 lib-$(CONFIG_PRINTK) += dump_stack.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -46,7 +46,7 @@ obj-y += bcd.o sort.o parser.o debug_loc
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o \
 	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
-	 generic-radix-tree.o
+	 generic-radix-tree.o memcat_p.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o


