Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC31F0BA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbfEOLYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731581AbfEOLYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962B820881;
        Wed, 15 May 2019 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919475;
        bh=d3ef7RyfQsGRZZoP7etmQe0Icj/gxAzMxz//dK0W8Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWPUkFLEu4Tmu6xushg0BLpKOK0KFxmvimig+B8LZGAd5jDpC+WSj507/RWqoflLB
         kvvsLkOMaub/5SkZPO/RT9oqIy974uccQSTxO2SNU3yV+pwT9dgpTn//eCmaJsNMaF
         tgrkPZB8xS6Qgc8sVzMkuo9CcuksRmPVGfE6sRmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/113] init: initialize jump labels before command line option parsing
Date:   Wed, 15 May 2019 12:55:36 +0200
Message-Id: <20190515090657.054813188@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6041186a32585fc7a1d0f6cfe2f138b05fdc3c82 ]

When a module option, or core kernel argument, toggles a static-key it
requires jump labels to be initialized early.  While x86, PowerPC, and
ARM64 arrange for jump_label_init() to be called before parse_args(),
ARM does not.

  Kernel command line: rdinit=/sbin/init page_alloc.shuffle=1 panic=-1 console=ttyAMA0,115200 page_alloc.shuffle=1
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at ./include/linux/jump_label.h:303
  page_alloc_shuffle+0x12c/0x1ac
  static_key_enable(): static key 'page_alloc_shuffle_key+0x0/0x4' used
  before call to jump_label_init()
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted
  5.1.0-rc4-next-20190410-00003-g3367c36ce744 #1
  Hardware name: ARM Integrator/CP (Device Tree)
  [<c0011c68>] (unwind_backtrace) from [<c000ec48>] (show_stack+0x10/0x18)
  [<c000ec48>] (show_stack) from [<c07e9710>] (dump_stack+0x18/0x24)
  [<c07e9710>] (dump_stack) from [<c001bb1c>] (__warn+0xe0/0x108)
  [<c001bb1c>] (__warn) from [<c001bb88>] (warn_slowpath_fmt+0x44/0x6c)
  [<c001bb88>] (warn_slowpath_fmt) from [<c0b0c4a8>]
  (page_alloc_shuffle+0x12c/0x1ac)
  [<c0b0c4a8>] (page_alloc_shuffle) from [<c0b0c550>] (shuffle_store+0x28/0x48)
  [<c0b0c550>] (shuffle_store) from [<c003e6a0>] (parse_args+0x1f4/0x350)
  [<c003e6a0>] (parse_args) from [<c0ac3c00>] (start_kernel+0x1c0/0x488)

Move the fallback call to jump_label_init() to occur before
parse_args().

The redundant calls to jump_label_init() in other archs are left intact
in case they have static key toggling use cases that are even earlier
than option parsing.

Link: http://lkml.kernel.org/r/155544804466.1032396.13418949511615676665.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Guenter Roeck <groeck@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Russell King <rmk@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index e083fac08aedc..020972fed1171 100644
--- a/init/main.c
+++ b/init/main.c
@@ -568,6 +568,8 @@ asmlinkage __visible void __init start_kernel(void)
 	page_alloc_init();
 
 	pr_notice("Kernel command line: %s\n", boot_command_line);
+	/* parameters may set static keys */
+	jump_label_init();
 	parse_early_param();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
@@ -577,8 +579,6 @@ asmlinkage __visible void __init start_kernel(void)
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   NULL, set_init_arg);
 
-	jump_label_init();
-
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
-- 
2.20.1



