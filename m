Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742352EBAF2
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 09:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAFIGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 03:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbhAFIGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 03:06:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7483823105;
        Wed,  6 Jan 2021 08:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609920363;
        bh=DOxADtf74LzPX3TOq50ZcCx2eedEzlGE74o1a4nc3p8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hMKYoGciJMH2s1vxYcEKx8LKui+yfYYH8T5NTc2XebwsvezalLppbSVeSRgtitC+m
         hBfkbN2nlz1srNNE+f7iBIBl3N/w26uF0dprP/Bh3AoBNJuEGu38T2YmSySttF3dxn
         PMgHLKwlTJln6zur+sie+b9CVirlr2Z25Fqti75punXqeCDKl/K4lDz5KHML/+3cvV
         ClR9XgID7zZc8HHPdagkrymcnsNQplmR6ZnkV99X6LSOBi9wg6rKGu/4Pee8z9G4qo
         8W/4sX8yb4X7fHdxFGqwl6m1ntVSPmcyXfq1p/aIeEZlCc3ecikuWNVqlyTjLT4IJz
         Eoi6EktwArSVg==
Date:   Wed, 6 Jan 2021 10:05:53 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Qian Cai <qcai@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
Message-ID: <20210106080553.GB1106298@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-3-rppt@kernel.org>
 <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
 <20210105082403.GA1106298@kernel.org>
 <67ef893f27551f80ecf49ef78c0ebc05d3e41b46.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ef893f27551f80ecf49ef78c0ebc05d3e41b46.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 01:45:37PM -0500, Qian Cai wrote:
> On Tue, 2021-01-05 at 10:24 +0200, Mike Rapoport wrote:
> > Hi,
> > 
> > On Mon, Jan 04, 2021 at 02:03:00PM -0500, Qian Cai wrote:
> > > On Wed, 2020-12-09 at 23:43 +0200, Mike Rapoport wrote:
> > > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > > 
> > > > Interleave initialization of pages that correspond to holes with the
> > > > initialization of memory map, so that zone and node information will be
> > > > properly set on such pages.
> > > > 
> > > > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> > > > rather
> > > > that check each PFN")
> > > > Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> > > > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > > 
> > > Reverting this commit on the top of today's linux-next fixed a crash while
> > > reading /proc/kpagecount on a NUMA server.
> > 
> > Can you please post the entire dmesg?
> 
> http://people.redhat.com/qcai/dmesg.txt
> 
> > Is it possible to get the pfn that triggered the crash?
> 
> Do you have any idea how to convert that fffffffffffffffe to pfn as it is always
> that address? I don't understand what that address is though. I tried to catch
> it from struct page pointer and page_address() without luck.

I think we trigger PF_POISONED_CHECK() in PageSlab(), then fffffffffffffffe
is "accessed" from VM_BUG_ON_PAGE().

It seems to me that we are not initializing struct pages for holes at the node
boundaries because zones are already clamped to exclude those holes.

Can you please try to see if the patch below will produce any useful info:
 
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 4dcbcd506cb6..708f8211dcc0 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -66,10 +66,14 @@ static ssize_t kpagecount_read(struct file *file, char __user *buf,
 		 */
 		ppage = pfn_to_online_page(pfn);
 
-		if (!ppage || PageSlab(ppage) || page_has_type(ppage))
+		if (ppage && PagePoisoned(ppage)) {
+			pr_info("%s: pfn %lx is poisoned\n", __func__, pfn);
 			pcount = 0;
-		else
+		} else if (!ppage || PageSlab(ppage) || page_has_type(ppage)) {
+			pcount = 0;
+		} else {
 			pcount = page_mapcount(ppage);
+		}
 
 		if (put_user(pcount, out)) {
 			ret = -EFAULT;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 124b8c654ec6..1b3a37ace1b1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6271,6 +6271,8 @@ static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn,
 	unsigned long pfn;
 	u64 pgcnt = 0;
 
+	pr_info("%s: spfn: %lx, epfn: %lx, zone: %s, node: %d\n", __func__, spfn, epfn, zone_names[zone], node);
+
 	for (pfn = spfn; pfn < epfn; pfn++) {
 		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
 			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
 
> >  
> > > [ 8858.006726][T99897] BUG: unable to handle page fault for address:
> > > fffffffffffffffe
> > > [ 8858.014814][T99897] #PF: supervisor read access in kernel mode
> > > [ 8858.020686][T99897] #PF: error_code(0x0000) - not-present page
> > > [ 8858.026557][T99897] PGD 1371417067 P4D 1371417067 PUD 1371419067 PMD 0 
> > > [ 8858.033224][T99897] Oops: 0000 [#1] SMP KASAN NOPTI
> > > [ 8858.038710][T99897] CPU: 28 PID: 99897 Comm: proc01 Tainted:
> > > G           O      5.11.0-rc1-next-20210104 #1
> > > [ 8858.048515][T99897] Hardware name: HPE ProLiant DL385 Gen10/ProLiant
> > > DL385 Gen10, BIOS A40 03/09/2018
> > > [ 8858.057794][T99897] RIP: 0010:kpagecount_read+0x1be/0x5e0
> > > PageSlab at include/linux/page-flags.h:342
> > > (inlined by) kpagecount_read at fs/proc/page.c:69
> 

-- 
Sincerely yours,
Mike.
