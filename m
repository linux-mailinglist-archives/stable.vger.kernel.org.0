Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DC9461DC3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378022AbhK2S3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48334 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377980AbhK2S1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04D04CE140D;
        Mon, 29 Nov 2021 18:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64BFC53FAD;
        Mon, 29 Nov 2021 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210215;
        bh=S4ezDgy+Yeef7qB94BkVupSQtGa1w17/LV70dqzfjF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzrKo854OjYARfFxE8ZVlgukelmULdLBWu5P3LwfjBYdw3NQTD+5knMbVXrRE9Tak
         UdE+zlBodCpRcbefI2A9jH3LJAHkDnEXf4FnJ90MJQ8fdPdWjblLPcTEqQEMfj3GGU
         vGxNOyVL5/oVGWXIQIPPAYjdYBoU5L37NueOTlq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        stable@kernel.org
Subject: [PATCH 5.4 12/92] Revert "parisc: Fix backtrace to always include init funtion names"
Date:   Mon, 29 Nov 2021 19:17:41 +0100
Message-Id: <20211129181707.833782456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 98400ad75e95860e9a10ec78b0b90ab66184a2ce upstream.

This reverts commit 279917e27edc293eb645a25428c6ab3f3bca3f86.

With the CONFIG_HARDENED_USERCOPY option enabled, this patch triggers
kernel bugs at runtime:

  usercopy: Kernel memory overwrite attempt detected to kernel text (offset 2084839, size 6)!
  kernel BUG at mm/usercopy.c:99!
 Backtrace:
  IAOQ[0]: usercopy_abort+0xc4/0xe8
  [<00000000406ed1c8>] __check_object_size+0x174/0x238
  [<00000000407086d4>] copy_strings.isra.0+0x3e8/0x708
  [<0000000040709a20>] do_execveat_common.isra.0+0x1bc/0x328
  [<000000004070b760>] compat_sys_execve+0x7c/0xb8
  [<0000000040303eb8>] syscall_exit+0x0/0x14

The problem is, that we have an init section of at least 2MB size which
starts at _stext and is freed after bootup.

If then later some kernel data is (temporarily) stored in this free
memory, check_kernel_text_object() will trigger a bug since the data
appears to be inside the kernel text (>=_stext) area:
        if (overlaps(ptr, len, _stext, _etext))
                usercopy_abort("kernel text");

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@kernel.org # 5.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/vmlinux.lds.S |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -56,8 +56,6 @@ SECTIONS
 {
 	. = KERNEL_BINARY_TEXT_START;
 
-	_stext = .;	/* start of kernel text, includes init code & data */
-
 	__init_begin = .;
 	HEAD_TEXT_SECTION
 	MLONGCALL_DISCARD(INIT_TEXT_SECTION(8))
@@ -81,6 +79,7 @@ SECTIONS
 	/* freed after init ends here */
 
 	_text = .;		/* Text and read-only data */
+	_stext = .;
 	MLONGCALL_KEEP(INIT_TEXT_SECTION(8))
 	.text ALIGN(PAGE_SIZE) : {
 		TEXT_TEXT


