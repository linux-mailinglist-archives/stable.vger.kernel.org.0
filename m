Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38C46860ED
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjBAHrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjBAHrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:47:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC06410A6;
        Tue, 31 Jan 2023 23:47:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1FAD033A60;
        Wed,  1 Feb 2023 07:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675237624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rag4+FVyQt+kbt+JWKoNP9ZXlNOyifoM2qoNM7/cbKQ=;
        b=q+FgXzsqSM00LgMQan9vaaEXqlLYtc39atFGGec47oO/dep2GxG3uC3mt7DIHUTOIWdkw1
        FBrp/4LCISKSJ02+H7YKRpfIvcf3KzxQiwGCfVbQ8p4KdAsm7hDwvAhChgReGXdUymbUjC
        ALBLw81YylNVAYiWf8uNsUSUkNUatjg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F21511348C;
        Wed,  1 Feb 2023 07:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jMbZOPcY2mP8NAAAMHmgww
        (envelope-from <mhocko@suse.com>); Wed, 01 Feb 2023 07:47:03 +0000
Date:   Wed, 1 Feb 2023 08:47:03 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
 <Y9g/70m15SwxkLfc@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9g/70m15SwxkLfc@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 30-01-23 14:08:47, Mike Kravetz wrote:
> On 01/30/23 13:36, Michal Hocko wrote:
> > On Fri 27-01-23 17:12:05, Mike Kravetz wrote:
> > > On 01/27/23 15:04, Andrew Morton wrote:
> > > > On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> > > > > On 26.01.23 23:27, Mike Kravetz wrote:
> > 
> > Yes, this looks simple enough. My only concern would be that this
> > special casing might be required on other places which is hard to
> > evaluate. I thought PSS reported by smaps would be broken as well but it
> > seems pss is not really accounted for hugetlb mappings at all.
> > 
> > Have you tried to look into {in,de}creasing the map count of the page when
> > the the pte is {un}shared for it?
> 
> A quick thought is that it would not be too difficult.  It would need
> to include the following:
> - At PMD share time in huge_pmd_share(),
>   Go through all entries in the PMD, and increment map and ref count for
>   all referenced pages.  huge_pmd_share is just adding another sharing
>   process.
> - At PMD unshare time in huge_pmd_unshare(),
>   Go through all entries in the PMD, and decrement map and ref count for
>   all referenced pages.  huge_pmd_unshare is just removing one sharing
>   process.
> - At page fault time, check if we are adding a new entry to a shared PMD.
>   If yes, add 'num_of_sharing__processes - 1' to the ref and map count.
> 
> In each of the above operations, we are holding the PTL lock (which is
> really the split/PMD lock) so synchronization should not be an issue.
> 
> Although I mention processes sharing the PMD above, it is really mappings/vmas
> sharing the PMD.  You could have two mappings of the same object in the same
> process sharing PMDs.
> 
> I'll code this up and see how it looks.

Thanks!
 
> However, unless you have an objection I would prefer the simple patches
> move forward, especially for stable backports.

Yes, the current patch is much simpler and more suitable for stable
backports. If the explicit map count modifications are not all that
terrible then this would sound like a more appropriate long term plan
though.

Thanks!
-- 
Michal Hocko
SUSE Labs
