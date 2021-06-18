Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C033AD162
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 19:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhFRRoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 13:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhFRRoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 13:44:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBCBC061574;
        Fri, 18 Jun 2021 10:42:45 -0700 (PDT)
Date:   Fri, 18 Jun 2021 17:42:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624038163;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4T6r4OFbKcFYZScWGv36zptdxpcLrCD12HgvKArkW0=;
        b=Vbk2whrVEWRzOaBsDa1SRsBK7OamJQ8mv5uqqWjypR9RDo3dHD/o9LRWo6iHNfoqTADaIY
        W3ZjgN+0VOgI+ivvb/52RJadYfWq8DhKPKKT6C6Aa1lvy3nuXE1Oqro/QSW4La4BKFSxCz
        mP9aqf/FJZynNSpnFaO7u8PNsE++MJZd0kDZag3bRIwdJoeEGYpsv8C3uL7HKy/fmuZ/bD
        b8oNE9JoOosE7cDqFHWRP6HWBGkWkJI5o1zLofiFRaafo/IhZaxb/mDy9TJ5MuNqhKUnhr
        56fyhN6sh5m8aqTGXxSZR+x1YvfV9VcDj1l6nIPiJyRd8nWKtOxZrGoZMx1ARA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624038163;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4T6r4OFbKcFYZScWGv36zptdxpcLrCD12HgvKArkW0=;
        b=kL4cKFhRia7OCNkSrXx51ld7LaN/rAwOHPXqshk9eODPGS/Y6Bt+QwjCuiSMUExgho5YxG
        vXDpxBOjZqAiRhAA==
From:   "tip-bot2 for Fan Du" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm: Avoid truncating memblocks for SGX memory
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Fan Du <fan.du@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210617194657.0A99CB22@viggo.jf.intel.com>
References: <20210617194657.0A99CB22@viggo.jf.intel.com>
MIME-Version: 1.0
Message-ID: <162403816226.19906.11145156429556481411.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     28e5e44aa3f4e0e0370864ed008fb5e2d85f4dc8
Gitweb:        https://git.kernel.org/tip/28e5e44aa3f4e0e0370864ed008fb5e2d85f4dc8
Author:        Fan Du <fan.du@intel.com>
AuthorDate:    Thu, 17 Jun 2021 12:46:57 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 18 Jun 2021 19:37:01 +02:00

x86/mm: Avoid truncating memblocks for SGX memory

tl;dr:

Several SGX users reported seeing the following message on NUMA systems:

  sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback to the NUMA node 0.

This turned out to be the memblock code mistakenly throwing away SGX
memory.

=== Full Changelog ===

The 'max_pfn' variable represents the highest known RAM address.  It can
be used, for instance, to quickly determine for which physical addresses
there is mem_map[] space allocated.  The numa_meminfo code makes an
effort to throw out ("trim") all memory blocks which are above 'max_pfn'.

SGX memory is not considered RAM (it is marked as "Reserved" in the
e820) and is not taken into account by max_pfn. Despite this, SGX memory
areas have NUMA affinity and are enumerated in the ACPI SRAT table. The
existing SGX code uses the numa_meminfo mechanism to look up the NUMA
affinity for its memory areas.

In cases where SGX memory was above max_pfn (usually just the one EPC
section in the last highest NUMA node), the numa_memblock is truncated
at 'max_pfn', which is below the SGX memory.  When the SGX code tries to
look up the affinity of this memory, it fails and produces an error message:

  sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback to the NUMA node 0.

and assigns the memory to NUMA node 0.

Instead of silently truncating the memory block at 'max_pfn' and
dropping the SGX memory, add the truncated portion to
'numa_reserved_meminfo'.  This allows the SGX code to later determine
the NUMA affinity of its 'Reserved' area.

Before, numa_meminfo looked like this (from 'crash'):

  blk = { start =          0x0, end = 0x2080000000, nid = 0x0 }
        { start = 0x2080000000, end = 0x4000000000, nid = 0x1 }

numa_reserved_meminfo is empty.

With this, numa_meminfo looks like this:

  blk = { start =          0x0, end = 0x2080000000, nid = 0x0 }
        { start = 0x2080000000, end = 0x4000000000, nid = 0x1 }

and numa_reserved_meminfo has an entry for node 1's SGX memory:

  blk =  { start = 0x4000000000, end = 0x4080000000, nid = 0x1 }

 [ daveh: completely rewrote/reworked changelog ]

Fixes: 5d30f92e7631 ("x86/NUMA: Provide a range-to-target_node lookup facility")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Fan Du <fan.du@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210617194657.0A99CB22@viggo.jf.intel.com
---
 arch/x86/mm/numa.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 5eb4dc2..e94da74 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -254,7 +254,13 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 
 		/* make sure all non-reserved blocks are inside the limits */
 		bi->start = max(bi->start, low);
-		bi->end = min(bi->end, high);
+
+		/* preserve info for non-RAM areas above 'max_pfn': */
+		if (bi->end > high) {
+			numa_add_memblk_to(bi->nid, high, bi->end,
+					   &numa_reserved_meminfo);
+			bi->end = high;
+		}
 
 		/* and there's no empty block */
 		if (bi->start >= bi->end)
