Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4314E8A0
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgAaGLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:11:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:13 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E56C21734;
        Fri, 31 Jan 2020 06:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451071;
        bh=ovUcNE7KjRx69AhIB8GS7K8bjkqMIBZAgf+tGSS4wLI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=a0WTdGRnpEjyataqSiO5DVSKfA5enILk3+GKugK6ZmBC34U2n3QunxLBKZragF2c/
         1gQUmtmo9zeZDSANhUGhGk/C22rU7Lvdog7Z6XbrPsxAE3nxKwgAvUs+tzoUwnS9zV
         f5vZ8mPll6Rw1pn/GTVThqnttLDBJZzxjdxoXsos=
Date:   Thu, 30 Jan 2020 22:11:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, cai@lca.pw,
        dan.j.williams@intel.com, david@redhat.com, k-hagio@ab.jp.nec.com,
        kernelfans@gmail.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 004/118] mm/sparse.c: reset section's mem_map when
 fully deactivated
Message-ID: <20200131061110.cRq9S4ls4%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
