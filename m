Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8496A4F0F
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 23:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjB0W7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 17:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0W7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 17:59:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9849415C9A;
        Mon, 27 Feb 2023 14:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=G9bSBOaW5xZ1aVJGdVmF+Qmm4UPSmxUE9dNZppXZpcs=; b=r6fKG65n2h7K6dm9AHnap2xrXi
        kj8tM4Vztjv9llz94K/xWerOkOusNzIr+RZb2pYLG8K2Ov8KwREGSC7D72KvyltW69WZ5210Saen1
        f+DNeo7vIqdLL4xH2YpEcqTA3541OQZwjyqjr5oxBPSvPFwgGWXgQ0jaGsWxa6tyhUGPYeNBJudQp
        p0XL2brhM3RlHlbJjl+c3DNi/HXgkFBzwN8Y4xRA84nQ3TDA9baVWEjm6PY2TYD0tRQZ232SqSnvd
        6rknbPw1IlKiM8lufi97NFjUvBHLDP7a8LSKVpFCIBcAmWtt8lvG9njnHOh+/HswqsCgF7rOLMCOT
        zB1s44WA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pWmSt-000SVK-JZ; Mon, 27 Feb 2023 22:59:27 +0000
Date:   Mon, 27 Feb 2023 22:59:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/01z4EJNfioId1d@casper.infradead.org>
References: <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/0wMiOwoeLcFefc@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 05:35:30PM -0500, Sasha Levin wrote:
> On Mon, Feb 27, 2023 at 09:38:46PM +0000, Eric Biggers wrote:
> > Just because you can't be 100% certain whether a commit is a fix doesn't mean
> > you should be rushing to backport random commits that have no indications they
> > are fixing anything.
> 
> The difference in opinion here is that I don't think it's rushing: the
> stable kernel rules say a commit must be in a released kernel, while the
> AUTOSEL timelines make it so a commit must have been in two released
> kernels.

Patches in -rc1 have been in _no_ released kernels.  I'd feel a lot
better about AUTOSEL if it didn't pick up changes until, say, -rc4,
unless they were cc'd to stable.

> > Nothing has changed, but that doesn't mean that your process is actually
> > working.  7 days might be appropriate for something that looks like a security
> > fix, but not for a random commit with no indications it is fixing anything.
> 
> How do we know if this is working or not though? How do you quantify the
> amount of useful commits?

Sasha, 7 days is too short.  People have to be allowed to take holiday.

> I'd love to improve the process, but for that we need to figure out
> criteria for what we consider good or bad, collect data, and make
> decisions based on that data.
> 
> What I'm getting from this thread is a few anecdotal examples and
> statements that the process isn't working at all.
> 
> I took Jon's stablefixes script which he used for his previous articles
> around stable kernel regressions (here:
> https://lwn.net/Articles/812231/) and tried running it on the 5.15
> stable tree (just a random pick). I've proceeded with ignoring the
> non-user-visible regressions as Jon defined in his article (basically
> issues that were introduced and fixed in the same releases) and ended up
> with 604 commits that caused a user visible regression.
> 
> Out of those 604 commits:
> 
>  - 170 had an explicit stable tag.
>  - 434 did not have a stable tag.

I think a lot of people don't realise they have to _both_ put a Fixes
tag _and_ add a Cc: stable.  How many of those 604 commits had a Fixes
tag?

