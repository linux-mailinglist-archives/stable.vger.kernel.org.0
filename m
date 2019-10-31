Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE754EA9F2
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 05:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfJaEmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 00:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfJaEma (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 00:42:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C3C20862;
        Thu, 31 Oct 2019 04:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572496950;
        bh=H/SOUamg33M6zHpAMCdLNDJj9eTJC66TFz9y6Bq20rQ=;
        h=Date:From:To:Subject:From;
        b=J2ZH/cYOluwwkKpJMenLeGCpAxqY4xtqbeqiPbZXec9ZU+xCrf3740bRHzeco5o7h
         TC/bTXSBfRWAF3lOeuhVmaLqbM1gvdkKLVpBLgnB16rGLBvyUARkgXdw8eC+JaT7oZ
         oHIW3KwOFVL9QmPoOfTRqBu4AXoz2i+dcJeFCQZM=
Date:   Wed, 30 Oct 2019 21:42:29 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com,
        stable@vger.kernel.org, vincent.whitchurch@axis.com
Subject:  + mm-sparse-consistently-do-not-zero-memmap.patch added
 to -mm tree
Message-ID: <20191031044229.FntU02eez%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/sparse: consistently do not zero memmap
has been added to the -mm tree.  Its filename is
     mm-sparse-consistently-do-not-zero-memmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-consistently-do-not-zero-memmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-consistently-do-not-zero-memmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: mm/sparse: consistently do not zero memmap

sparsemem without VMEMMAP has two allocation paths to allocate the memory
needed for its memmap (done in sparse_mem_map_populate()).

In one allocation path (sparse_buffer_alloc() succeeds), the memory is not
zeroed (since it was previously allocated with
memblock_alloc_try_nid_raw()).

In the other allocation path (sparse_buffer_alloc() fails and
sparse_mem_map_populate() falls back to memblock_alloc_try_nid()), the
memory is zeroed.

AFAICS this difference does not appear to be on purpose.  If the code is
supposed to work with non-initialized memory (__init_single_page() takes
care of zeroing the struct pages which are actually used), we should
consistently not zero the memory, to avoid masking bugs.

(I noticed this because on my ARM64 platform, with 1 GiB of memory the
 first [and only] section is allocated from the zeroing path while with
 2 GiB of memory the first 1 GiB section is allocated from the
 non-zeroing path.)

Link: http://lkml.kernel.org/r/20191030131122.8256-1-vincent.whitchurch@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-consistently-do-not-zero-memmap
+++ a/mm/sparse.c
@@ -458,7 +458,7 @@ struct page __init *__populate_section_m
 	if (map)
 		return map;
 
-	map = memblock_alloc_try_nid(size,
+	map = memblock_alloc_try_nid_raw(size,
 					  PAGE_SIZE, addr,
 					  MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 	if (!map)
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

mm-sparse-consistently-do-not-zero-memmap.patch

