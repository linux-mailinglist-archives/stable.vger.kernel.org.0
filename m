Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16E7F438A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbfKHJi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39778 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731477AbfKHJi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B6A7AEAF;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
        Juergen Gross <jgross@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH STABLE 4.4 0/8] page refcount overflow backports
Date:   Fri,  8 Nov 2019 10:38:06 +0100
Message-Id: <20191108093814.16032-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this series backports the CVE-2019-11487 fixes (page refcount overflow) to
4.4 stable. It differs from Ajay's series [1] in the following:

- gup.c variants of fast gup for x86 and s390 are fixed too. I've not fixed
  sparc, mips, sh. It's unlikely the known overflow scenario based on FUSE,
  which needs 140GB of RAM, is a problem for those architectures, and I don't
  feel confident enough to patch them. I've sent the same fixup for 4.9 [3]
- there are some differences in backport adaptations, hopefully not important.
  My version is taken from our 4.4 based kernel, which was just simpler for me
  than adding the missing parts to Ajay's version
- The last patch fixes another problem in the fast gup implementation on x86,
  that I've previously posted and got merged to 4.9 stable [2].

[1] https://lore.kernel.org/linux-mm/1570581863-12090-1-git-send-email-akaher@vmware.com/
[2] https://lore.kernel.org/linux-mm/20190802160614.8089-1-vbabka@suse.cz/
[3] https://lore.kernel.org/linux-mm/9c130fa4-e52d-f8bd-c450-42341c7ab441@suse.cz/

Linus Torvalds (3):
  mm: make page ref count overflow check tighter and more explicit
  mm: add 'try_get_page()' helper function
  mm: prevent get_user_pages() from overflowing page refcount

Matthew Wilcox (1):
  fs: prevent page refcount overflow in pipe_buf_get

Miklos Szeredi (1):
  pipe: add pipe_buf_get() helper

Punit Agrawal (1):
  mm, gup: ensure real head page is ref-counted when using hugepages

Vlastimil Babka (1):
  x86, mm, gup: prevent get_page() race with munmap in paravirt guest

Will Deacon (1):
  mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

 arch/s390/mm/gup.c        |  6 +++--
 arch/x86/mm/gup.c         | 23 ++++++++++++++++++-
 fs/fuse/dev.c             | 12 +++++-----
 fs/pipe.c                 |  4 ++--
 fs/splice.c               | 12 ++++++++--
 include/linux/mm.h        | 26 ++++++++++++++++++++-
 include/linux/pipe_fs_i.h | 17 ++++++++++++--
 kernel/trace/trace.c      |  6 ++++-
 mm/gup.c                  | 48 +++++++++++++++++++++++++++------------
 mm/huge_memory.c          |  2 +-
 mm/hugetlb.c              | 18 +++++++++++++--
 mm/internal.h             | 17 ++++++++++----
 12 files changed, 152 insertions(+), 39 deletions(-)

-- 
2.23.0

