Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DC0171F0F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733091AbgB0OCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733021AbgB0OCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D6520578;
        Thu, 27 Feb 2020 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812138;
        bh=26byM/6/j3s9hAaGF69RZX3n3JrlqHW/MM5O10D9x0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOIFqrwZxCwcARYOuz6yEPKCX9uDg7Sj8TQeD1hCQ3rmn3H7slKgGuAY591pf+HOd
         O1YfJc5NRAeUvjfWKeQQZ/x5sH7tJ7gpT45p1BFe7QUcSk8F9f/46qG4cHSxqNF0Zq
         ceETymtUN+ehDvpdlgKqpkCrrANktElebllgU614=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 198/237] mm/vmscan.c: dont round up scan size for online memory cgroup
Date:   Thu, 27 Feb 2020 14:36:52 +0100
Message-Id: <20200227132310.862038498@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

commit 76073c646f5f4999d763f471df9e38a5a912d70d upstream.

Commit 68600f623d69 ("mm: don't miss the last page because of round-off
error") makes the scan size round up to @denominator regardless of the
memory cgroup's state, online or offline.  This affects the overall
reclaiming behavior: the corresponding LRU list is eligible for
reclaiming only when its size logically right shifted by @sc->priority
is bigger than zero in the former formula.

For example, the inactive anonymous LRU list should have at least 0x4000
pages to be eligible for reclaiming when we have 60/12 for
swappiness/priority and without taking scan/rotation ratio into account.

After the roundup is applied, the inactive anonymous LRU list becomes
eligible for reclaiming when its size is bigger than or equal to 0x1000
in the same condition.

    (0x4000 >> 12) * 60 / (60 + 140 + 1) = 1
    ((0x1000 >> 12) * 60) + 200) / (60 + 140 + 1) = 1

aarch64 has 512MB huge page size when the base page size is 64KB.  The
memory cgroup that has a huge page is always eligible for reclaiming in
that case.

The reclaiming is likely to stop after the huge page is reclaimed,
meaing the further iteration on @sc->priority and the silbing and child
memory cgroups will be skipped.  The overall behaviour has been changed.
This fixes the issue by applying the roundup to offlined memory cgroups
only, to give more preference to reclaim memory from offlined memory
cgroup.  It sounds reasonable as those memory is unlikedly to be used by
anyone.

The issue was found by starting up 8 VMs on a Ampere Mustang machine,
which has 8 CPUs and 16 GB memory.  Each VM is given with 2 vCPUs and
2GB memory.  It took 264 seconds for all VMs to be completely up and
784MB swap is consumed after that.  With this patch applied, it took 236
seconds and 60MB swap to do same thing.  So there is 10% performance
improvement for my case.  Note that KSM is disable while THP is enabled
in the testing.

         total     used    free   shared  buff/cache   available
   Mem:  16196    10065    2049       16        4081        3749
   Swap:  8175      784    7391
         total     used    free   shared  buff/cache   available
   Mem:  16196    11324    3656       24        1215        2936
   Swap:  8175       60    8115

Link: http://lkml.kernel.org/r/20200211024514.8730-1-gshan@redhat.com
Fixes: 68600f623d69 ("mm: don't miss the last page because of round-off error")
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2369,10 +2369,13 @@ out:
 			/*
 			 * Scan types proportional to swappiness and
 			 * their relative recent reclaim efficiency.
-			 * Make sure we don't miss the last page
-			 * because of a round-off error.
+			 * Make sure we don't miss the last page on
+			 * the offlined memory cgroups because of a
+			 * round-off error.
 			 */
-			scan = DIV64_U64_ROUND_UP(scan * fraction[file],
+			scan = mem_cgroup_online(memcg) ?
+			       div64_u64(scan * fraction[file], denominator) :
+			       DIV64_U64_ROUND_UP(scan * fraction[file],
 						  denominator);
 			break;
 		case SCAN_FILE:


