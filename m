Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA592EB2C3
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbhAESrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:47:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbhAESrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609872346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K1TAF9Fcst8dyNOllX1PJEA1E2V0hS7RDbI5Vu/KXE0=;
        b=Y1O/dKD5WtWpvF3tf+ApJEndS+iZMxZJHIb9OaqhvBHVxqqJ3Ar5d4A60JnphJ/EXsIFp3
        y8LEcA/X2lfTnJuvRc7Lfoc2KUL65QD1qUhJvDr8Zpb2B/T2WNgcIfjo7hq0P29CjBgmFK
        LHsNThNfWg2CLzabfukdW4t0sIf0rzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-UEURmLKoN4uLTga7Rrh3Gw-1; Tue, 05 Jan 2021 13:45:44 -0500
X-MC-Unique: UEURmLKoN4uLTga7Rrh3Gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D7F10054FF;
        Tue,  5 Jan 2021 18:45:42 +0000 (UTC)
Received: from ovpn-115-104.rdu2.redhat.com (ovpn-115-104.rdu2.redhat.com [10.10.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B4AB60BE5;
        Tue,  5 Jan 2021 18:45:38 +0000 (UTC)
Message-ID: <67ef893f27551f80ecf49ef78c0ebc05d3e41b46.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
From:   Qian Cai <qcai@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
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
Date:   Tue, 05 Jan 2021 13:45:37 -0500
In-Reply-To: <20210105082403.GA1106298@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
         <20201209214304.6812-3-rppt@kernel.org>
         <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
         <20210105082403.GA1106298@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-01-05 at 10:24 +0200, Mike Rapoport wrote:
> Hi,
> 
> On Mon, Jan 04, 2021 at 02:03:00PM -0500, Qian Cai wrote:
> > On Wed, 2020-12-09 at 23:43 +0200, Mike Rapoport wrote:
> > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > 
> > > Interleave initialization of pages that correspond to holes with the
> > > initialization of memory map, so that zone and node information will be
> > > properly set on such pages.
> > > 
> > > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> > > rather
> > > that check each PFN")
> > > Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> > > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Reverting this commit on the top of today's linux-next fixed a crash while
> > reading /proc/kpagecount on a NUMA server.
> 
> Can you please post the entire dmesg?

http://people.redhat.com/qcai/dmesg.txt

> Is it possible to get the pfn that triggered the crash?

Do you have any idea how to convert that fffffffffffffffe to pfn as it is always
that address? I don't understand what that address is though. I tried to catch
it from struct page pointer and page_address() without luck.

>  
> > [ 8858.006726][T99897] BUG: unable to handle page fault for address:
> > fffffffffffffffe
> > [ 8858.014814][T99897] #PF: supervisor read access in kernel mode
> > [ 8858.020686][T99897] #PF: error_code(0x0000) - not-present page
> > [ 8858.026557][T99897] PGD 1371417067 P4D 1371417067 PUD 1371419067 PMD 0 
> > [ 8858.033224][T99897] Oops: 0000 [#1] SMP KASAN NOPTI
> > [ 8858.038710][T99897] CPU: 28 PID: 99897 Comm: proc01 Tainted:
> > G           O      5.11.0-rc1-next-20210104 #1
> > [ 8858.048515][T99897] Hardware name: HPE ProLiant DL385 Gen10/ProLiant
> > DL385 Gen10, BIOS A40 03/09/2018
> > [ 8858.057794][T99897] RIP: 0010:kpagecount_read+0x1be/0x5e0
> > PageSlab at include/linux/page-flags.h:342
> > (inlined by) kpagecount_read at fs/proc/page.c:69

