Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31C5106E2D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfKVLGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731154AbfKVLGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1F22084F;
        Fri, 22 Nov 2019 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420806;
        bh=mRKZx/dtkkwJ3Waki57KbIjqXykXG+/ubnEk0vOs8iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+ANl7ZSMLjHk4vh7zrgLMV7Fmw7QJ3oVtLSu1FXBd2K/S5pNsHiHAbAjQCHd46KF
         XxW+WPnDc6fYxcFHgw2hwTURGUxoDljqQiJKC8c+20a/29GFPBVy/NHo98n+o+ju4/
         KVAyrBWOJtIPJvgfbGsh/QqHV9vz+DtQwTz8GIDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 4/6] mm/memory_hotplug: fix updating the node span
Date:   Fri, 22 Nov 2019 11:30:06 +0100
Message-Id: <20191122100326.607203017@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100320.878809004@linuxfoundation.org>
References: <20191122100320.878809004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 656d571193262a11c2daa4012e53e4d645bbce56 upstream.

We recently started updating the node span based on the zone span to
avoid touching uninitialized memmaps.

Currently, we will always detect the node span to start at 0, meaning a
node can easily span too many pages.  pgdat_is_empty() will still work
correctly if all zones span no pages.  We should skip over all zones
without spanned pages and properly handle the first detected zone that
spans pages.

Unfortunately, in contrast to the zone span (/proc/zoneinfo), the node
span cannot easily be inspected and tested.  The node span gives no real
guarantees when an architecture supports memory hotplug, meaning it can
easily contain holes or span pages of different nodes.

The node span is not really used after init on architectures that
support memory hotplug.

E.g., we use it in mm/memory_hotplug.c:try_offline_node() and in
mm/kmemleak.c:kmemleak_scan().  These users seem to be fine.

Link: http://lkml.kernel.org/r/20191027222714.5313-1-david@redhat.com
Fixes: 00d6c019b5bc ("mm/memory_hotplug: don't access uninitialized memmaps in shrink_pgdat_span()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -447,6 +447,14 @@ static void update_pgdat_span(struct pgl
 					     zone->spanned_pages;
 
 		/* No need to lock the zones, they can't change. */
+		if (!zone->spanned_pages)
+			continue;
+		if (!node_end_pfn) {
+			node_start_pfn = zone->zone_start_pfn;
+			node_end_pfn = zone_end_pfn;
+			continue;
+		}
+
 		if (zone_end_pfn > node_end_pfn)
 			node_end_pfn = zone_end_pfn;
 		if (zone->zone_start_pfn < node_start_pfn)


