Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A677C6468CC
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 06:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLHF4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 00:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLHF4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 00:56:13 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E6D99F01
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 21:56:12 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B85ttmH006911
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 8 Dec 2022 00:55:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1670478958; bh=+3dywkpkrOoRJwylUGWYlpKX7eTBtD29D+MvYyMmYlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=oop/hXe1d/4vTfrwLTpJndCAjT1vK5Zx8+SU6l4ZYbN8dpMCxeTV+Ze2ijbNlsn8L
         1wvCvZ53mhgxe3ynaLLEOnGXpIsEaxw+8AQGFnyf00vz5xho6Y7ImrWY6XFjD1cRt4
         aCTGB0oUIzbDUu0mEVkdmsCEpihCP872I2eO5P9w3N88tXe0anO6+PdD90WjGoYi1N
         sEtqwEFjxCifgHY5WNGtQFKsG2eDkEUkDwLDXxVRVX5BUkb1iuM7KgfBkQSuk9d7rJ
         3+Hz7vNv/ny40Rx32qTLfOsi1T5RAdoodG+CZg5b6tI9P0f9dHqWMp6i/bnlN1QStK
         gJhJ6faSVjqAA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6927915C39E4; Thu,  8 Dec 2022 00:55:55 -0500 (EST)
Date:   Thu, 8 Dec 2022 00:55:55 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <Y5F8ayz4gEtKn0LF@mit.edu>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 04:41:49PM +0100, Thorsten Leemhuis wrote:
> 
> Jan's patch to fix the regression is now our 12 days out and afaics
> didn't make any progress (or did I miss something?). Is there are reason
> why or did it simply fall through the cracks? Just asking, because it
> would be good to finally get this resolved.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

This patch showed up right before the Thanksgiving holiday, and (b) it
just missed Q/A cutoff for the the ext4 bugfix pull request which I
sent to Linus right before I went on my Thanksgiving break.

Since Thanksgiving, I've been busy with the realities of corporate
life --- end of year performance evaluations, preparing for 2023
roadmap reviews with management, etc.  So the next pull request I was
planning to send to Linus is when the merge window opens, and I'm
currently processing patches and running Q/A to be ready for the
opening of that merge window.


One thing which is completely unclear to me is how this relates to the
claimed regression.  I understand that Jeremi and Thilo have asserted
that the hang goes away if a backport commit 51ae846cff5 ("ext4: fix
warning in ext4_iomap_begin as race between bmap and write") is not in
their 5.15 product tree.

However, the stack traces point to a problem in the extended attribute
code, which has nothing to do with ext4_bmap(), and commit 51ae846cff5
only changes the ext4's bmap function --- which these days gets used
for the FIBMAP ioctl and very little else.

Furthermore, the fix which Jan provided, and which apparently fixes
the user's problem, (a) doesn't touch the ext4_bmap function, and (b)
has a fixes tag for the patch:

    Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")

... which is a commit which dates back to 2016, and the v4.6 kernel.  ?!?

So at this point, I have no idea whether or not this is a regression
or not, but we'll get the fix to Linus soon.

Cheers,

	   	    	      	      	 - Ted
