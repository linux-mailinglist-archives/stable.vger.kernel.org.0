Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACBB6B5C96
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCKOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCKOGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B594E9F3B;
        Sat, 11 Mar 2023 06:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE3260C3D;
        Sat, 11 Mar 2023 14:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B566EC433D2;
        Sat, 11 Mar 2023 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678543569;
        bh=K8EAh0QfxzkdULHNSkhCoqGD46lp5v3W4c/Rtfq8ViQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=exnwTTc6fBCxAaB3HtIEtgkhL7325m54NsIZCp8+sq9Z8NIOFUxOfVEzatH+WHnPm
         KRsmDqAdMXt5FSPI/C5EII1SgRh+jV1y7uIKb1KgqO2WuUlTKrMYcePsqsyReVIhgN
         7pX8RuuxTnjyGC5HyvJrSL9RbPLlYt6u03S/DeAMn1tRo99N3GOOFf+/KDSA3PSf6y
         b2Dg49sNM+eNbaIYuvJGRnr407wn8M1xj8iR22NFs9R66K1zVNYuM7zE3ARl19zeeP
         zNZ2QuLNOwdNK6YIzxsORzicdQN3whnX+Xifm+K7/1zarBhsPJ1BASppKO0NExRtiD
         6d9kZOJ+wX35w==
Date:   Sat, 11 Mar 2023 09:06:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAyK0KM6JmVOvQWy@sashalap>
References: <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAwe95meyCiv6qc4@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 06:25:59AM +0000, Matthew Wilcox wrote:
>On Tue, Mar 07, 2023 at 09:45:24PM +0000, Eric Biggers wrote:
>> On Tue, Mar 07, 2023 at 10:18:35PM +0100, Pavel Machek wrote:
>> > I believe that -stable would be more useful without AUTOSEL process.
>>
>> There has to be a way to ensure that security fixes that weren't properly tagged
>> make it to stable anyway.  So, AUTOSEL is necessary, at least in some form.  I
>> think that debating *whether it should exist* is a distraction from what's
>> actually important, which is that the current AUTOSEL process has some specific
>> problems, and these specific problems need to be fixed...
>
>I agree with you, that we need autosel and we also need autosel to
>be better.  I actually see Pavel's mail as a datapoint (or "anecdote",
>if you will) in support of that; the autosel process currently works
>so badly that a long-time contributor thinks it's worse than nothing.
>
>Sasha, what do you need to help you make this better?

What could I do to avoid this?

I suppose that if I had a way to know if a certain a commit is part of a
series, I could either take all of it or none of it, but I don't think I
have a way of doing that by looking at a commit in Linus' tree
(suggestions welcome, I'm happy to implement them).

Other than that, the commit at hand:

1. Describes a real problem that needs to be fixed, so while it was
reverted for a quick fix, we'll need to go back and bring it in along
with it's dependency.

2. Soaked for over two weeks between the AUTOSEL mails and the release,
gone through multiple rounds of reviews.

3. Went through all the tests provided by all the individuals, bots,
companies, etc who test the tree through multiple rounds of testing (we
had to do a -rc2 for that releases).

4. Went through whatever tests distros run on the kernel before they
package and release it.

-- 
Thanks,
Sasha
