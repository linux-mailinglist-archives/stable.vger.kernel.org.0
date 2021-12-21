Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDEE47BD1E
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhLUJqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 04:46:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:37616 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLUJqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 04:46:44 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 721921F3A6;
        Tue, 21 Dec 2021 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640080002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eDV7ojDA9yacpuD6gn5NMBRe3pB+4RNyWvrkYopERAw=;
        b=dTcPNyHMy+oRw4ZZNWd43dMs3L8hWRFoTNmNp6rLJI6/04ZPa/sP6/Tl4XTh0DW8mrdD8x
        emio+RvyJMV6/Ti/de/ivBqgVbFExD1Y7W0ihpgeLG54YTJizPyVAPnHeKyytZYBIm6XJ9
        DKKLmt1H32lauo8V73CchSC6viDE+tg=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 51A2CA3B83;
        Tue, 21 Dec 2021 09:46:42 +0000 (UTC)
Date:   Tue, 21 Dec 2021 10:46:42 +0100
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
Message-ID: <YcGignpJgdvy9Vnu@dhcp22.suse.cz>
References: <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
 <YbMZsczMGpChaWz0@dhcp22.suse.cz>
 <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
 <FD8165E2-E17E-458E-B4EE-8C4DB21BA3B6@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FD8165E2-E17E-458E-B4EE-8C4DB21BA3B6@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 21-12-21 05:46:16, Alexey Makhalov wrote:
> Hi Michal,
> 
> The patchset looks good to me. I didn’t find any issues during the testing.

Thanks a lot. Can I add your Tested-by: tag?

> I have one concern regarding dmesg output. Do you think this messaging is
> valid if possible node is not yet present?
> Or is it only the issue for virtual machines?
> 
>   Node XX uninitialized by the platform. Please report with boot dmesg.
>   Initmem setup node XX [mem 0x0000000000000000-0x0000000000000000]

AFAIU the Initmem part of the output is what concerns you, right? Yeah,
that really is more cryptic than necessary. Does this look any better?
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 34743dcd2d66..7e18a924be7e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7618,9 +7618,14 @@ static void __init free_area_init_node(int nid)
 	pgdat->node_start_pfn = start_pfn;
 	pgdat->per_cpu_nodestats = NULL;
 
-	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-		(u64)start_pfn << PAGE_SHIFT,
-		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	if (start_pfn != end_pfn) {
+		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+			(u64)start_pfn << PAGE_SHIFT,
+			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	} else {
+		pr_info("Initmem setup node %d as memoryless\n", nid);
+	}
+
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn);
 
 	alloc_node_mem_map(pgdat);
-- 
Michal Hocko
SUSE Labs
