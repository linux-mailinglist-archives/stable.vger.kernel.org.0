Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A217188DBD
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfHJUsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54780 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDT-00053q-9P; Sat, 10 Aug 2019 21:43:55 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003kW-Om; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Rik van Riel" <riel@redhat.com>, "Michal Hocko" <mhocko@suse.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Mel Gorman" <mgorman@suse.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.576161906@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 142/157] proc: meminfo: estimate available memory
 more conservatively
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 84ad5802a33a4964a49b8f7d24d80a214a096b19 upstream.

The MemAvailable item in /proc/meminfo is to give users a hint of how
much memory is allocatable without causing swapping, so it excludes the
zones' low watermarks as unavailable to userspace.

However, for a userspace allocation, kswapd will actually reclaim until
the free pages hit a combination of the high watermark and the page
allocator's lowmem protection that keeps a certain amount of DMA and
DMA32 memory from userspace as well.

Subtract the full amount we know to be unavailable to userspace from the
number of free pages when calculating MemAvailable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/proc/meminfo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -57,11 +57,8 @@ static int meminfo_proc_show(struct seq_
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
 	 * without causing swapping.
-	 *
-	 * Free memory cannot be taken below the low watermark, before the
-	 * system starts swapping.
 	 */
-	available = i.freeram - wmark_low;
+	available = i.freeram - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will

