Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AAC47FFBB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbhL0PlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41730 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbhL0PjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52D99CE10B3;
        Mon, 27 Dec 2021 15:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AD4C36AEA;
        Mon, 27 Dec 2021 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619537;
        bh=4aGYp76oxLP85iqStjeg7AsePlkUOuGTEnq5fvGC0EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7n1FNHhu2sDU5qt4N4CYDRxntAyHFg0Ts15NogT/XoX45l40ufCa8hEuxL8m4qA7
         3TKlkRQj+ER+8P6pAKX7urDmUzGca/WfUhKZhq1qwyqf9robTt3O5PTqg8E6F64O42
         a87+hVqq8V9Bv2zgSynn5h2e/EzPe2kjyx/ZaIzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Shixin <liushixin2@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 58/76] mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()
Date:   Mon, 27 Dec 2021 16:31:13 +0100
Message-Id: <20211227151326.710303327@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

commit 2a57d83c78f889bf3f54eede908d0643c40d5418 upstream.

Hulk Robot reported a panic in put_page_testzero() when testing
madvise() with MADV_SOFT_OFFLINE.  The BUG() is triggered when retrying
get_any_page().  This is because we keep MF_COUNT_INCREASED flag in
second try but the refcnt is not increased.

    page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
    ------------[ cut here ]------------
    kernel BUG at include/linux/mm.h:737!
    invalid opcode: 0000 [#1] PREEMPT SMP
    CPU: 5 PID: 2135 Comm: sshd Tainted: G    B             5.16.0-rc6-dirty #373
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
    RIP: release_pages+0x53f/0x840
    Call Trace:
      free_pages_and_swap_cache+0x64/0x80
      tlb_flush_mmu+0x6f/0x220
      unmap_page_range+0xe6c/0x12c0
      unmap_single_vma+0x90/0x170
      unmap_vmas+0xc4/0x180
      exit_mmap+0xde/0x3a0
      mmput+0xa3/0x250
      do_exit+0x564/0x1470
      do_group_exit+0x3b/0x100
      __do_sys_exit_group+0x13/0x20
      __x64_sys_exit_group+0x16/0x20
      do_syscall_64+0x34/0x80
      entry_SYSCALL_64_after_hwframe+0x44/0xae
    Modules linked in:
    ---[ end trace e99579b570fe0649 ]---
    RIP: 0010:release_pages+0x53f/0x840

Link: https://lkml.kernel.org/r/20211221074908.3910286-1-liushixin2@huawei.com
Fixes: b94e02822deb ("mm,hwpoison: try to narrow window race for free pages")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1938,6 +1938,7 @@ retry:
 	else if (ret == 0)
 		if (soft_offline_free_page(page) && try_again) {
 			try_again = false;
+			flags &= ~MF_COUNT_INCREASED;
 			goto retry;
 		}
 


