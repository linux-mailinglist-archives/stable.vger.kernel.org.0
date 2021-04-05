Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7375353CDD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhDEI5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhDEI5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0228610E8;
        Mon,  5 Apr 2021 08:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613020;
        bh=lrID+42SZ9lI6g9WHxs5WnSEGWArFPOzvZw7wCm85bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSeo8GSLXswfUym2tBHg3+IsUq+qqiTBrWQI4HXFPOcmRbvQwJS2CmHk3T5RUDk46
         fL26GBYLHscSOSZrTNo8e8SszqAHwGBGYumeMuv35xAt7hEscAnoGgAcmVXZc3KqH2
         t4cgHo6QOc9pKHjDOlkPTnqCtpFYNCU/hOh57K10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 22/35] mm: fix race by making init_zero_pfn() early_initcall
Date:   Mon,  5 Apr 2021 10:53:57 +0200
Message-Id: <20210405085019.580637824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

commit e720e7d0e983bf05de80b231bccc39f1487f0f16 upstream.

There are code paths that rely on zero_pfn to be fully initialized
before core_initcall.  For example, wq_sysfs_init() is a core_initcall
function that eventually results in a call to kernel_execve, which
causes a page fault with a subsequent mmput.  If zero_pfn is not
initialized by then it may not get cleaned up properly and result in an
error:

  BUG: Bad rss-counter state mm:(ptrval) type:MM_ANONPAGES val:1

Here is an analysis of the race as seen on a MIPS device. On this
particular MT7621 device (Ubiquiti ER-X), zero_pfn is PFN 0 until
initialized, at which point it becomes PFN 5120:

  1. wq_sysfs_init calls into kobject_uevent_env at core_initcall:
       kobject_uevent_env+0x7e4/0x7ec
       kset_register+0x68/0x88
       bus_register+0xdc/0x34c
       subsys_virtual_register+0x34/0x78
       wq_sysfs_init+0x1c/0x4c
       do_one_initcall+0x50/0x1a8
       kernel_init_freeable+0x230/0x2c8
       kernel_init+0x10/0x100
       ret_from_kernel_thread+0x14/0x1c

  2. kobject_uevent_env() calls call_usermodehelper_exec() which executes
     kernel_execve asynchronously.

  3. Memory allocations in kernel_execve cause a page fault, bumping the
     MM reference counter:
       add_mm_counter_fast+0xb4/0xc0
       handle_mm_fault+0x6e4/0xea0
       __get_user_pages.part.78+0x190/0x37c
       __get_user_pages_remote+0x128/0x360
       get_arg_page+0x34/0xa0
       copy_string_kernel+0x194/0x2a4
       kernel_execve+0x11c/0x298
       call_usermodehelper_exec_async+0x114/0x194

  4. In case zero_pfn has not been initialized yet, zap_pte_range does
     not decrement the MM_ANONPAGES RSS counter and the BUG message is
     triggered shortly afterwards when __mmdrop checks the ref counters:
       __mmdrop+0x98/0x1d0
       free_bprm+0x44/0x118
       kernel_execve+0x160/0x1d8
       call_usermodehelper_exec_async+0x114/0x194
       ret_from_kernel_thread+0x14/0x1c

To avoid races such as described above, initialize init_zero_pfn at
early_initcall level.  Depending on the architecture, ZERO_PAGE is
either constant or gets initialized even earlier, at paging_init, so
there is no issue with initializing zero_pfn earlier.

Link: https://lkml.kernel.org/r/CALCv0x2YqOXEAy2Q=hafjhHCtTHVodChv1qpM=niAXOpqEbt7w@mail.gmail.com
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: stable@vger.kernel.org
Tested-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -132,7 +132,7 @@ static int __init init_zero_pfn(void)
 	zero_pfn = page_to_pfn(ZERO_PAGE(0));
 	return 0;
 }
-core_initcall(init_zero_pfn);
+early_initcall(init_zero_pfn);
 
 
 #if defined(SPLIT_RSS_COUNTING)


