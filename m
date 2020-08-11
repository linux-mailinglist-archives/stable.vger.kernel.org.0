Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60FD2415D8
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 06:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHKErV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 00:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgHKErU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 00:47:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9BA420678;
        Tue, 11 Aug 2020 04:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597121239;
        bh=ikuSH+1oUEZvKdtoHqz34iMQ+sH8q0+imzl5I6D/kO0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YBqnizdi32T3RnrsEHkPkmo5rdbIxHt/CFn5hsfarBYsWq6UwJTLQoOyimDpCOaBt
         zL5eiaZ9xCZ4xZwHw9/1ONjE1GiGmlDI5SbHaZUSsGwDDy5M2NFVyKY6ZQFdZbf9yw
         GkKyWV5JFarII7hC7ksi/tUZUZ8PHcYKpXtnAvac=
Date:   Mon, 10 Aug 2020 21:47:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, harish@linux.ibm.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  + mm-vunmap-add-cond_resched-in-vunmap_pmd_range.patch
 added to -mm tree
Message-ID: <20200811044719.nX8eEIgxm%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vunmap: add cond_resched() in vunmap_pmd_range
has been added to the -mm tree.  Its filename is
     mm-vunmap-add-cond_resched-in-vunmap_pmd_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vunmap-add-cond_resched-in-vunmap_pmd_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vunmap-add-cond_resched-in-vunmap_pmd_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/vunmap: add cond_resched() in vunmap_pmd_range

Like zap_pte_range add cond_resched so that we can avoid softlockups as
reported below.  On non-preemptible kernel with large I/O map region (like
the one we get when using persistent memory with sector mode), an unmap of
the namespace can report below softlockups.

22724.027334] watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
 NIP [c0000000000dc224] plpar_hcall+0x38/0x58
 LR [c0000000000d8898] pSeries_lpar_hpte_invalidate+0x68/0xb0
 Call Trace:
 [c0000004e87a7780] [c0000004fb197c00] 0xc0000004fb197c00 (unreliable)
 [c0000004e87a7810] [c00000000007f4e4] flush_hash_page+0x114/0x200
 [c0000004e87a7890] [c0000000000833cc] hpte_need_flush+0x2dc/0x540
 [c0000004e87a7950] [c0000000003f5798] vunmap_page_range+0x538/0x6f0
 [c0000004e87a7a70] [c0000000003f76d0] free_unmap_vmap_area+0x30/0x70
 [c0000004e87a7aa0] [c0000000003f7a6c] remove_vm_area+0xfc/0x140
 [c0000004e87a7ad0] [c0000000003f7dd8] __vunmap+0x68/0x270
 [c0000004e87a7b50] [c000000000079de4] __iounmap.part.0+0x34/0x60
 [c0000004e87a7bb0] [c000000000376394] memunmap+0x54/0x70
 [c0000004e87a7bd0] [c000000000881d7c] release_nodes+0x28c/0x300
 [c0000004e87a7c40] [c00000000087a65c] device_release_driver_internal+0x16c/0x280
 [c0000004e87a7c80] [c000000000876fc4] unbind_store+0x124/0x170
 [c0000004e87a7cd0] [c000000000875be4] drv_attr_store+0x44/0x60
 [c0000004e87a7cf0] [c00000000057c734] sysfs_kf_write+0x64/0x90
 [c0000004e87a7d10] [c00000000057bc10] kernfs_fop_write+0x1b0/0x290
 [c0000004e87a7d60] [c000000000488e6c] __vfs_write+0x3c/0x70
 [c0000004e87a7d80] [c00000000048c868] vfs_write+0xd8/0x260
 [c0000004e87a7dd0] [c00000000048ccac] ksys_write+0xdc/0x130
 [c0000004e87a7e20] [c00000000000b588] system_call+0x5c/0x70

Link: http://lkml.kernel.org/r/20200807075933.310240-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Harish Sriram <harish@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c~mm-vunmap-add-cond_resched-in-vunmap_pmd_range
+++ a/mm/vmalloc.c
@@ -104,6 +104,8 @@ static void vunmap_pmd_range(pud_t *pud,
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
+
+		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-vunmap-add-cond_resched-in-vunmap_pmd_range.patch

