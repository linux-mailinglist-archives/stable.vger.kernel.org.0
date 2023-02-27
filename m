Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE3F6A4D60
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 22:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjB0VjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 16:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB0VjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 16:39:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7C011E99;
        Mon, 27 Feb 2023 13:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602EF60F24;
        Mon, 27 Feb 2023 21:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2AC433EF;
        Mon, 27 Feb 2023 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677533938;
        bh=EBtrrhdOA19NAE5/F2Y67XUzzeFr0UMRVBaiZBpadlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UrK8XdZPRsgi/trfsLijsvyMoNTiqeoDwBqSSl6iGjynEFSkCWC0RDLdgPUlDUXd+
         N17/Y2vpMMK1klEEMpsSoCDlFXbk8vG0JF/Q0wgbURSzuFMNS3S6G2eyPVcZRVD2zH
         1CfNDZIlpntqAb2E08bXqhCRRkJgGaLvSq1Lj3HbM7927opG/N5sXDD2sR4YQTDTHV
         88W/qkYwH9IMedSU2NpNMjFM9bAzPhTRpxQLSJZCx5+s/f5n1lQZrGa1CpRpYnQOo3
         HEFSebxafPkkog4GXiQY9aegQxFnYKrIar4Un21/AADVfMUIVn9HolKxxSoWwUSo8p
         9frMz2ZjuZYkg==
Date:   Mon, 27 Feb 2023 21:38:46 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/0i5pGYjrVw59Kk@gmail.com>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/0U8tpNkgePu00M@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 03:39:14PM -0500, Sasha Levin wrote:
> > > So to summarize, that buggy commit was backported even though:
> > > 
> > >   * There were no indications that it was a bug fix (and thus potentially
> > >     suitable for stable) in the first place.
> > >   * On the AUTOSEL thread, someone told you the commit is broken.
> > >   * There was already a thread that reported a regression caused by the commit.
> > >     Easily findable via lore search.
> > >   * There was also already a pending patch that Fixes the commit.  Again easily
> > >     findable via lore search.
> > > 
> > > So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
> > > wrong, it's not just a "mistake" but rather the process is the problem...
> > 
> > BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
> > only being in mainline for 4 days, and *released* in all LTS kernels after only
> > being in mainline for 12 days.  Surely that's a timeline befitting a critical
> > security vulnerability, not some random neural-network-selected commit that
> > wasn't even fixing anything?
> 
> I would love to have a mechanism that tells me with 100% confidence if a
> given commit fixes a bug or not, could you provide me with one?

Just because you can't be 100% certain whether a commit is a fix doesn't mean
you should be rushing to backport random commits that have no indications they
are fixing anything.

> w.r.t timelines, this is something that was discussed on the mailing
> list a few years ago where we decided that giving AUTOSEL commits 7 days
> of soaking time is sufficient, if anything changed we can have this
> discussion again.

Nothing has changed, but that doesn't mean that your process is actually
working.  7 days might be appropriate for something that looks like a security
fix, but not for a random commit with no indications it is fixing anything.

BTW, based on that example it's not even 7 days between AUTOSEL and patch
applied, but actually 7 days from AUTOSEL to *release*.  So e.g. if someone
takes just a 1 week vacation, in that time a commit they would have NAK'ed can
be AUTOSEL'ed and pushed out across all LTS kernels...

> Note, however, that it's not enough to keep pointing at a tiny set and
> using it to suggest that the entire process is broken. How many AUTOSEL
> commits introduced a regression? How many -stable tagged ones did? How
> many bugs did AUTOSEL commits fix?

So basically you don't accept feedback from individual people, as individual
people don't have enough data?

- Eric
