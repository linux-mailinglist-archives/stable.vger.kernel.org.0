Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F064F7D8D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiDGLJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiDGLJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:09:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C2681494;
        Thu,  7 Apr 2022 04:07:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 340A621118;
        Thu,  7 Apr 2022 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649329625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LE2tVt6E1/57kcFgpWdjdBQU6aDSlbFwP46O5S44+90=;
        b=Tp5lGLf1ElWVIcInGlUGAoJ1sx0YdUjQTq9tC8LzRgATKZFC9iS34ryFP2GTDsBD0Mirv1
        vRg/4eIJkZ5rGRuZIS6FxwFEhz62Vaik76t94HU2LQ2QePTUL26rXUg85lWH0KUDm4GPrG
        NFM/0kDfL93OeH1mpzliJJGkaQkmwQk=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E1E68A3B82;
        Thu,  7 Apr 2022 11:07:04 +0000 (UTC)
Date:   Thu, 7 Apr 2022 13:07:04 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-04-22 12:45:41, Juergen Gross wrote:
> On 07.04.22 12:34, Michal Hocko wrote:
> > Ccing Mel
> > 
> > On Thu 07-04-22 11:32:21, Juergen Gross wrote:
> > > Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
> > > initialization") only zones with free memory are included in a built
> > > zonelist. This is problematic when e.g. all memory of a zone has been
> > > ballooned out.
> > 
> > What is the actual problem there?
> 
> When running as Xen guest new hotplugged memory will not be onlined
> automatically, but only on special request. This is done in order to
> support adding e.g. the possibility to use another GB of memory, while
> adding only a part of that memory initially.
> 
> In case adding that memory is populating a new zone, the page allocator
> won't be able to use this memory when it is onlined, as the zone wasn't
> added to the zonelist, due to managed_zone() returning 0.

How is that memory onlined? Because "regular" onlining (online_pages())
does rebuild zonelists if their zone hasn't been populated before.

-- 
Michal Hocko
SUSE Labs
