Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2F22EA691
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 09:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbhAEIYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 03:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbhAEIYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 03:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 296DF22257;
        Tue,  5 Jan 2021 08:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609835052;
        bh=deo8XaMfgbGmmhIV9cJBRWOZv+tbhfFZQyP36FphooY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6YWQpFOYWm8WD30VXbBNK4tnO6776SRQtl4XHWsjEGJwbRKJ0dGc3jsddNiWjwmD
         UJz3s0IGYF3QhgGjIWCQHCP8GR0YKeCRFhONE1PUdCrwwPRfTT0L6D5W4jC8ZWFqb6
         SSfrfn/R5+thvYLUkWB4WW/I11QgpjmcYGWC73PpDfL9dklmJJdRXtUS4n6tIbyPUd
         oMMfdIM9bxKiu7oq6I5LXzVkyeQBAiHb7KK0v/njrHlxA15FeArvr5XQeCbdAvionA
         ELSTXSKcvg3KuOaQx3Xw9e9hJECW39rL1SrIohHAXyM5ChKdro4YmipwsgRzK5t8tz
         /l+npEFq9PQDg==
Date:   Tue, 5 Jan 2021 10:24:03 +0200
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
Message-ID: <20210105082403.GA1106298@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-3-rppt@kernel.org>
 <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jan 04, 2021 at 02:03:00PM -0500, Qian Cai wrote:
> On Wed, 2020-12-09 at 23:43 +0200, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Interleave initialization of pages that correspond to holes with the
> > initialization of memory map, so that zone and node information will be
> > properly set on such pages.
> > 
> > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
> > that check each PFN")
> > Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> 
> Reverting this commit on the top of today's linux-next fixed a crash while
> reading /proc/kpagecount on a NUMA server.

Can you please post the entire dmesg?
Is it possible to get the pfn that triggered the crash?
 
> [ 8858.006726][T99897] BUG: unable to handle page fault for address: fffffffffffffffe
> [ 8858.014814][T99897] #PF: supervisor read access in kernel mode
> [ 8858.020686][T99897] #PF: error_code(0x0000) - not-present page
> [ 8858.026557][T99897] PGD 1371417067 P4D 1371417067 PUD 1371419067 PMD 0 
> [ 8858.033224][T99897] Oops: 0000 [#1] SMP KASAN NOPTI
> [ 8858.038710][T99897] CPU: 28 PID: 99897 Comm: proc01 Tainted: G           O      5.11.0-rc1-next-20210104 #1
> [ 8858.048515][T99897] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
> [ 8858.057794][T99897] RIP: 0010:kpagecount_read+0x1be/0x5e0
> PageSlab at include/linux/page-flags.h:342
> (inlined by) kpagecount_read at fs/proc/page.c:69

-- 
Sincerely yours,
Mike.
