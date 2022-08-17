Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31245969B1
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiHQGnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 02:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHQGnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 02:43:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B89FD59;
        Tue, 16 Aug 2022 23:43:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5ECD133F60;
        Wed, 17 Aug 2022 06:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660718591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qNjnS8dkYrVx57dCFrcvWi3o+HcOg8Plt9Rk0mW0V5U=;
        b=lqZJTTtNvjfmP3L+oaeLOD6m9w+wGIr5wO2b5PKdoS0Z6+qN+lCgSjCh/6IoixcnRHIsmO
        ReaYsvnR1jqrKlVHX/8qBiMIMh5YjXHvVB7Y9KLDUhoE6+0L81EHG0e2bhj6TMzeZvC5k3
        YtR0yd45MELEd9H59XbjnTFUhEEc+Rg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 41B4313A8E;
        Wed, 17 Aug 2022 06:43:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OD3fDf+N/GJ+LQAAMHmgww
        (envelope-from <mhocko@suse.com>); Wed, 17 Aug 2022 06:43:11 +0000
Date:   Wed, 17 Aug 2022 08:43:10 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <YvyN/vI7+cTv0geS@dhcp22.suse.cz>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
 <20220810140030.GA24195@lst.de>
 <YvP9YITH0RpgpblG@dhcp22.suse.cz>
 <20220811092911.GA22246@lst.de>
 <YvTRFxkmSuDAyVdI@dhcp22.suse.cz>
 <20220813062913.GA10523@lst.de>
 <YvoG2YeaiwYsxg9y@dhcp22.suse.cz>
 <20220817060045.GA29227@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817060045.GA29227@lst.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 17-08-22 08:00:45, Christoph Hellwig wrote:
> On Mon, Aug 15, 2022 at 10:42:01AM +0200, Michal Hocko wrote:
> > Anyway, you seem to be not thrilled about the __GFP_NOWARN approach and
> > I won't push it. But is the existing inconsistency really desirable? I
> > mean we can get pretty vocal warning if the allocation fails but no
> > information when the zone doesn't have any managed memory. Why should we
> > treat them differently? 
> 
> How could we end up having ZONE_DMA without any managed memory to start
> with except for the case where the total memory is smaller than what
> fits into ZONE_DMA?  If we have such a case we really should warn about
> it as well.

This can be an early memory reservation from this physical address
range. My original report http://lkml.kernel.org/r/Yj28gjonUa9+0yae@dhcp22.suse.cz
was referring to such a system (a different one than what I am dealing
with now): present:636kB managed:0kB

There is only 636kB present in that ZONE_DMA physical range but nothing
has made it to the page allocator in the end.

-- 
Michal Hocko
SUSE Labs
