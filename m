Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350C73C49AE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhGLGqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239178AbhGLGow (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCF1611ED;
        Mon, 12 Jul 2021 06:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072067;
        bh=jrROJwRekfV1PhsB5i4U1snoZVNxzMGnJYLoh/kha5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhVkr8mUPHpV90ZiVulHLRonyyw3BkVKtVy4/qSPAIVufmcQHaguds9nu3oTc+o7M
         gl1PNFevcTRPp5ZVEbZ7cKZLjrbCkS7p/lI59B5N6/Jsrp99qu6Ik1cpl7BgmNEUU+
         jqXGSeJJzwRjjBWOMXTNKx33MujygBPAM3veovOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/593] mm: page_alloc: refactor setup_per_zone_lowmem_reserve()
Date:   Mon, 12 Jul 2021 08:07:37 +0200
Message-Id: <20210712060917.348730375@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 470c61d70299b1826f56ff5fede10786798e3c14 ]

setup_per_zone_lowmem_reserve() iterates through each zone setting
zone->lowmem_reserve[j] = 0 (where j is the zone's index) then iterates
backwards through all preceding zones, setting
lower_zone->lowmem_reserve[j] = sum(managed pages of higher zones) /
lowmem_reserve_ratio[idx] for each (where idx is the lower zone's index).

If the lower zone has no managed pages or its ratio is 0 then all of its
lowmem_reserve[] entries are effectively zeroed.

As these arrays are only assigned here and all lowmem_reserve[] entries
for index < this zone's index are implicitly assumed to be 0 (as these are
specifically output in show_free_areas() and zoneinfo_show_print() for
example) there is no need to additionally zero index == this zone's index
too.  This patch avoids zeroing unnecessarily.

Rather than iterating through zones and setting lowmem_reserve[j] for each
lower zone this patch reverse the process and populates each zone's
lowmem_reserve[] values in ascending order.

This clarifies what is going on especially in the case of zero managed
pages or ratio which is now explicitly shown to clear these values.

Link: https://lkml.kernel.org/r/20201129162758.115907-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 81cc7fdc9c8f..f955610fb552 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7788,31 +7788,24 @@ static void calculate_totalreserve_pages(void)
 static void setup_per_zone_lowmem_reserve(void)
 {
 	struct pglist_data *pgdat;
-	enum zone_type j, idx;
+	enum zone_type i, j;
 
 	for_each_online_pgdat(pgdat) {
-		for (j = 0; j < MAX_NR_ZONES; j++) {
-			struct zone *zone = pgdat->node_zones + j;
-			unsigned long managed_pages = zone_managed_pages(zone);
-
-			zone->lowmem_reserve[j] = 0;
-
-			idx = j;
-			while (idx) {
-				struct zone *lower_zone;
-
-				idx--;
-				lower_zone = pgdat->node_zones + idx;
-
-				if (!sysctl_lowmem_reserve_ratio[idx] ||
-				    !zone_managed_pages(lower_zone)) {
-					lower_zone->lowmem_reserve[j] = 0;
-					continue;
+		for (i = 0; i < MAX_NR_ZONES - 1; i++) {
+			struct zone *zone = &pgdat->node_zones[i];
+			int ratio = sysctl_lowmem_reserve_ratio[i];
+			bool clear = !ratio || !zone_managed_pages(zone);
+			unsigned long managed_pages = 0;
+
+			for (j = i + 1; j < MAX_NR_ZONES; j++) {
+				if (clear) {
+					zone->lowmem_reserve[j] = 0;
 				} else {
-					lower_zone->lowmem_reserve[j] =
-						managed_pages / sysctl_lowmem_reserve_ratio[idx];
+					struct zone *upper_zone = &pgdat->node_zones[j];
+
+					managed_pages += zone_managed_pages(upper_zone);
+					zone->lowmem_reserve[j] = managed_pages / ratio;
 				}
-				managed_pages += zone_managed_pages(lower_zone);
 			}
 		}
 	}
-- 
2.30.2



