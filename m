Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24A6F76A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfD3Lq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbfD3Lq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA152173E;
        Tue, 30 Apr 2019 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624815;
        bh=FDTVPW8SHiwC8dpz6dmpjUaciFW8vnK86bEFkFWc3bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpsWuZ8eSnNFZhoOuaCqmqCx7eFRdvsZ8KVyKztn0dXJ172DjjSi6JPIRXMsDV37S
         DHGtcWuxLpygCSGGohpZTNhCQF+CFVZjxWyNOAivovDtIyLAxLD1ERqJIu1ECj29M8
         VW3MIj7tPPoN9NYW8dSt+v5nSsL4YIM1rEfHUoR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 082/100] mm: Fix warning in insert_pfn()
Date:   Tue, 30 Apr 2019 13:38:51 +0200
Message-Id: <20190430113612.628743517@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit f2c57d91b0d96aa13ccff4e3b178038f17b00658 upstream.

In DAX mode a write pagefault can race with write(2) in the following
way:

CPU0                            CPU1
                                write fault for mapped zero page (hole)
dax_iomap_rw()
  iomap_apply()
    xfs_file_iomap_begin()
      - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - invalidates radix tree entries in given range
                                dax_iomap_pte_fault()
                                  grab_mapping_entry()
                                    - no entry found, creates empty
                                  ...
                                  xfs_file_iomap_begin()
                                    - finds already allocated block
                                  ...
                                  vmf_insert_mixed_mkwrite()
                                    - WARNs and does nothing because there
                                      is still zero page mapped in PTE
        unmap_mapping_pages()

This race results in WARN_ON from insert_pfn() and is occasionally
triggered by fstest generic/344. Note that the race is otherwise
harmless as before write(2) on CPU0 is finished, we will invalidate page
tables properly and thus user of mmap will see modified data from
write(2) from that point on. So just restrict the warning only to the
case when the PFN in PTE is not zero page.

Link: http://lkml.kernel.org/r/20180824154542.26872-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1787,10 +1787,15 @@ static int insert_pfn(struct vm_area_str
 			 * in may not match the PFN we have mapped if the
 			 * mapped PFN is a writeable COW page.  In the mkwrite
 			 * case we are creating a writable PTE for a shared
-			 * mapping and we expect the PFNs to match.
+			 * mapping and we expect the PFNs to match. If they
+			 * don't match, we are likely racing with block
+			 * allocation and mapping invalidation so just skip the
+			 * update.
 			 */
-			if (WARN_ON_ONCE(pte_pfn(*pte) != pfn_t_to_pfn(pfn)))
+			if (pte_pfn(*pte) != pfn_t_to_pfn(pfn)) {
+				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(*pte)));
 				goto out_unlock;
+			}
 			entry = *pte;
 			goto out_mkwrite;
 		} else


