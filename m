Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EDF24E711
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 13:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgHVLcC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Aug 2020 07:32:02 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:60388 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726920AbgHVLcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 07:32:01 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22207247-1500050 
        for multiple; Sat, 22 Aug 2020 12:31:56 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <159805314945.32652.6355592202796435703@build.alporthouse.com>
References: <20200821123746.16904-1-joro@8bytes.org> <20200821153412.5902e4ed0699615d8de4a595@linux-foundation.org> <159805314945.32652.6355592202796435703@build.alporthouse.com>
Subject: Re: [PATCH v2] mm: Track page table modifications in __apply_to_page_range()
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
To:     Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Date:   Sat, 22 Aug 2020 12:31:55 +0100
Message-ID: <159809591535.32652.4016790228519688343@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-08-22 00:39:09)
> Quoting Andrew Morton (2020-08-21 23:34:12)
> > On Fri, 21 Aug 2020 14:37:46 +0200 Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > The __apply_to_page_range() function is also used to change and/or
> > > allocate page-table pages in the vmalloc area of the address space.
> > > Make sure these changes get synchronized to other page-tables in the
> > > system by calling arch_sync_kernel_mappings() when necessary.
> > > 
> > > Tested-by: Chris Wilson <chris@chris-wilson.co.uk> #x86-32
> > > Cc: <stable@vger.kernel.org> # v5.8+
> > 
> > I'm trying to figure out how you figured out that this is 5.8+.  Has a
> > particular misbehaving commit been identified?
> 
> The two commits of relevance, in my eyes, were
> 
>   2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
>   86cf69f1d893 ("x86/mm/32: implement arch_sync_kernel_mappings()")
> 
> I can reproduce the failure on v5.8, but not on v5.7. A bisect would
> seem to be plausible.

The active ingredient was

7f0a002b5a21 ("x86/mm: remove vmalloc faulting")

which explains a lot.
-Chris
