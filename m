Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0036AE14
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhDZHlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233522AbhDZHjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18F3613FF;
        Mon, 26 Apr 2021 07:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422667;
        bh=qixa/5YC4c3Tqrt2gAFjU5cfJyOp92exDOtAOGwOOFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z51c7T6MxZpHznAdUUev600FHpVBAeW5U0lAkPrSC1XHSXVmjQIJOvGqsXxVKlyM4
         wBXMaOc+djED1d+HE2r9wffwYuqo5q1/iEB/YQsaUfTpdNIchFdwMu2afuYwVUVnrX
         vhANFzzh5IuxbNogJuwYAiiGIJCPzkW0ek+53dh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>
Subject: [PATCH 4.19 57/57] x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access
Date:   Mon, 26 Apr 2021 09:29:54 +0200
Message-Id: <20210426072822.515568333@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

commit 5849cdf8c120e3979c57d34be55b92d90a77a47e upstream.

Commit in Fixes: added support for kexec-ing a kernel on panic using a
new system call. As part of it, it does prepare a memory map for the new
kernel.

However, while doing so, it wrongly accesses memory it has not
allocated: it accesses the first element of the cmem->ranges[] array in
memmap_exclude_ranges() but it has not allocated the memory for it in
crash_setup_memmap_entries(). As KASAN reports:

  BUG: KASAN: vmalloc-out-of-bounds in crash_setup_memmap_entries+0x17e/0x3a0
  Write of size 8 at addr ffffc90000426008 by task kexec/1187

  (gdb) list *crash_setup_memmap_entries+0x17e
  0xffffffff8107cafe is in crash_setup_memmap_entries (arch/x86/kernel/crash.c:322).
  317                                      unsigned long long mend)
  318     {
  319             unsigned long start, end;
  320
  321             cmem->ranges[0].start = mstart;
  322             cmem->ranges[0].end = mend;
  323             cmem->nr_ranges = 1;
  324
  325             /* Exclude elf header region */
  326             start = image->arch.elf_load_addr;
  (gdb)

Make sure the ranges array becomes a single element allocated.

 [ bp: Write a proper commit message. ]

Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/725fa3dc1da2737f0f6188a1a9701bead257ea9d.camel@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -356,7 +356,7 @@ int crash_setup_memmap_entries(struct ki
 	struct crash_memmap_data cmd;
 	struct crash_mem *cmem;
 
-	cmem = vzalloc(sizeof(struct crash_mem));
+	cmem = vzalloc(struct_size(cmem, ranges, 1));
 	if (!cmem)
 		return -ENOMEM;
 


