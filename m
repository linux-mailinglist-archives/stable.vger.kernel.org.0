Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB26B5FC9
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjCKSeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKSeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:34:16 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5017D2A9B9;
        Sat, 11 Mar 2023 10:34:14 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32BIXwDA029958;
        Sat, 11 Mar 2023 19:33:58 +0100
Date:   Sat, 11 Mar 2023 19:33:58 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzJltJaydwjCN6E@1wt.eu>
References: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAy+3f1/xfl6dWpI@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:48:13AM -0800, Eric Biggers wrote:
> The purpose of all these mailing list searches would be to generate a list of
> potential issues with backporting each commit, which would then undergo brief
> human review.

This is one big part that I suspect is underestimated. I'll speak from my
past experience maintaining extended LTS for 3.10. I couldn't produce as
many releases as I would have liked to because despite the scripts that
helped me figure some series, some dependencies, origin branches etc, the
whole process of reviewing ~600 patches to end up with ~200 at the end
(and adapting some of them to fit) required ~16 hours a day for a full
week-end, and I didn't always have that amount of time available. Any my
choices were far from being perfect, as during the reviews I got a number
of "please don't backport this there" and "if you take this one you also
need these ones". Also I used to intentionally drop what had nothing to
do on old LTS stuff so even from that perspective my work could have been
perceived as insufficient.

The reviewing process is overwhelming, really. There is a point where you
start to fail and make choices that are not better than a machine's. But
is a mistake once in a while dramatic if on the other hand it fixes 200
other issues ? I think not as long as it's transparent and accepted by
the users, because for one user that could experience a regression (one
that escaped all the testing in place), thousands get fixes for existing
problems. I'm not saying that regressions are good, I hate them, but as
James said, we have to accept that user are part of the quality process.

My approach on another project I maintain is to announce upfront my own
level of trust in my backport work, saying "I had a difficult week fixing
that problem, do not rush on it or be extra careful", or "nothing urgent,
no need to upgrade if you have no problem" or also "just upgrade, it's
almost riskless". Users love that, because they know they're part of the
quality assurance process, and they will either take small risks when
they can, or wait for others to take risks.

But thinking that having one person review patches affecting many
subsystem after pre-selection and extra info regarding discussions on
each individual patch could result in more reliable stable releases is
just an illusion IMHO, because the root of problem is that there are not
enough humans to fix all the problems that humans introduce in the first
place, and despite this we need to fix them. Just like automated scripts
scraping lore, AUTOSEL does bring some value if it offloads some work
from the available humans, even in its current state. And I hope that
more of the selection and review work in the future will be automated
and even less dependent on humans, because it does have a chance to be
more reliable in front of that vast amount of work.

And in any case I've seen you use the word "trivial" several times in
this thread, and for having been through a little bit of this process
in the past, I wouldn't use that word anywhere in a description of what
my experience had been. You really seem to underestimate the difficulty
here.

Regards,
Willy
