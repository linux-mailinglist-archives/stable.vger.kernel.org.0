Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447F8592CC8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 12:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiHOImG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 04:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiHOImF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 04:42:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174A920181;
        Mon, 15 Aug 2022 01:42:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9FF1534676;
        Mon, 15 Aug 2022 08:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660552922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LaVJUClI9pufMRMwnPQWm3K1AyxFVnORnC8zJHqqOH4=;
        b=iOYQ+Cdp6mqGSlymrQXIwUKqmslP9WpLTTHvWBeIesQiGIyIFrL4D42pWDUBDjPSui4x77
        rfXYBtJM/zds56D1KzpqS0WOxGXX00zyiPFb/Vp5HZWBX2UBNKetE2cfL7HqkII74Giu4a
        XB2/HnWmRGoM/+Y8gVPMrjnGv3OpEdI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 816E613A93;
        Mon, 15 Aug 2022 08:42:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R1tOHdoG+mLjRAAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 15 Aug 2022 08:42:02 +0000
Date:   Mon, 15 Aug 2022 10:42:01 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <YvoG2YeaiwYsxg9y@dhcp22.suse.cz>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
 <20220810140030.GA24195@lst.de>
 <YvP9YITH0RpgpblG@dhcp22.suse.cz>
 <20220811092911.GA22246@lst.de>
 <YvTRFxkmSuDAyVdI@dhcp22.suse.cz>
 <20220813062913.GA10523@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220813062913.GA10523@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 13-08-22 08:29:13, Christoph Hellwig wrote:
> On Thu, Aug 11, 2022 at 11:51:19AM +0200, Michal Hocko wrote:
> > this will not consider any gaps in the zone. We have zone_managed_pages
> > which tells you how many pages there are in the zone which have been
> > provided to the page allocator which seems like something that would fit
> > better. And it is also much better than basing it on the global amount
> > of memory which just doesn't make much sens for constrained zones
> 
> Yes, that is a much better helper.
> 
> > Except that it will not work for this case as
> > +static unsigned long calculate_pool_size(unsigned long zone_pages)
> > +{
> > +       unsigned long nr_pages = min_t(unsigned long,
> > +                                      zone_pages / (SZ_1G / SZ_128K),
> > +                                      MAX_ORDER_NR_PAGES);
> > +
> > +       return max_t(unsigned long, nr_pages << PAGE_SHIFT, SZ_128K);
> > +}
> > 
> > this will return 128kB, correct?
> 
> Yes.
> 
> > The DMA zone still has 126kB of usable memory. I think what you
> > want/need to do something like
> 
> No.  If you don't have 128k free you have another bug and we really
> should warn here.  Please go back to that system and figure out what
> uses up almost all of ZONE_DMA on that system, because we have another
> big problem there.

I do agree that such a large consumption from the DMA zone is unusual. I
have reached out to the original reporter and ask for help to
investigate more. Let's see whether we can get something out of that.
This can really reveal some DMA zone abuser.

Anyway, you seem to be not thrilled about the __GFP_NOWARN approach and
I won't push it. But is the existing inconsistency really desirable? I
mean we can get pretty vocal warning if the allocation fails but no
information when the zone doesn't have any managed memory. Why should we
treat them differently? 
-- 
Michal Hocko
SUSE Labs
