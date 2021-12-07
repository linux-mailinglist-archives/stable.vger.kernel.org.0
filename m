Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E745C46B99C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 11:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhLGK6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 05:58:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52234 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhLGK6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 05:58:06 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 78F6F212BE;
        Tue,  7 Dec 2021 10:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638874475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n/VtBKAgGrOoJ9mlQUX4QcNZE7VUA2PWVux2aJmIsx4=;
        b=pX0oqqwAbTsF7GqTf4ROFm8RHUaNC6UZqlUn2IbCNmYDi3sLHAEYbiOwyJ29ZH2YTYpqXP
        ofRg6Z9wiaDV/9vwK9BbgKjExQysy6orOXfwW4zZWqkUuY0N/HY6yzYpX/nFKm1bMLDxUe
        Y/BiHkOJ2Gn04wAC41zC5cOsX+jmsYI=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E997CA3B81;
        Tue,  7 Dec 2021 10:54:34 +0000 (UTC)
Date:   Tue, 7 Dec 2021 11:54:34 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
I didn't have much time to dive into this deeper and I have hit some
problems handling this in an arch specific code so I have tried to play
with this instead:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..4d71759d0d9b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8032,8 +8032,16 @@ void __init free_area_init(unsigned long *max_zone_pfn)
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	for_each_online_node(nid) {
+	for_each_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
+
+		if (!node_online(nid)) {
+			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n");
+			alloc_node_data(nid);
+			free_area_init_memoryless_node(nid);
+			continue;
+		}
+
 		free_area_init_node(nid);
 
 		/* Any memory on that node */

Could you give it a try? I do not have any machine which would exhibit
the problem so I cannot really test this out. I hope build_zone_info
will not choke on this. I assume the node distance table is
uninitialized for these nodes and IIUC this should lead to an assumption
that all other nodes are close. But who knows that can blow up there.

Btw. does this make any sense at all to others?
-- 
Michal Hocko
SUSE Labs
