Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05C767B67B
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbjAYQCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 11:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbjAYQB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 11:01:59 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE92E4AA5D
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 08:01:58 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 30PG1VZq013098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 11:01:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1674662494; bh=7i8Vosf+jmkQ2rs9+yjxKCISD5twzSZjSXYA8Et3h3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=fV54YbA43J0TN1E9FOgxvkQYzPiox+eFM6rwoW8GAyuQ3HZQ8iRfDe5tL2jFajEpl
         Ka9M50T/1GmHBmg5dWQ1bvF5v0XH0VXKQztUEc7UBD9kxRYSnu3toI6OW1LyFSUWiT
         7KN4bZc3rpykGKNri7WU302rpumz8p8x8gI9jC0KPzckNBpdGqc2Er7EYEhSuHZBRS
         vHh8SFtAMWngjpFOFlROP2vkr3iGZijM667tsTVJRZdRcfw5fhY04zpM5g8vHb0QzH
         ia7i3oK1l0lMZensd6fSF+c4FoWAQkA+0JwFRcn/abwK74X4XhmNAvlgTT5ZlV8Bco
         /0V+7E65CFbMw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id BD1D015C469B; Wed, 25 Jan 2023 11:01:31 -0500 (EST)
Date:   Wed, 25 Jan 2023 11:01:31 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Jason Donenfeld <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 35/35] ext4: deal with legacy signed xattr
 name hash values
Message-ID: <Y9FSW2n1wPIwVjAN@mit.edu>
References: <20230124134131.637036-1-sashal@kernel.org>
 <20230124134131.637036-35-sashal@kernel.org>
 <CAHk-=wjZmzuHP10Trg_7EBnix4mFLfODPM+FsZz0Jjj+YAFDeg@mail.gmail.com>
 <CAHk-=wi5GPS3poC_YRy93X38AqkvsFENAviMXHWjgOgo5k7p3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi5GPS3poC_YRy93X38AqkvsFENAviMXHWjgOgo5k7p3g@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 09:23:56AM -0800, Linus Torvalds wrote:
> On Tue, Jan 24, 2023 at 8:50 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This patch does not work correctly without '-funsigned-char', and I
> > don't think that has been back-ported to stable kernels.
> >
> > That said, the patch *almost* works.
> 
> So I'm  not convinced this should be back-ported at all, but it's
> certainly true that going back and forth between the two cases would
> be problematic.

Yeah, I wouldn't backport this patch, since it also requires changes
to e2fsprogs that will take a while to propagate to stable distributions.

   	     	       	      	       		 - Ted
