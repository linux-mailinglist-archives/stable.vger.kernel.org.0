Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3443953EBA7
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiFFMrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbiFFMrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:47:13 -0400
X-Greylist: delayed 453 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Jun 2022 05:47:08 PDT
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc08])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB458C27
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:47:08 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LGtNM06qNzMpwFC;
        Mon,  6 Jun 2022 14:39:31 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4LGtNL5BhGzlkSxB;
        Mon,  6 Jun 2022 14:39:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1654519171;
        bh=CgfXZNwF9FNBkTT6uLFxz8GD5bFfog7serWtYIIGBJE=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=AQrUFKI5e06+sR9ghs0rXG+zpOfjCBW3SxQVUXuhYkmZ0TiWwSUeKa1aK1EDtvJcD
         AC66GwWrCz/EUFludi4GFhHcVHFHpdghziGOIPj53xruUVS3OExp8B34h0XwCA7XKD
         tSIf6uNsbRNahcrnvS8P4LOHAqdTwcu8qCO2VOps=
Message-ID: <2daff73b-4d0a-7aaa-0047-026b66ccdf1d@digikod.net>
Date:   Mon, 6 Jun 2022 14:39:30 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
References: <165450152566@kroah.com>
 <f4619c73-9ff1-db8e-de06-3ba984b24399@digikod.net>
 <Yp3i++t/OJVTdPyB@kroah.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: WTF: patch "[PATCH] selftests/landlock: Format with clang-format"
 was seriously submitted to be applied to the 5.18-stable tree?
In-Reply-To: <Yp3i++t/OJVTdPyB@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/06/2022 13:20, Greg KH wrote:
> On Mon, Jun 06, 2022 at 12:59:56PM +0200, Mickaël Salaün wrote:
>> Hi Greg,
>>
>> The 21 Landlock commits merged for 5.19-rc1 and tagged with Cc stable@
>> should indeed be backported up to 5.15 . The first commits are pure cosmetic
>> changes but they need to be backported to avoid backport conflicts (for this
>> series and future backports). They help maintain this subsystem, including
>> to backport future changes.
> 
> Ick, that's not how to submit patches for backporting ideally.
> 
> Usually you submit the bugfixes first, and then we can backport them
> easily.

I understand, but this is are a one time cosmetic changes. Applying them 
later would have been much more difficult to handle.

> 
> If you decide to reformat the codebase, well, you get to deal with the
> backport issues later on (why is it reformatted, isn't it checkpatch
> clean already?
Yes, the idea was to backport early on because until now all commits 
(two) have been backported.

> 
>> The following changes up to commit 8ba0005ff418
>> ("landlock: Fix same-layer rule unions") are required to fix some edge case
>> issues (i.e. syscall argument ordering checks and same-layer rule unions).
>> New tests are added to check that everything work as expected for these
>> backportable changes, and to make it possible for more test environments to
>> run. I successfully tested the backport of all these commits to 5.15 .
>> Please backport them to all stable branches.
> 
> This is just backporting all files here, which seems crazy.

It is backporting 21/30 commits. As maintainer it makes our work easier. 
There is no new feature introduced.

> 
>>
>> Here is the full list of the commits to backport (already marked with Cc:
>> stable@vger.kernel.org):
>>
>> 8ba0005ff418 landlock: Fix same-layer rule unions
>> 2cd7cd6eed88 landlock: Create find_rule() from unmask_layers()
>> 75c542d6c6cc landlock: Reduce the maximum number of layers to 16
>> 5f2ff33e1084 landlock: Define access_mask_t to enforce a consistent access
>> mask size
>> 6533d0c3a86e selftests/landlock: Test landlock_create_ruleset(2) argument
>> check ordering
>> eba39ca4b155 landlock: Change landlock_restrict_self(2) check ordering
>> 589172e5636c landlock: Change landlock_add_rule(2) argument check ordering
>> d1788ad99087 selftests/landlock: Add tests for O_PATH
>> 6a1bdd4a0bfc selftests/landlock: Fully test file rename with "remove" access
>> d18955d094d0 selftests/landlock: Extend access right tests to directories
>> c56b3bf566da selftests/landlock: Add tests for unknown access rights
>> 291865bd7e8b selftests/landlock: Extend tests for minimal valid attribute
>> size
>> 87129ef13603 selftests/landlock: Make tests build with old libc
>> a13e248ff90e landlock: Fix landlock_add_rule(2) documentation
>> 81709f3dccac samples/landlock: Format with clang-format
>> 9805a722db07 samples/landlock: Add clang-format exceptions
>> 371183fa578a selftests/landlock: Format with clang-format
>> 135464f9d29c selftests/landlock: Normalize array assignment
>> 4598d9abf421 selftests/landlock: Add clang-format exceptions
>> 06a1c40a09a8 landlock: Format with clang-format
>> 6cc2df8e3a39 landlock: Add clang-format exceptions
> 
> What order is this in?  And what's the overall diffstat?  And again, why
> use clang-format at all, what is it helping with here?

It is the same order as in the master branch. I explain about 
clang-format in the commit message and the related cover letter.

> 
> thanks,
> 
> greg k-h
