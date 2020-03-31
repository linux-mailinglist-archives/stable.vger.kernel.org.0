Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9372F19915F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgCaJQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbgCaJQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D742072E;
        Tue, 31 Mar 2020 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646184;
        bh=rKdoUIalX+QoPh7TMy6wFd/Kw88at2WzRdyb7dObhfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fo8norwDqz2XqhKnb84VXu6qp70xk71DRQHbLDlt+eRBot9vRj20WVoFrggVFwj/b
         tihjbWAclGe6Tb9Q7l8V150h+AOPWCyJGZ8dhAju9udkwDXmh3k9HMBf9YkxzTkECn
         jHYSYCEitPos0lk8DQgPl+ZcKZiofvhmyLGPgrXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <bhe@redhat.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 102/155] mm/sparse: fix kernel crash with pfn_section_valid check
Date:   Tue, 31 Mar 2020 10:59:02 +0200
Message-Id: <20200331085429.945611537@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit b943f045a9af9fd02f923e43fe8d7517e9961701 upstream.

Fix the crash like this:

    BUG: Kernel NULL pointer dereference on read at 0x00000000
    Faulting instruction address: 0xc000000000c3447c
    Oops: Kernel access of bad area, sig: 11 [#1]
    LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
    CPU: 11 PID: 7519 Comm: lt-ndctl Not tainted 5.6.0-rc7-autotest #1
    ...
    NIP [c000000000c3447c] vmemmap_populated+0x98/0xc0
    LR [c000000000088354] vmemmap_free+0x144/0x320
    Call Trace:
       section_deactivate+0x220/0x240
       __remove_pages+0x118/0x170
       arch_remove_memory+0x3c/0x150
       memunmap_pages+0x1cc/0x2f0
       devm_action_release+0x30/0x50
       release_nodes+0x2f8/0x3e0
       device_release_driver_internal+0x168/0x270
       unbind_store+0x130/0x170
       drv_attr_store+0x44/0x60
       sysfs_kf_write+0x68/0x80
       kernfs_fop_write+0x100/0x290
       __vfs_write+0x3c/0x70
       vfs_write+0xcc/0x240
       ksys_write+0x7c/0x140
       system_call+0x5c/0x68

The crash is due to NULL dereference at

	test_bit(idx, ms->usage->subsection_map);

due to ms->usage = NULL in pfn_section_valid()

With commit d41e2f3bd546 ("mm/hotplug: fix hot remove failure in
SPARSEMEM|!VMEMMAP case") section_mem_map is set to NULL after
depopulate_section_mem().  This was done so that pfn_page() can work
correctly with kernel config that disables SPARSEMEM_VMEMMAP.  With that
config pfn_to_page does

	__section_mem_map_addr(__sec) + __pfn;

where

  static inline struct page *__section_mem_map_addr(struct mem_section *section)
  {
	unsigned long map = section->section_mem_map;
	map &= SECTION_MAP_MASK;
	return (struct page *)map;
  }

Now with SPASEMEM_VMEMAP enabled, mem_section->usage->subsection_map is
used to check the pfn validity (pfn_valid()).  Since section_deactivate
release mem_section->usage if a section is fully deactivated,
pfn_valid() check after a subsection_deactivate cause a kernel crash.

  static inline int pfn_valid(unsigned long pfn)
  {
  ...
	return early_section(ms) || pfn_section_valid(ms, pfn);
  }

where

  static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
  {
	int idx = subsection_map_index(pfn);

	return test_bit(idx, ms->usage->subsection_map);
  }

Avoid this by clearing SECTION_HAS_MEM_MAP when mem_section->usage is
freed.  For architectures like ppc64 where large pages are used for
vmmemap mapping (16MB), a specific vmemmap mapping can cover multiple
sections.  Hence before a vmemmap mapping page can be freed, the kernel
needs to make sure there are no valid sections within that mapping.
Clearing the section valid bit before depopulate_section_memap enables
this.

[aneesh.kumar@linux.ibm.com: add comment]
  Link: http://lkml.kernel.org/r/20200326133235.343616-1-aneesh.kumar@linux.ibm.comLink: http://lkml.kernel.org/r/20200325031914.107660-1-aneesh.kumar@linux.ibm.com
Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/sparse.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -789,6 +789,12 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
 	if (section_is_early && memmap)


