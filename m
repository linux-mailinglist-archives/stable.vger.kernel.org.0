Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037596A4888
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjB0Rr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 12:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjB0Rr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 12:47:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7652C1998;
        Mon, 27 Feb 2023 09:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C912B80D58;
        Mon, 27 Feb 2023 17:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CE3C4339B;
        Mon, 27 Feb 2023 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677520068;
        bh=DvG46GSct8ejJkcJckq54zAIl2grLPSZihgf4Ioz51I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKiob6bBYwVqkRSXCOT6fNR2EGw7bcaPwTHURL5h83uxDRWEtOew5AknDNkwCzWBg
         YKUYY1sTnTUK7+UwOs9W0jy0z5zZrBqef9kA+u2dsnRyeBjCIvqp0/24cYXDCfg+0x
         CUZCzSKqtzS3I7MfjpP03UIDSxNKSNY8LFZ0GkUGFSPBwQFjyEpIFKzj5qVHaMcQz4
         lDxcB0rn4uV/DKN+9/Z0J7Wr5fu5qAnM+eVq+aAg8801kQiasG+0nQLvR+ipppL+Kn
         IHhER6O49M2yH0eCWxRiLrVT+cHttko6G2u0C+CUIqJjTw2ZtopYE9la/V8qAMytKV
         A166262OFxSIQ==
Date:   Mon, 27 Feb 2023 09:47:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/zswi91axMN8OsA@sol.localdomain>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/y70zJj4kjOVfXa@sashalap>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 09:18:59AM -0500, Sasha Levin wrote:
> On Sun, Feb 26, 2023 at 11:24:36AM -0800, Eric Biggers wrote:
> > On Sat, Feb 25, 2023 at 09:30:37PM -0800, Eric Biggers wrote:
> > > On Sat, Feb 25, 2023 at 08:07:55PM -0800, Eric Biggers wrote:
> > > > On Sat, Feb 25, 2023 at 10:42:47PM -0500, Sasha Levin wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > >
> > > > > [ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]
> > > > >
> > > > > Now that the key associated with the "test_dummy_operation" mount option
> > > > > is added on-demand when it's needed, rather than immediately when the
> > > > > filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
> > > > > called from __put_super() to avoid a memory leak on mount failure.
> > > > >
> > > > > Remove this call, which was causing confusion because it appeared to be
> > > > > a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle reason).
> > > > >
> > > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > > Link: https://lore.kernel.org/r/20230208062107.199831-5-ebiggers@kernel.org
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > >
> > > > Why is this being backported?
> > > >
> > > > - Eric
> > > 
> > > BTW, can you please permanently exclude all commits authored by me from AUTOSEL
> > > so that I don't have to repeatedly complain about every commit individually?
> > > Especially when these mails often come on weekends and holidays.
> 
> Yup, no problem - I'll ignore any commits authored by you.
> 
> > > I know how to use Cc stable, and how to ask explicitly for a stable backport if
> > > I find out after the fact that one is needed.  (And other real people can always
> > > ask too... not counting AUTOSEL, even though you are sending the AUTOSEL emails,
> > > since clearly they go through no or very little human review.)
> 
> One of the challanges here is that it's difficult to solicit reviews or
> really any interaction from authors after a commit lands upstream. Look
> at the response rates to Greg's "FAILED" emails that ask authors to
> provide backports to commits they tagged for stable.

Well, it doesn't help that most of the stable emails aren't sent to the
subsystem's mailing list, but instead just to the individual people mentioned in
the commit.  So many people who would like to help never know about it.

> > > Of course, it's not just me that AUTOSEL isn't working for.  So, you'll still
> > > continue backporting random commits that I have to spend hours bisecting, e.g.
> > > https://lore.kernel.org/stable/20220921155332.234913-7-sashal@kernel.org.
> > > 
> > > But at least I won't have to deal with this garbage for my own commits.
> > > 
> > > Now, I'm not sure I'll get a response to this --- I received no response to my
> > > last AUTOSEL question at
> > > https://lore.kernel.org/stable/Y1DTFiP12ws04eOM@sol.localdomain.  So to
> > > hopefully entice you to actually do something, I'm also letting you know that I
> > > won't be reviewing any AUTOSEL mails for my commits anymore.
> > > 
> > 
> > The really annoying thing is that someone even replied to your AUTOSEL email for
> > that broken patch and told you it is broken
> > (https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org),
> > and ***you ignored it and applied the patch anyway***.
> > 
> > Why are you even sending these emails if you are ignoring feedback anyway?
> 
> I obviously didn't ignore it on purpose, right?
> 

I don't know, is it obvious?  You've said in the past that sometimes you'd like
to backport a commit even if the maintainer objects and/or it is known buggy.
https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org
also didn't explicitly say "Don't backport this" but instead "This patch has
issues", so maybe that made a difference?

Anyway, the fact is that it happened.  And if it happened in the one bug that I
happened to look at because it personally affected me and I spent hours
bisecting, it probably is happening in lots of other cases too.  So it seems the
process is not working...

Separately from responses to the AUTOSEL email, it also seems that you aren't
checking for any reported regressions or pending fixes for a commit before
backporting it.  Simply searching lore for the commit title
https://lore.kernel.org/all/?q=%22drm%2Famdgpu%3A+use+dirty+framebuffer+helper%22
would have turned up the bug report
https://lore.kernel.org/dri-devel/20220918120926.10322-1-user@am64/ that
bisected a regression to that commit, as well as a patch that Fixes that commit:
https://lore.kernel.org/all/20220920130832.2214101-1-alexander.deucher@amd.com/
Both of these existed before you even sent the AUTOSEL email!

So to summarize, that buggy commit was backported even though:

  * There were no indications that it was a bug fix (and thus potentially
    suitable for stable) in the first place.
  * On the AUTOSEL thread, someone told you the commit is broken.
  * There was already a thread that reported a regression caused by the commit.
    Easily findable via lore search.
  * There was also already a pending patch that Fixes the commit.  Again easily
    findable via lore search.

So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
wrong, it's not just a "mistake" but rather the process is the problem...

- Eric
