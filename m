Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3006B60C5
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 21:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCKU7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 15:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCKU7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 15:59:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A432E4A;
        Sat, 11 Mar 2023 12:59:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B543B80B34;
        Sat, 11 Mar 2023 20:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DE7C433EF;
        Sat, 11 Mar 2023 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678568371;
        bh=Pg2HjLx8GdJVuQLgMAqmAvFJR9XFOR9C+clZu8j8+ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEP1JfXPci4WKn0FuQulm/BYvNFdBPL+5XsZTXIzaMg6ZuPPYfgDW3bG2zYVOKDO5
         blhzjXAS08vNVsbE8rfX13KldetiH39N5NJpc8D/THypfStHj34DoopNHNxPneTk/C
         0QI8AvWZ93C2vVyKLFzRK1Gnuz/nrrPBr08h5mHvJlcbvvFKJi+FPAEvAPKsKlCvN3
         01ipVjM3kk2BZr/6+/NmfWYnshaZJWm/GxmjFmimCGk7D98E0kMc5GHacwqW6T/Vue
         bcuJz8/kuajttlYhndbFKNf/MEC8tUZiOEprQ2GXS6gdup4ryzAMv/AZ7TN+LAumCv
         OhqcHD3y7pmVA==
Date:   Sat, 11 Mar 2023 15:59:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzrsgAMX+LC9E5A@sashalap>
References: <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzafagDchRQRxWi@sol.localdomain>
 <ZAzianzvIOUrH5pr@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZAzianzvIOUrH5pr@1wt.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:19:54PM +0100, Willy Tarreau wrote:
>On Sat, Mar 11, 2023 at 11:46:05AM -0800, Eric Biggers wrote:
>> (And please note, the key word here is *confidence*.  We all agree that it's
>> never possible to be absolutely 100% sure whether a commit is appropriate for
>> stable or not.  That's a red herring.
>
>In fact even developers themselves sometimes don't know, and even when they
>know, sometimes they know after committing it. Many times we've found that
>a bug was accidently resolved by a small change. Just for this it's important
>to support a post-merge analysis.
>> And I would assume, or at least hope, that the neural network thing being used
>> for AUTOSEL outputs a confidence rating and not just a yes/no answer.  If it
>> actually just outputs yes/no, well how is anyone supposed to know that and fix
>> that, given that it does not seem to be an open source project?)
>
>Honestly I don't know. I ran a few experiments with natural language
>processors such as GPT-3 on commit messages which contained human-readable
>instructions, and asking "what am I expected to do with these patches", and
>seeing the bot respond "you should backport them to this version, change
>this and that in that version, and preliminary take that patch". It
>summarized extremely well the instructions delivered by the developer,
>which is awesome, but was not able to provide any form of confidence
>level. I don't know what Sasha uses but wouldn't be surprised it shares
>some such mechanisms and that it might not always be easy to get such a
>confidence level. But I could be wrong.

It's actually pretty stupid: it uses the existence of ~10k of the most
common words in commit messages + metrics from cqmetrics
(github.com/dspinellis/cqmetrics) as input.

Although I get a score, which is already set pretty high, confidence is
really non-existant here: at the end it depends mostly on the writing
style of said commit author more than anything.

-- 
Thanks,
Sasha
