Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF226B64F3
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 11:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCLKgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 06:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCLKgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 06:36:10 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E63C38021;
        Sun, 12 Mar 2023 03:36:07 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pbJ3W-0002pE-Bm; Sun, 12 Mar 2023 11:35:58 +0100
Message-ID: <6a916781-7b84-924f-bdc6-0f284610bead@leemhuis.info>
Date:   Sun, 12 Mar 2023 11:35:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US, de-DE
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        reach622@mailcuk.com, Bell <1138267643@qq.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>
References: <20230228024439.27156-1-mario.limonciello@amd.com>
 <Y/1wuXbaPcG9olkt@kernel.org>
 <5e535bf9-c662-c133-7837-308d67dfac94@leemhuis.info>
 <85df6dda-c1c9-f08e-9e64-2007d44f6683@leemhuis.info>
 <ZA0sScO47IMKPhtG@kernel.org>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <ZA0sScO47IMKPhtG@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678617367;4439cfe8;
X-HE-SMSGID: 1pbJ3W-0002pE-Bm
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.03.23 02:35, Jarkko Sakkinen wrote:
> On Fri, Mar 10, 2023 at 06:43:47PM +0100, Thorsten Leemhuis wrote:
>> [adding Linux to the list of recipients]
>>
>> On 08.03.23 10:42, Linux regression tracking (Thorsten Leemhuis) wrote:
>>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
>>> for once, to make this easily accessible to everyone.
>>>
>>> Jarkko, thx for reviewing and picking below fix up. Are you planning to
>>> send this to Linus anytime soon, now that the patch was a few days in
>>> next? It would be good to get this 6.1 regression finally fixed, it
>>> already took way longer then the time frame
>>> Documentation/process/handling-regressions.rst outlines for a case like
>>> this. But well, that's how it is sometimes...
>>
>> Linus, would you consider picking this fix up directly from here or from
>> linux-next (8699d5244e37)? It's been in the latter for 9 days now
>> afaics. And the issue seems to bug more than just one or two users, so
>> it IMHO would be good to get this finally resolved.
>>
>> Jarkko didn't reply to my inquiry, guess something else keeps him busy.
> 
> That's a bit arrogant. You emailed only 4 days ago.

My deepest apologies if that "guess something else keeps him busy"
triggered your response, what I wanted to say is "I don't consider the
lack of a response a problem, that's how it is for all of us sometimes".
Sorry, that might not have been the best way to express that.

If my prodding itself was the cause: well, I think that's what I should
do in this case. That stance developed quickly when I started doing
regression tracking, as I noticed one thing:

Image a regression caused by a commit merged for 5.11-rc1 is reported a
day or two after 5.11-rc7 is released. Imagine further a fix is posted
for review two or three days after 5.11-rc8 is out. From what I noticed
quite a few of those fixes (not all of course) make it to mainline in
time for the release of 5.11. But the picture looked totally different
when the fix was posted for review shortly *after* 5.11 was out, as I
noticed quite a few of those were only mainlined 9 or 10 weeks later for
5.13-rc1 (and only then can be backported to 5.11.y and 5.12.y).

[above was just a hypothetical example with the worst timing to
illustrate the core problem, the timelines are different in case of the
fTPM issue]

From my understanding of things that's not how it should be (unless
there are strong reasons in the individual case). That's why I'm working
against that. Still working on optimizing when/how I ask, as I'm not yet
happy with how I do that.

Don't worry, I use my best judgment in that process; if the fix is
complex and the next merge window is near, I might let it slip – OTOH if
it's something that apparently bugs quite a few people, I prod
developers and maintainers more quickly & often, like I did in this case.

In the end situations like the one outlined above lead me to writing the
section "Prioritize work on fixing regressions" in
Documentation/process/handling-regressions.rst (
https://docs.kernel.org/process/handling-regressions.html ). Greg acked
it; Linus never commented on it, not sure if he looked at it when he
merged that. But I have no idea how developers actually have seen it
and/or take it seriously. But from what I saw it already helped somewhat.

> I'm open to do PR for rc3 with the fix, if it cannot wait to v6.4 pr.

From later in this thread I see that you plan to do that now, thus:

many thx!

Ciao, Thorsten
