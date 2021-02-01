Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F330A9E2
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 15:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBAOf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 09:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBAOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 09:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC2460C41;
        Mon,  1 Feb 2021 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612190082;
        bh=y1WIXhQf1MNfS1FPxWGyuvnTlyipMve7MwfnSTBmv6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0AqnHNbQAdKqs/Z3IjF2PCzZ6m2kolaPMzVt2xxFzWHqZ19BKS8lLLQP6cLQ4PGN
         qJhAFv7Og9Zj7117MJqMkdwn1YeVVmlYq5ocUAP3x1XcPUj5lYzzE7qg43frssnwvG
         aNdS3FTP+4bJxP0R84Q0/fkiZmuEXsXsm0Yt7k/EBC1RetOMZTWwvRKWF17Gf2imiI
         zPyM97v6FJolmQrFNigGeNgFIiQvykKWH6hlaqJVIpabOvmSmMIIj4yjbjhltTJj9L
         Ofv8qMTbbsV9PZR/tz02JU+lW03PhwDsYWQpZQHFkKMZJ0L60EIFY4fZJczB23icAj
         QQUG6X5ZAWziA==
Date:   Mon, 1 Feb 2021 16:34:29 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Baoquan He <bhe@redhat.com>
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
Message-ID: <20210201143429.GJ242749@kernel.org>
References: <20210130221035.4169-1-rppt@kernel.org>
 <20210130221035.4169-2-rppt@kernel.org>
 <56e2c568-b121-8860-a6b0-274ace46d835@redhat.com>
 <20210201112605.GA2357@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201112605.GA2357@MiWiFi-R3L-srv>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 07:26:05PM +0800, Baoquan He wrote:
> On 02/01/21 at 10:32am, David Hildenbrand wrote:
> > 
> > 2) In init_zone_unavailable_mem(), similar to round_up(max_pfn,
> > PAGES_PER_SECTION) handling, consider range
> > 	[round_down(min_pfn, PAGES_PER_SECTION), min_pfn - 1]
> > which would handle in the x86-64 case [0..0] and, therefore, initialize PFN
> > 0.
> 
> Sounds reasonable. Maybe we can change to get the real expected lowest
> pfn from find_min_pfn_for_node() by iterating memblock.memory and
> memblock.reserved and comparing.

As I've found out the hard way [1], reserved memory is not necessary present.

There could be a system that instead of reserving memory at 0xfe000000 like
in Guillaume's report, could have it reserved at 0x0 and populated only
from the first gigabyte...
 
[1] https://lore.kernel.org/lkml/127999c4-7d56-0c36-7f88-8e1a5c934cae@collabora.com


-- 
Sincerely yours,
Mike.
