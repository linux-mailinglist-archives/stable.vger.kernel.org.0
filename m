Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21EB6A4424
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjB0OTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjB0OTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:19:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB81A5FB;
        Mon, 27 Feb 2023 06:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBECEB80D49;
        Mon, 27 Feb 2023 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5B1C433D2;
        Mon, 27 Feb 2023 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677507540;
        bh=MllVkqna+KRHh+7oa1TlLNjurp37Pn6DT90ieHwmVIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5hQ/4IuRP0f4VZ74sKn9NQ/k1+7NJsvJ7fDk//vnbbq/EeCAjbvvqNaxmJhdRLZ0
         3escyQyLRTp0B8y+SRuaHWPWSn7US9yIbhiO4G4H0BJ+ioSGkBsq0KvmUGllchwSND
         Ovwh3vVD3YZfo8icu7YFPjiZr/+muOCbsWhFkHOHtUNTJ7zfSB6ijuTz71Z3ALbkZI
         tvYWQuxFsLZ0aIKCVOkqWn0WUEaIvM+lDkTxO7MU4UWnIaDlQ2OKn8TTkZGlpyq2zE
         0o3vvVitww0a/dePj4d33FVtLiE9Iy25agvKL4dm9NFSP7JJrFO/nkz9pRahvNu1Ra
         IPhiocKEObrQg==
Date:   Mon, 27 Feb 2023 09:18:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 12/21] fs/super.c: stop calling
 fscrypt_destroy_keyring() from __put_super()
Message-ID: <Y/y70zJj4kjOVfXa@sashalap>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 26, 2023 at 11:24:36AM -0800, Eric Biggers wrote:
>On Sat, Feb 25, 2023 at 09:30:37PM -0800, Eric Biggers wrote:
>> On Sat, Feb 25, 2023 at 08:07:55PM -0800, Eric Biggers wrote:
>> > On Sat, Feb 25, 2023 at 10:42:47PM -0500, Sasha Levin wrote:
>> > > From: Eric Biggers <ebiggers@google.com>
>> > >
>> > > [ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]
>> > >
>> > > Now that the key associated with the "test_dummy_operation" mount option
>> > > is added on-demand when it's needed, rather than immediately when the
>> > > filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
>> > > called from __put_super() to avoid a memory leak on mount failure.
>> > >
>> > > Remove this call, which was causing confusion because it appeared to be
>> > > a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle reason).
>> > >
>> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
>> > > Link: https://lore.kernel.org/r/20230208062107.199831-5-ebiggers@kernel.org
>> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >
>> > Why is this being backported?
>> >
>> > - Eric
>>
>> BTW, can you please permanently exclude all commits authored by me from AUTOSEL
>> so that I don't have to repeatedly complain about every commit individually?
>> Especially when these mails often come on weekends and holidays.

Yup, no problem - I'll ignore any commits authored by you.

>> I know how to use Cc stable, and how to ask explicitly for a stable backport if
>> I find out after the fact that one is needed.  (And other real people can always
>> ask too... not counting AUTOSEL, even though you are sending the AUTOSEL emails,
>> since clearly they go through no or very little human review.)

One of the challanges here is that it's difficult to solicit reviews or
really any interaction from authors after a commit lands upstream. Look
at the response rates to Greg's "FAILED" emails that ask authors to
provide backports to commits they tagged for stable.

>> Of course, it's not just me that AUTOSEL isn't working for.  So, you'll still
>> continue backporting random commits that I have to spend hours bisecting, e.g.
>> https://lore.kernel.org/stable/20220921155332.234913-7-sashal@kernel.org.
>>
>> But at least I won't have to deal with this garbage for my own commits.
>>
>> Now, I'm not sure I'll get a response to this --- I received no response to my
>> last AUTOSEL question at
>> https://lore.kernel.org/stable/Y1DTFiP12ws04eOM@sol.localdomain.  So to
>> hopefully entice you to actually do something, I'm also letting you know that I
>> won't be reviewing any AUTOSEL mails for my commits anymore.
>>
>
>The really annoying thing is that someone even replied to your AUTOSEL email for
>that broken patch and told you it is broken
>(https://lore.kernel.org/stable/d91aaff1-470f-cfdf-41cf-031eea9d6aca@mailbox.org),
>and ***you ignored it and applied the patch anyway***.
>
>Why are you even sending these emails if you are ignoring feedback anyway?

I obviously didn't ignore it on purpose, right?

-- 
Thanks,
Sasha
