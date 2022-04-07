Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC94F7E5B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiDGLuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244962AbiDGLuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:50:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A661728BA;
        Thu,  7 Apr 2022 04:48:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A5A361F859;
        Thu,  7 Apr 2022 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649332090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hzzsqE3lHhZNTb0uSMaOKkro2CJhyy2oCUvOJqbqZYE=;
        b=LRhI4GBAtx/ASTu7jlVvYU6iX4vVt2LFIwag927OFBVZh0Lr1jMIOfEGw9c9SxZNVzFQha
        xg7kb97zo3WZEJKBe2Wv6WIhoduV9gMh9VFa634GDpd0fIs7PH2Z4rZb+cA1AixjYxlkAm
        hEI1iPyd5PLXUAREH5GDnfoMbvX/Fgk=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 74176A3B88;
        Thu,  7 Apr 2022 11:48:10 +0000 (UTC)
Date:   Thu, 7 Apr 2022 13:48:09 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <Yk7PeQ8sClX5VVWa@dhcp22.suse.cz>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-04-22 13:40:25, Michal Hocko wrote:
[...]
> Now to your patch. I suspect this is not sufficient for the full hotplug
> situation. Consider a new NUMA node to be hotadded. hotadd_new_pgdat
> will call build_all_zonelists but the zone is not populated yet at that
> moment unless I am missing something. We do rely on online_pages to
> rebuild once pages are onlined - which usually means they are freed to
> the page allocator.

OK, I've managed to get lost in the code and misread the onlining part.
After re-reading the code I have concluded that the patch is good as is.
online_pages relies on zone_populated so it will pass and zonelists will
be regenerated even without any pages freed to the allocator. Sorry for
the confusion. But I guess this still proves my other point that the
code is really subtle and messy so I guess the less rebuilding we do the
better. There are two ways, go with your patch and do the clean up on
top or merge the two.

That being said
Acked-by: Michal Hocko <mhocko@suse.com>
to your patch with an improved changelog to be more specific about the
underlying problem.

Thanks and sorry for the confusion.
-- 
Michal Hocko
SUSE Labs
