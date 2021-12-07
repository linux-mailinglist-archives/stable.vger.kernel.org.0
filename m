Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EAB46C0D4
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 17:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhLGQkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 11:40:35 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:50506 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhLGQke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 11:40:34 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8C67B1FE00;
        Tue,  7 Dec 2021 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638895023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9RUC2PhV3f3vpLr11mqtR46jAj5ypI8WeQwEBxBuSg=;
        b=nFAtzgaui7XXCSyIUUC0UwS92t88o7kHrBhmYfbaShb0VuaqvjaVvqshjcMYZjZFAiekzn
        gAYJSC1u5tFGyVtcv44rg12z3kno9uDMQZ4JUqd5e7hAUJbK4tTcMcEfvfX8EiGclUcg/S
        e75pdfB0GAi2ctXqz6kXWUxR9/t0F9E=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 51811A3BA5;
        Tue,  7 Dec 2021 16:37:03 +0000 (UTC)
Date:   Tue, 7 Dec 2021 17:36:59 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
References: <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 17:27:29, Michal Hocko wrote:
[...]
> So your proposal is to drop set_node_online from the patch and add it as
> a separate one which handles 
> 	- sysfs part (i.e. do not register a node which doesn't span a
> 	  physical address space)
> 	- hotplug side of (drop the pgd allocation, register node lazily
> 	  when a first memblocks are registered)

In other words, the first stage
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..f9024ba09c53 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
 	if (self && !node_online(self->node_id)) {
 		build_zonelists(self);
 	} else {
-		for_each_online_node(nid) {
+		/*
+		 * All possible nodes have pgdat preallocated
+		 * free_area_init
+		 */
+		for_each_node(nid) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			build_zonelists(pgdat);
@@ -8032,8 +8036,24 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
+	for_each_node(nid) {
+		pg_data_t *pgdat;
+
+		if (!node_online(nid)) {
+			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
+			pgdat = arch_alloc_nodedata(nid);
+			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+			arch_refresh_nodedata(nid, pgdat);
+			free_area_init_memoryless_node(nid);
+			/*
+			 * not marking this node online because we do not want to
+			 * confuse userspace by sysfs files/directories for node
+			 * without any memory attached to it (see topology_init)
+			 */
+			continue;
+		}
+
+		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
-- 
Michal Hocko
SUSE Labs
