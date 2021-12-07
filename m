Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DED46BC64
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 14:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhLGN0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 08:26:37 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60750 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhLGN0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 08:26:37 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3195D1FDFE;
        Tue,  7 Dec 2021 13:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638883386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e3MujDroQCCYFmjo9aU+XnlNtxQIfbbwBM+qx0TwvZA=;
        b=seX7fjd3dhWbMLAzyyjOOcYy5pvqRFbfqgSB8dF+6CqlVqD6PH5s5EPABaOLYypyFdDlJ9
        ywbxRdq9qIuAaZnxc9VBTcZ1jf6GJS/JF1CmOOvwPZ5ZO1w616j2VQ+VTZqWpBh0WlC5vu
        awim2Bn8l5QAUyuNH6vWNtBeerc21GI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 040D8A3B89;
        Tue,  7 Dec 2021 13:23:05 +0000 (UTC)
Date:   Tue, 7 Dec 2021 14:23:03 +0100
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
Message-ID: <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
References: <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 13:28:31, David Hildenbrand wrote:
[...]
> But maybe I am missing something important regarding online vs. offline
> nodes that your patch changes?

I am relying on alloc_node_data setting the node online. But if we are
to change the call to arch_alloc_node_data then the patch needs to be
more involved. Here is what I have right now. If this happens to be the
right way then there is some additional work to sync up with the hotplug
code.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..a296e934ad2f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8032,8 +8032,23 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
+	for_each_node(nid) {
+		pg_data_t *pgdat;
+
+		if (!node_online(nid)) {
+			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n", nid);
+			pgdat = arch_alloc_nodedata(nid);
+			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+			arch_refresh_nodedata(nid, pgdat);
+			node_set_online(nid);
+			/* TODO do we need register_one_node here or postpone to
+			 * when any memory is onlined there
+			 */
+			free_area_init_memoryless_node(nid);
+			continue;
+		}
+
+		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
 		/* Any memory on that node */
-- 
Michal Hocko
SUSE Labs
