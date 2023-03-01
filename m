Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CEB6A6AD0
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 11:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCAKb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 05:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCAKbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 05:31:25 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F712A992;
        Wed,  1 Mar 2023 02:31:23 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pXJk0-0000Cp-Sh; Wed, 01 Mar 2023 11:31:20 +0100
Message-ID: <bbfb9ea8-5cf2-66fe-e711-9d8baf4863e6@leemhuis.info>
Date:   Wed, 1 Mar 2023 11:31:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, de-DE
To:     Greg KH <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
References: <Y/y70zJj4kjOVfXa@sashalap> <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain> <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com> <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com> <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Subject: Re: AUTOSEL process
In-Reply-To: <Y/3lV0P9h+FxmjyF@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1677666683;5674a027;
X-HE-SMSGID: 1pXJk0-0000Cp-Sh
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.02.23 12:28, Greg KH wrote:
> On Tue, Feb 28, 2023 at 12:41:07PM +0200, Amir Goldstein wrote:
>>>> I'm not sure how feedback in the form of "this sucks but I'm sure it
>>>> could be much better" is useful.
>>> I've already given you some specific suggestions.
>>> I can't force you to listen to them, of course.
>>
>> As you probably know, this is not the first time that the subject of the
>> AUTOSEL process has been discussed.
>> Here is one example from fsdevel with a few other suggestions [1].
>>
>> But just so you know, as a maintainer, you have the option to request that
>> patches to your subsystem will not be selected by AUTOSEL and run your
>> own process to select, test and submit fixes to stable trees.
> [...]
> In an ideal world, all maintainers would properly mark their patches for
> stable backporting (as documented for the past 15+ years, with a cc:
> stable tag, NOT a Fixes: tag), but we do not live in that world, and
> hence, the need for the AUTOSEL work.

Well, we could do something to get a bit closer to the ideal world:
teach checkpatch.pl to help developers do the right thing in the first
place. That's what I'm trying to do right now to make them add Link:
tags more often (https://git.kernel.org/torvalds/c/d7f1d71e5ef6 ), as my
regression tracking efforts heavily rely on them. Shouldn't be too hard
to add a simple check along the lines of "this change has a Fixes: tag;
either CC stable or do <foo> to suppress this warning" (<foo> could be a
"nostable" tag or something else that we'd need to agree on first).

In an ideal we'd maybe even have a "checkpatch bot" that looks at all
patches posted and sends feedback to the list if it finds something to
improve. Sure, some (a lot?) of what AUTOSEL does relies on data that is
only available after a change was merged, but maybe some is available
earlier already.

Ciao, Thorsten
