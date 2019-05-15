Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0051EE9E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbfEOLXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbfEOLXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A9420862;
        Wed, 15 May 2019 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919419;
        bh=judf+XwGOFgEc1K8XR07gJwpkpBZHL9DDk/Stit+E5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdqAtKzTO0NCx3fkQNUEXW4R7n3EoB80XOBwRmFhtlpb2czuyNvi9ExJyhZuzLQjO
         Z951yYW9EYF0wTCF+IWsDrtFwdLWiSN4AcibilQHTqCfC/crRQ2wrTg3HMBHx94/Uc
         MnAS01PcckLeEd2rO+Mx5MfBwNRA079K8pvVvjDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 068/113] mm/memory.c: fix modifying of page protection by insert_pfn()
Date:   Wed, 15 May 2019 12:55:59 +0200
Message-Id: <20190515090658.700487167@linuxfoundation.org>
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

[ Upstream commit cae85cb8add35f678cf487139d05e083ce2f570a ]

Aneesh has reported that PPC triggers the following warning when
excercising DAX code:

  IP set_pte_at+0x3c/0x190
  LR insert_pfn+0x208/0x280
  Call Trace:
     insert_pfn+0x68/0x280
     dax_iomap_pte_fault.isra.7+0x734/0xa40
     __xfs_filemap_fault+0x280/0x2d0
     do_wp_page+0x48c/0xa40
     __handle_mm_fault+0x8d0/0x1fd0
     handle_mm_fault+0x140/0x250
     __do_page_fault+0x300/0xd60
     handle_page_fault+0x18

Now that is WARN_ON in set_pte_at which is

        VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));

The problem is that on some architectures set_pte_at() cannot cope with
a situation where there is already some (different) valid entry present.

Use ptep_set_access_flags() instead to modify the pfn which is built to
deal with modifying existing PTE.

Link: http://lkml.kernel.org/r/20190311084537.16029-1-jack@suse.cz
Fixes: b2770da64254 "mm: add vm_insert_mixed_mkwrite()"
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Chandan Rajendra <chandan@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 mm/memory.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9c69278173b78..e0010cb870e05 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1796,10 +1796,12 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(*pte)));
 				goto out_unlock;
 			}
-			entry = *pte;
-			goto out_mkwrite;
-		} else
-			goto out_unlock;
+			entry = pte_mkyoung(*pte);
+			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
+				update_mmu_cache(vma, addr, pte);
+		}
+		goto out_unlock;
 	}
 
 	/* Ok, finally just insert the thing.. */
@@ -1808,7 +1810,6 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	else
 		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
 
-out_mkwrite:
 	if (mkwrite) {
 		entry = pte_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-- 
2.20.1



