Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C04D6B6A64
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 20:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCLTDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 15:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCLTDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 15:03:52 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C322011
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 12:03:50 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32CJ3SUf029215
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 15:03:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678647811; bh=OJuYO4tozYlkTKxvUkr6Yt6qnK4hR1f0ZSLZY8hmY1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=V5dwUF81CQBKvYHsSZ5QfTvJo2k6iAiGtbtI49IZ1D3c9Vka5ZK75s4p9w3nXlAcZ
         fEBlUgU6QCLp/uztFdbpriJpK7O6aTyc92cmjPfzW//IZXFd1eWe+G+dmlB/Mq+TMf
         A3PDHuCM304ko64acUuToofb1zfLX9Va1Zkw7JrXmMoo3VDDhAn+NFLjXCX3GPE5yg
         rPhN7vl7/fTtjtBrVnMzpiW0ad0P5YzDhLuhcqaUjQ30pzNXAQWMGKqMw5PsVe9M7x
         tFdzlMsFOkSBOfrwZYqDs0dRZbdmErQZp8JbRhUp99AxG0L1B9nVLUIgdUSLye1FcQ
         t7yw4GBVuGRMA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8ADC315C45B9; Sun, 12 Mar 2023 15:03:28 -0400 (EDT)
Date:   Sun, 12 Mar 2023 15:03:28 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <20230312190328.GL860405@mit.edu>
References: <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <ZAu4GE0q4jzRI+F6@sol.localdomain>
 <ZAyFFtORBosdarMr@sashalap>
 <734c9a0920f293c88168f38c1245e779d03f4364.camel@HansenPartnership.com>
 <ZAzDTVluocRvZ8W8@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzDTVluocRvZ8W8@sashalap>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 01:07:09PM -0500, Sasha Levin wrote:
> > I think the one thing everyone on this thread might agree on is that
> > this bug wouldn't have happened if AUTOSEL could detect and backport
> > series instead of individual patches.  Sasha says that can't be done
> > based on in information in Linus' tree[1] which is true but not a
> > correct statement of the problem.  The correct question is given all
> > the information available, including lore, could we assist AUTOSEL in
> > better detecting series and possibly making better decisions generally?
> 
> My argument was that this type of issue is no AUTOSEL specific, and we
> saw it happening multiple times with stable tagged patches as well.

I suspect that it happens *less* with Greg's patches, since the people
who add (and it's almost always remove) the Cc: tags have the
dependency information fresh in their brains' caches, and are more
likely to correctly tag which patches should and shouldn't have Cc:
stable tags.

Now, if after I've carefully annotated a patch series, some with Cc:
stable tags, and some without, and AUTOSEL were to override my work
and take some extra patches, that I had deliberately not tagged with
Cc: stable, I can (and have) gotten mildly annoyed, but in general, it
means that something which probably shouldn't and didn't need to go
into an LTS kernel ended up going into an LTS kernel, and TBH, when
this has happened, I don't worry about it *too* much.  It probably has
made LTS less sstable when this happens, but it's generally not a
disaster.

In any case, I think the problem of missing dependencies when they are
in a patch series is *primarily* an AUTOSEL problem, and as I said,
probably can be fixed by using the information in lore.

I'll note that we can probably make the "was this part of the patch
series" work even better by encouraging contributors not to take
unrelated patches and put them unnecessarily into a patch series.  So
if I knew that the stable bots were taking patch series into account,
or were about to start taking advantage of this signal, I'd be happy
to push back on contributors to break up patch series that should be
glommed together.

						- Ted
