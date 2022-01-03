Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87638483391
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiACOiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiACOhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:37:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D989DC08EAE7;
        Mon,  3 Jan 2022 06:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B521B80F03;
        Mon,  3 Jan 2022 14:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE1C36AED;
        Mon,  3 Jan 2022 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220422;
        bh=1KvGh60lDhcA4kbDfuWfBr+rep1l1ZuJNo75NxUDFYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQzwPSBN8bXInX+NotBZ2nbNq9WfrRmwgAp5IpAJZ9rBzFVWkCwQPB1j+pnfLtVJd
         wkOnnsyfUDANyWMfSkNHJYLRangLuhQxNIOKruRXISe19+Ej4Do/yeYdmcOwg6bkVC
         y4jdB/in23jRNCmJYFMHRbMYtMUdkMlMEQwvNJdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH 5.15 63/73] nitro_enclaves: Use get_user_pages_unlocked() call to handle mmap assert
Date:   Mon,  3 Jan 2022 15:24:24 +0100
Message-Id: <20220103142058.962710236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andra Paraschiv <andraprs@amazon.com>

commit 3a0152b219523227c2a62a0a122cf99608287176 upstream.

After commit 5b78ed24e8ec ("mm/pagemap: add mmap_assert_locked()
annotations to find_vma*()"), the call to get_user_pages() will trigger
the mmap assert.

static inline void mmap_assert_locked(struct mm_struct *mm)
{
	lockdep_assert_held(&mm->mmap_lock);
	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
}

[   62.521410] kernel BUG at include/linux/mmap_lock.h:156!
...........................................................
[   62.538938] RIP: 0010:find_vma+0x32/0x80
...........................................................
[   62.605889] Call Trace:
[   62.608502]  <TASK>
[   62.610956]  ? lock_timer_base+0x61/0x80
[   62.614106]  find_extend_vma+0x19/0x80
[   62.617195]  __get_user_pages+0x9b/0x6a0
[   62.620356]  __gup_longterm_locked+0x42d/0x450
[   62.623721]  ? finish_wait+0x41/0x80
[   62.626748]  ? __kmalloc+0x178/0x2f0
[   62.629768]  ne_set_user_memory_region_ioctl.isra.0+0x225/0x6a0 [nitro_enclaves]
[   62.635776]  ne_enclave_ioctl+0x1cf/0x6d7 [nitro_enclaves]
[   62.639541]  __x64_sys_ioctl+0x82/0xb0
[   62.642620]  do_syscall_64+0x3b/0x90
[   62.645642]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Use get_user_pages_unlocked() when setting the enclave memory regions.
That's a similar pattern as mmap_read_lock() used together with
get_user_pages().

Fixes: 5b78ed24e8ec ("mm/pagemap: add mmap_assert_locked() annotations to find_vma*()")
Cc: stable@vger.kernel.org
Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
Link: https://lore.kernel.org/r/20211220195856.6549-1-andraprs@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -886,8 +886,9 @@ static int ne_set_user_memory_region_ioc
 			goto put_pages;
 		}
 
-		gup_rc = get_user_pages(mem_region.userspace_addr + memory_size, 1, FOLL_GET,
-					ne_mem_region->pages + i, NULL);
+		gup_rc = get_user_pages_unlocked(mem_region.userspace_addr + memory_size, 1,
+						 ne_mem_region->pages + i, FOLL_GET);
+
 		if (gup_rc < 0) {
 			rc = gup_rc;
 


