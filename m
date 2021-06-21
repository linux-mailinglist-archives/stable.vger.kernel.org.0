Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FAC3AF098
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhFUQus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232424AbhFUQrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B560613F6;
        Mon, 21 Jun 2021 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293211;
        bh=mzFB7BJnOi3qQUbcanvJmanEMO/M7hOK+kOcLMJVZUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyE1PR+AwbZJskbNjTjICTZid58VkDnXLd1wyGhpreB+QBikyzZy0K6PojYuG9Tk5
         q8Vgb9TDaeyt/miz6gVQWjcp6EmTnjYmkrKhOsXUKkkz0Zgmx7zwTi1g1FQjjfJ3YG
         Fs/99xecdresh8G/INWTAVqI/5r8BHPPfOJ0WtQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fan Du <fan.du@intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.12 140/178] x86/mm: Avoid truncating memblocks for SGX memory
Date:   Mon, 21 Jun 2021 18:15:54 +0200
Message-Id: <20210621154927.539481178@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fan Du <fan.du@intel.com>

commit 28e5e44aa3f4e0e0370864ed008fb5e2d85f4dc8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/numa.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -254,7 +254,13 @@ int __init numa_cleanup_meminfo(struct n
 
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


