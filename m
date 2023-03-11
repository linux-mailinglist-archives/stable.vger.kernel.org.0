Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236666B604F
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 20:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjCKTqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 14:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKTqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 14:46:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC4A6E6A3;
        Sat, 11 Mar 2023 11:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED85DB80749;
        Sat, 11 Mar 2023 19:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A767C4339C;
        Sat, 11 Mar 2023 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678563967;
        bh=GgFeoExWmv/QOgnHi0mtHAxH4/QAUnv3/xGE2CsTg+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uoS5Jdx2Y9UaguI17Jk1QdjVwwOyHTZcL5Or4l66Tlp3nJ5wk1lOXHZ9VnU9WiqYW
         OnRJgo7NVph67QzjW0q3E7SO6U1fHmz3NUsU/IdCwtou7tfq1LPtBDOBJljaGE4kEH
         8+S/9Aojmr9rDlL1vWXKTexhPOM5g6dyquZkDI7JRw7jchbote5xe/o/6cbb3yvTnO
         /BdlV7PFbs9E/4WSqpPShB2UWUkOyW4McFrQjx96wGxjwr3vMP5x87yFRSGsqy6f/B
         GyEkfhMPz/VmyJKLAnWPPYrxny4xOzUpdTHF+FLtTQyGCheNDv+KBh0um2TUOv8Vl4
         K6rSWfSwsk7Zg==
Date:   Sat, 11 Mar 2023 11:46:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzafagDchRQRxWi@sol.localdomain>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzVbzthi8IfptFZ@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 11:24:31AM -0800, Eric Biggers wrote:
> On Sat, Mar 11, 2023 at 07:33:58PM +0100, Willy Tarreau wrote:
> > On Sat, Mar 11, 2023 at 09:48:13AM -0800, Eric Biggers wrote:
> > > The purpose of all these mailing list searches would be to generate a list of
> > > potential issues with backporting each commit, which would then undergo brief
> > > human review.
> > 
> > This is one big part that I suspect is underestimated. I'll speak from my
> > past experience maintaining extended LTS for 3.10. I couldn't produce as
> > many releases as I would have liked to because despite the scripts that
> > helped me figure some series, some dependencies, origin branches etc, the
> > whole process of reviewing ~600 patches to end up with ~200 at the end
> > (and adapting some of them to fit) required ~16 hours a day for a full
> > week-end, and I didn't always have that amount of time available. Any my
> > choices were far from being perfect, as during the reviews I got a number
> > of "please don't backport this there" and "if you take this one you also
> > need these ones". Also I used to intentionally drop what had nothing to
> > do on old LTS stuff so even from that perspective my work could have been
> > perceived as insufficient.
> > 
> > The reviewing process is overwhelming, really. There is a point where you
> > start to fail and make choices that are not better than a machine's. But
> > is a mistake once in a while dramatic if on the other hand it fixes 200
> > other issues ? I think not as long as it's transparent and accepted by
> > the users, because for one user that could experience a regression (one
> > that escaped all the testing in place), thousands get fixes for existing
> > problems. I'm not saying that regressions are good, I hate them, but as
> > James said, we have to accept that user are part of the quality process.
> > 
> > My approach on another project I maintain is to announce upfront my own
> > level of trust in my backport work, saying "I had a difficult week fixing
> > that problem, do not rush on it or be extra careful", or "nothing urgent,
> > no need to upgrade if you have no problem" or also "just upgrade, it's
> > almost riskless". Users love that, because they know they're part of the
> > quality assurance process, and they will either take small risks when
> > they can, or wait for others to take risks.
> > 
> > But thinking that having one person review patches affecting many
> > subsystem after pre-selection and extra info regarding discussions on
> > each individual patch could result in more reliable stable releases is
> > just an illusion IMHO, because the root of problem is that there are not
> > enough humans to fix all the problems that humans introduce in the first
> > place, and despite this we need to fix them. Just like automated scripts
> > scraping lore, AUTOSEL does bring some value if it offloads some work
> > from the available humans, even in its current state. And I hope that
> > more of the selection and review work in the future will be automated
> > and even less dependent on humans, because it does have a chance to be
> > more reliable in front of that vast amount of work.
> 
> As I said in a part of my email which you did not quote, the fallback option is
> to send the list of issues to the mailing list for others to review.
> 
> If even that fails, then it could be cut down to the *just the most useful*
> heuristics and decisions made automatically based on those...  "Don't AUTOSEL
> patch N of a series without 1...N-1" might be a good one.
> 
> But again, this comes back to one of the core issues here which is how does one
> even build something for the stable maintainers if their requirements are
> unknown to others?
> 

Another issue that I'd like to reiterate is that AUTOSEL is currently turned up
to 11.  It's simply selecting too much.

It should be made less sensitive and select higher confidence commits only.

That would cut down on the workload slightly.

(And please note, the key word here is *confidence*.  We all agree that it's
never possible to be absolutely 100% sure whether a commit is appropriate for
stable or not.  That's a red herring.

And I would assume, or at least hope, that the neural network thing being used
for AUTOSEL outputs a confidence rating and not just a yes/no answer.  If it
actually just outputs yes/no, well how is anyone supposed to know that and fix
that, given that it does not seem to be an open source project?)

- Eric
