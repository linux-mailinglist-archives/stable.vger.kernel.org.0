Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B791106C45
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfKVKuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbfKVKuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A02520656;
        Fri, 22 Nov 2019 10:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419853;
        bh=/O8vgSfJmlffn4M56jr8hXU25VCaMFhRBL/Sk4VvUmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJYt+kXDEZhpGhc4AuL6UErOz5VbM8jocW14qxZcjZ8KVHN5JEUFhfXQBtd30NjTa
         W+01+qp9/0ZPAkbFFnZ0BPQmyQEaWCe+ttAZNCqKGhWcbut0Iqh2AkUwrNENI3GEr7
         sly7CoAoBXLWOXpX2MFLl6hZF4A8QNZgc9oe0bfk=
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
Subject: [PATCH 4.14 007/122] mm/memory_hotplug: fix updating the node span
Date:   Fri, 22 Nov 2019 11:27:40 +0100
Message-Id: <20191122100727.359872325@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
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
@@ -470,6 +470,14 @@ static void update_pgdat_span(struct pgl
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


