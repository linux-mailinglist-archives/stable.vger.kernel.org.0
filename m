Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8A6B5F8B
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCKSHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCKSHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:07:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F056F591FA;
        Sat, 11 Mar 2023 10:07:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8605B60DDB;
        Sat, 11 Mar 2023 18:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD043C433EF;
        Sat, 11 Mar 2023 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678558030;
        bh=y9LAEZUH0SBqtIwhQ/pvz04mJb1cBc4uT0VPORKHNew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xf/N3Wpli0HJECACmXpGBz7O1TtuPd5TwQk33WRZVfrCaIu3U8ffGRihrPrhpAqlH
         Hm0UbfeOd948SlaCWxX/oPLDvnW2stT+1bf5HXXYLlh2wF/qKHNUfLYIBgwOtwK3Hh
         yRuU42EJi2wCLgJZlSVLUqF5Y+/80zew4LxNMpfVz/IQSIzBQqApUG5QYojFASeCfU
         4x7EusH1u384BrZkU2J95pHU1PyojidbSNPDGAopFNENzOESPLCvc2s3y594354IAP
         ikj2vBVBp1W6OTmeg/I+/ygxNpFGYCbnVpe2Z0NXaiT0UQZ9K54s2SK5K2v9KL4xIl
         kn3fTPODQ04OA==
Date:   Sat, 11 Mar 2023 13:07:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzDTVluocRvZ8W8@sashalap>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <ZAu4GE0q4jzRI+F6@sol.localdomain>
 <ZAyFFtORBosdarMr@sashalap>
 <734c9a0920f293c88168f38c1245e779d03f4364.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <734c9a0920f293c88168f38c1245e779d03f4364.camel@HansenPartnership.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:54:36AM -0500, James Bottomley wrote:
>On Sat, 2023-03-11 at 08:41 -0500, Sasha Levin wrote:
>> On Fri, Mar 10, 2023 at 03:07:04PM -0800, Eric Biggers wrote:
>> > On Mon, Feb 27, 2023 at 07:41:31PM -0800, Eric Biggers wrote:
>> > >
>> > > Well, probably more common is that prerequisites are in the same
>> > > patchset, and the prerequisites are tagged for stable too. 
>> > > Whereas AUTOSEL often just picks patch X of N.  Also, developers
>> > > and maintainers who tag patches for stable are probably more
>> > > likely to help with the stable process in general and make sure
>> > > patches are backported correctly...
>> > >
>> > > Anyway, the point is, AUTOSEL needs to be fixed to stop
>> > > inappropriately cherry-picking patch X of N so often.
>> > >
>> >
>> > ... and AUTOSEL strikes again, with the 6.1 and 6.2 kernels
>> > currently crashing whenever a block device is removed, due to
>> > patches 1 and 3 of a 3-patch series being AUTOSEL'ed (on the same
>> > day I started this discussion, no less):
>> >
>> > https://lore.kernel.org/linux-block/CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com/T/#u
>> >
>> > Oh sorry, ignore this, it's just an anecdotal example.
>>
>> Yes, clearly a problem with AUTOSEL and not with how sad the testing
>> story is for stable releases.
>
>Hey, that's a completely circular argument:  if we had perfect testing
>then, of course, it would pick up every bad patch before anything got
>released; but we don't, and everyone knows it.  Therefore, we have to
>be discriminating about what patches we put in.  And we have to
>acknowledge that zero bugs in patches isn't feasible in spite of all
>the checking we do do.  I also think we have to acknowledge that users
>play a role in the testing process because some bugs simply aren't
>picked up until they try out a release.  So discouraging users from
>running mainline -rc's means we do get bugs in the released kernel that
>we might not have had if they did.  Likewise if everyone only runs
>stable kernels, the bugs in the released kernel don't get found until
>stable.  So this blame game really isn't helping.
>
>I think the one thing everyone on this thread might agree on is that
>this bug wouldn't have happened if AUTOSEL could detect and backport
>series instead of individual patches.  Sasha says that can't be done
>based on in information in Linus' tree[1] which is true but not a
>correct statement of the problem.  The correct question is given all
>the information available, including lore, could we assist AUTOSEL in
>better detecting series and possibly making better decisions generally?

My argument was that this type of issue is no AUTOSEL specific, and we
saw it happening multiple times with stable tagged patches as well.

It's something that needs to get solved, and I suspect that both Greg
and myself will end up using it when it's there.

>I think that's the challenge for anyone who actually wants to help
>rather than complain.  At least the series detection bit sounds like it
>could be a reasonable summer of code project.

Right - I was trying to reply directly to Willy's question: this is
something very useful, somewhat hard, and I don't think I could do in
the near future - so help is welcome here.

-- 
Thanks,
Sasha
