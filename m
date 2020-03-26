Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5425F1947A0
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 20:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgCZTlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 15:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZTlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 15:41:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10B920714;
        Thu, 26 Mar 2020 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585251691;
        bh=U+Uxe9tg5VbT5SpNTyYSwRVDAJlFDRiWUCFA66Hf2qs=;
        h=Date:From:To:Subject:From;
        b=TVpxeHca6g2IFqozFUbEEoSr0FiogoXvY1u2sUP74OlCka09jnOVlgeAUUIYcmxFc
         M4IjtIXnG1Di07XjB1Nq4cJ1rEAOOAxXkaFo76dnG248mhkqfkAHvkIXhf07ItW/th
         p1Ou62bLIQicV4u3eaBLfUTt8C6ZJvdj1QWKVaIQ=
Date:   Thu, 26 Mar 2020 12:41:30 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bhe@redhat.com,
        dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richardw.yang@linux.intel.com,
        rppt@linux.ibm.com, sachinp@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject:  +
 mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch added to
 -mm tree
Message-ID: <20200326194130.KQt2jbeWd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
has been added to the -mm tree.  Its filename is
     mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

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
Subject: mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2

add comment

Link: http://lkml.kernel.org/r/20200326133235.343616-1-aneesh.kumar@linux.ibm.com
Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2
+++ a/mm/sparse.c
@@ -781,7 +781,11 @@ static void section_deactivate(unsigned
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		/* Mark the section invalid */
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
 		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-sparse-fix-kernel-crash-with-pfn_section_valid-check.patch
mm-sparse-fix-kernel-crash-with-pfn_section_valid-check-v2.patch

