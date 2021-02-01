Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4C930AAD5
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhBAPQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:16:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhBAO6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 09:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612191345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJNG6049dtvcplJRxISBTNlmlRDAp6ZgnUx5xKnhzAM=;
        b=NZ9yxDBEnZIDZwaKPQdepm1lzEbP1U8ZVgnzTSodcoVQqZ4W3yfbLlmrnHwiLGLNC15OEU
        AwsZmqa7ceOV1O0lkCWIWktlhC32PYuIAE/ix3W0sRMbVaoyd/vTPCjLU7FnskqLguuHUX
        5lbJJnNctox0IoZQQb+xofKLV9xLKNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-g-eMEYKTNbGeF6HKF5rRQg-1; Mon, 01 Feb 2021 09:55:42 -0500
X-MC-Unique: g-eMEYKTNbGeF6HKF5rRQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B32F802B47;
        Mon,  1 Feb 2021 14:55:40 +0000 (UTC)
Received: from localhost (ovpn-12-141.pek2.redhat.com [10.72.12.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41ABC6F7E9;
        Mon,  1 Feb 2021 14:55:36 +0000 (UTC)
Date:   Mon, 1 Feb 2021 22:55:34 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v4 1/2] x86/setup: always add the beginning of RAM as
 memblock.memory
Message-ID: <20210201145534.GA9009@MiWiFi-R3L-srv>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
 <20210201112605.GA2357@MiWiFi-R3L-srv>
 <20210201143429.GJ242749@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201143429.GJ242749@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/01/21 at 04:34pm, Mike Rapoport wrote:
> On Mon, Feb 01, 2021 at 07:26:05PM +0800, Baoquan He wrote:
> > On 02/01/21 at 10:32am, David Hildenbrand wrote:
> > > 
> > > 2) In init_zone_unavailable_mem(), similar to round_up(max_pfn,
> > > PAGES_PER_SECTION) handling, consider range
> > > 	[round_down(min_pfn, PAGES_PER_SECTION), min_pfn - 1]
> > > which would handle in the x86-64 case [0..0] and, therefore, initialize PFN
> > > 0.
> > 
> > Sounds reasonable. Maybe we can change to get the real expected lowest
> > pfn from find_min_pfn_for_node() by iterating memblock.memory and
> > memblock.reserved and comparing.
> 
> As I've found out the hard way [1], reserved memory is not necessary present.
> 
> There could be a system that instead of reserving memory at 0xfe000000 like
> in Guillaume's report, could have it reserved at 0x0 and populated only
> from the first gigabyte...

OK. I thought that we can even compare memblock.memory.regions[0].base
with memblock.reserved.regions[0].base and take the smaller one as the
lowest pfn and assign it to arch_zone_lowest_possible_pfn[0]. When we
try to get the present pages, we still check memblock.memory with
for_each_mem_pfn_range(). Since we will consider and take reserved
memory into zone anyway, arch_zone_lowest_possible_pfn[] only impact the
boundary of zone. Just rough thought, please ignore it if something is
missed.

Thanks
Baoquan

