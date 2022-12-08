Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D5647356
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 16:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHPk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 10:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLHPkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 10:40:16 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76934E5
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 07:40:14 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B8FdpFn004109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 8 Dec 2022 10:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1670513994; bh=69C163rhbG+6KT0oaec3E5RjFCQQ6U3oPgXAAoCstXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=BeMJDct5Nn8W9MUec75hie7Ta+R0uOft0TCOCl/sC3bcK+DINybV61quBWp8nBZY4
         n4CGvE7iGGGooOStJDw+FnCi0o8nOIDJ6ywuKahsQcKKwwqOHDp+5ytFDHqKLc5J8W
         GcRr1MP1Yc1S+lQoN7DTbAnRU1Vu6Y495zWSMvRA6zb3Q6FIf/JiwbZ+H3VFpztpDN
         OA+557NZqpE5oX/1/2FApRnBvoTqxygCmmm6TnRVEbct96OJhkt/HWyBT0ewze5pRF
         tdzMHCgdu6MulQa0iiQh50Sm+6OQm0TJpu7KxUPRkMmhlzUk2tveE9EtvdvS6CBAvQ
         24sb7Ae8c+2CA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D5B2015C39E4; Thu,  8 Dec 2022 10:39:51 -0500 (EST)
Date:   Thu, 8 Dec 2022 10:39:51 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Thilo Fromm <t-lo@linux.microsoft.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] ext4: Fix deadlock due to mbcache entry corruption
Message-ID: <Y5IFR4K9hO8ax1Y0@mit.edu>
References: <20221123193950.16758-1-jack@suse.cz>
 <20221201151021.GA18380@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <9c414060-989d-55bb-9a7b-0f33bf103c4f@leemhuis.info>
 <Y5F8ayz4gEtKn0LF@mit.edu>
 <20221208091523.t6ka6tqtclcxnsrp@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208091523.t6ka6tqtclcxnsrp@quack3>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 10:15:23AM +0100, Jan Kara wrote:
> > Furthermore, the fix which Jan provided, and which apparently fixes
> > the user's problem, (a) doesn't touch the ext4_bmap function, and (b)
> > has a fixes tag for the patch:
> > 
> >     Fixes: 6048c64b2609 ("mbcache: add reusable flag to cache entries")
> > 
> > ... which is a commit which dates back to 2016, and the v4.6 kernel.  ?!?
> 
> Yes. AFAICT the bitfield race in mbcache was introduced in this commit but
> somehow ext4 was using mbcache in a way that wasn't tripping the race.
> After 65f8b80053 ("ext4: fix race when reusing xattr blocks"), the race
> became much more likely and users started to notice...

Ah, OK.  And 65f8b80053 landed in 6.0, so while the bug may have been
around for much longer, this change made it much more likely that
folks would notice.  That's the missing piece and why Microsoft
started noticing this in their "Flatcar" container kernel.

So I'll update the commit description so that this is more clear, and
then I can figure out how to tell the regression-bot that the
regression should be tracked using commit 65f8b80053 instead of
51ae846cff5 ("ext4: fix warning in ext4_iomap_begin as race between
bmap and write").

Cheers, and thanks for the clarification,

					- Ted
