Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68BE68CC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfJ0VcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbfJ0VPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:24 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13CAD205C9;
        Sun, 27 Oct 2019 21:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210923;
        bh=r4HFxDYR4Z4juqFTrB3NjZiIWIW0taMejDXfi8NvtIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6EIM5A+fN87/yZsrqmGeXLXEp+s5CuVo4GJpABUS0v4auFJfBGl61nHGIA6vD36d
         bOh9tCrKq9SXVNdWGpBRTwm0xj69bTlwRjNkXMF3yilb5/thZZuuwTaW5eJTbJ/Ws+
         eR/Tz4F6tkuGf6MVcT8qBrvJzYB+h4vYzkk29qjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Qian Cai <cai@lca.pw>, Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>,
        Pankaj gupta <pagupta@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 63/93] fs/proc/page.c: dont access uninitialized memmaps in fs/proc/page.c
Date:   Sun, 27 Oct 2019 22:01:15 +0100
Message-Id: <20191027203306.401002911@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit aad5f69bc161af489dbb5934868bd347282f0764 upstream.

There are three places where we access uninitialized memmaps, namely:
- /proc/kpagecount
- /proc/kpageflags
- /proc/kpagecgroup

We have initialized memmaps either when the section is online or when the
page was initialized to the ZONE_DEVICE.  Uninitialized memmaps contain
garbage and in the worst case trigger kernel BUGs, especially with
CONFIG_PAGE_POISONING.

For example, not onlining a DIMM during boot and calling /proc/kpagecount
with CONFIG_PAGE_POISONING:

  :/# cat /proc/kpagecount > tmp.test
  BUG: unable to handle page fault for address: fffffffffffffffe
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 114616067 P4D 114616067 PUD 114618067 PMD 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 0 PID: 469 Comm: cat Not tainted 5.4.0-rc1-next-20191004+ #11
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.4
  RIP: 0010:kpagecount_read+0xce/0x1e0
  Code: e8 09 83 e0 3f 48 0f a3 02 73 2d 4c 89 e7 48 c1 e7 06 48 03 3d ab 51 01 01 74 1d 48 8b 57 08 480
  RSP: 0018:ffffa14e409b7e78 EFLAGS: 00010202
  RAX: fffffffffffffffe RBX: 0000000000020000 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 00007f76b5595000 RDI: fffff35645000000
  RBP: 00007f76b5595000 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000140000
  R13: 0000000000020000 R14: 00007f76b5595000 R15: ffffa14e409b7f08
  FS:  00007f76b577d580(0000) GS:ffff8f41bd400000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: fffffffffffffffe CR3: 0000000078960000 CR4: 00000000000006f0
  Call Trace:
   proc_reg_read+0x3c/0x60
   vfs_read+0xc5/0x180
   ksys_read+0x68/0xe0
   do_syscall_64+0x5c/0xa0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

For now, let's drop support for ZONE_DEVICE from the three pseudo files
in order to fix this.  To distinguish offline memory (with garbage
memmap) from ZONE_DEVICE memory with properly initialized memmaps, we
would have to check get_dev_pagemap() and pfn_zone_device_reserved()
right now.  The usage of both (especially, special casing devmem) is
frowned upon and needs to be reworked.

The fundamental issue we have is:

	if (pfn_to_online_page(pfn)) {
		/* memmap initialized */
	} else if (pfn_valid(pfn)) {
		/*
		 * ???
		 * a) offline memory. memmap garbage.
		 * b) devmem: memmap initialized to ZONE_DEVICE.
		 * c) devmem: reserved for driver. memmap garbage.
		 * (d) devmem: memmap currently initializing - garbage)
		 */
	}

We'll leave the pfn_zone_device_reserved() check in stable_page_flags()
in place as that function is also used from memory failure.  We now no
longer dump information about pages that are not in use anymore -
offline.

Link: http://lkml.kernel.org/r/20191009142435.3975-2-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc: Pankaj gupta <pagupta@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/page.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -42,10 +42,12 @@ static ssize_t kpagecount_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
+
 		if (!ppage || PageSlab(ppage))
 			pcount = 0;
 		else
@@ -216,10 +218,11 @@ static ssize_t kpageflags_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
 
 		if (put_user(stable_page_flags(ppage), out)) {
 			ret = -EFAULT;
@@ -261,10 +264,11 @@ static ssize_t kpagecgroup_read(struct f
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
 
 		if (ppage)
 			ino = page_cgroup_ino(ppage);


