Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15A74F7F43
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245318AbiDGMld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiDGMl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:41:29 -0400
X-Greylist: delayed 396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 05:39:29 PDT
Received: from outbound-smtp30.blacknight.com (outbound-smtp30.blacknight.com [81.17.249.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1EF258456
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 05:39:29 -0700 (PDT)
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp30.blacknight.com (Postfix) with ESMTPS id 1AB24BAA99
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 13:32:52 +0100 (IST)
Received: (qmail 22167 invoked from network); 7 Apr 2022 12:32:51 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.223])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 7 Apr 2022 12:32:51 -0000
Date:   Thu, 7 Apr 2022 13:32:44 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Juergen Gross <jgross@suse.com>
Cc:     Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek Marczykowski-G?recki <marmarek@invisiblethingslab.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <20220407115414.GA4148@techsingularity.net>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 01:17:19PM +0200, Juergen Gross wrote:
> On 07.04.22 13:07, Michal Hocko wrote:
> > On Thu 07-04-22 12:45:41, Juergen Gross wrote:
> > > On 07.04.22 12:34, Michal Hocko wrote:
> > > > Ccing Mel
> > > > 
> > > > On Thu 07-04-22 11:32:21, Juergen Gross wrote:
> > > > > Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
> > > > > initialization") only zones with free memory are included in a built
> > > > > zonelist. This is problematic when e.g. all memory of a zone has been
> > > > > ballooned out.
> > > > 
> > > > What is the actual problem there?
> > > 
> > > When running as Xen guest new hotplugged memory will not be onlined
> > > automatically, but only on special request. This is done in order to
> > > support adding e.g. the possibility to use another GB of memory, while
> > > adding only a part of that memory initially.
> > > 
> > > In case adding that memory is populating a new zone, the page allocator
> > > won't be able to use this memory when it is onlined, as the zone wasn't
> > > added to the zonelist, due to managed_zone() returning 0.
> > 
> > How is that memory onlined? Because "regular" onlining (online_pages())
> > does rebuild zonelists if their zone hasn't been populated before.
> 
> The Xen balloon driver has an own callback for onlining pages. The pages
> are just added to the ballooned-out page list without handing them to the
> allocator. This is done only when the guest is ballooned up.
> 

Is this new behaviour? I ask because keeping !managed_zones out of the
zonelist and reclaim paths and the behaviour makes sense. Elsewhere you
state "zone can always happen to have no free memory left" and this is true
but it's usually a transient event. The difference between a populated
vs managed zone is usually permanent event where no memory will ever be
placed on the buddy lists because the memory was reserved early in boot
or a similar reason. The patch is probably harmless but it has the
potential to waste CPUs allocating or reclaiming from zones that will
never succeed.

-- 
Mel Gorman
SUSE Labs
