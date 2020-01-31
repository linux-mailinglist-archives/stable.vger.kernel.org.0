Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85FB14F521
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 00:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAaXQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 18:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:37 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840DC2082E;
        Fri, 31 Jan 2020 23:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580512596;
        bh=aip+IVa9JFGc4KMpGa8bYmbL/3hwj22Ka9DCvJM60Bg=;
        h=Date:From:To:Subject:From;
        b=e2Gq/xpE+iuL+rt/tXvPOqhryXnSbCuNoACK9in/OnIEfgruG3/2Cx/laHJCrMx8K
         WZKiWCJJvGoyxYbcIS79++P3m77AxxK45yrFTVFYeLN5iStCRzj1O84zIP5RknVVSH
         bjqCg8bJoDbosNXKIpEjLUTuSqx7Y2GjfmjSpDNg=
Date:   Fri, 31 Jan 2020 15:16:36 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, k-hagio@ab.jp.nec.com, kernelfans@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org
Subject:  [merged]
 mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch removed from
 -mm tree
Message-ID: <20200131231636.ZiyrAazak%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/sparse.c: reset section's mem_map when fully deactivated
has been removed from the -mm tree.  Its filename was
     mm-sparse-reset-sections-mem_map-when-fully-deactivated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: mm/sparse.c: reset section's mem_map when fully deactivated

After commit ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug"),
when a mem section is fully deactivated, section_mem_map still records the
section's start pfn, which is not used any more and will be reassigned
during re-addition.

In analogy with alloc/free pattern, it is better to clear all fields of
section_mem_map.

Beside this, it breaks the user space tool "makedumpfile" [1], which makes
assumption that a hot-removed section has mem_map as NULL, instead of
checking directly against SECTION_MARKED_PRESENT bit.  (makedumpfile will
be better to change the assumption, and need a patch)

The bug can be reproduced on IBM POWERVM by "drmgr -c mem -r -q 5" ,
trigger a crash, and save vmcore by makedumpfile

[1]: makedumpfile, commit e73016540293 ("[v1.6.7] Update version")

Link: http://lkml.kernel.org/r/1579487594-28889-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Kazuhito Hagio <k-hagio@ab.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-reset-sections-mem_map-when-fully-deactivated
+++ a/mm/sparse.c
@@ -789,7 +789,7 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		ms->section_mem_map = sparse_encode_mem_map(NULL, section_nr);
+		ms->section_mem_map = (unsigned long)NULL;
 	}
 
 	if (section_is_early && memmap)
_

Patches currently in -mm which might be from kernelfans@gmail.com are


