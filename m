Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D924361309C
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJaGnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJaGnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:43:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEEF9FCE;
        Sun, 30 Oct 2022 23:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE2BFCE11AA;
        Mon, 31 Oct 2022 06:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DB4C433C1;
        Mon, 31 Oct 2022 06:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198591;
        bh=/uOymnmq3L0wCgzh9UenzjngMO5eZ7weW3tXKMXj070=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnApzoz5nPHjOYu3jOox7h9Lx3FxN9woN1z98MN+I2PZkjErP1pHDyzIlHHIoQPFi
         UKgmo1t3281lBCpYm6fYM21XJFDLLwJ8hT8FZK1ZFthzmoIN2oQvh1t6jh+Y1zlICD
         YredZBbU5ah/QSBt5XVbhG7kJm6Z3qC7ju+WAyz8=
Date:   Mon, 31 Oct 2022 07:44:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Seth Jennings <sjenning@redhat.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [PATCH 6.0 19/20] mm/huge_memory: do not clobber swp_entry_t
 during THP split
Message-ID: <Y19utwpTpppwnQeS@kroah.com>
References: <20221024112934.415391158@linuxfoundation.org>
 <20221024112935.173960536@linuxfoundation.org>
 <f6d7b68a-a5ae-2f85-49b7-f4666eb3a8c9@google.com>
 <Y1gHmy6g0SMFXH5k@kroah.com>
 <11bd36e-eff1-ca79-fa48-f32ba815523@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11bd36e-eff1-ca79-fa48-f32ba815523@google.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 29, 2022 at 08:33:01PM -0700, Hugh Dickins wrote:
> On Tue, 25 Oct 2022, Greg Kroah-Hartman wrote:
> > On Tue, Oct 25, 2022 at 08:11:44AM -0700, Hugh Dickins wrote:
> > > On Mon, 24 Oct 2022, Greg Kroah-Hartman wrote:
> > > > From: Mel Gorman <mgorman@techsingularity.net>
> > > > 
> > > > commit 71e2d666ef85d51834d658830f823560c402b8b6 upstream.
> > > >...
> > > 
> > > Greg, this patch from Mel is important,
> > > but introduces a warning which is giving Tvrtko trouble - see linux-mm
> > > https://lore.kernel.org/linux-mm/1596edbb-02ad-6bdf-51b8-15c2d2e08b76@linux.intel.com/
> > > 
> > > We already have the fix for the warning, it's making its way through the
> > > system, and is marked for stable, but it has not reached Linus's tree yet.
> > > 
> > > Please drop this 19/20 from 6.0.4, then I'll reply to this to let you know
> > > when the fix does reach Linus's tree - hopefully the two can go together
> > > in the next 6.0-stable.
> > > 
> > > I apologize for not writing yesterday: gmail had gathered together
> > > different threads with the same subject, I thought you and stable
> > > were Cc'ed on the linux-mm mail and you would immediately drop it
> > > yourself, but in fact you were not on that thread at all.
> > 
> > No worries, now dropped, thanks.
> 
> Thanks Greg.  Linus's tree now contains my fix
> 5aae9265ee1a ("mm: prep_compound_tail() clear page->private")
> to Mel's fix
> 71e2d666ef85 ("mm/huge_memory: do not clobber swp_entry_t during THP split")
> so they can now go on together into 6.0 stable.
> 
> They would also have been good in 5.19 stable: but too late now, it's EOL.

Thanks, both now queued up for 6.0

greg k-h
