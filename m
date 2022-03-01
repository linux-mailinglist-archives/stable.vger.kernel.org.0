Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD64E4C97DB
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 22:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiCAVkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 16:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiCAVko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 16:40:44 -0500
X-Greylist: delayed 1017 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 13:40:03 PST
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECA897BA0
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 13:40:03 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nP9xY-000ES7-FM; Tue, 01 Mar 2022 22:23:04 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nP9xY-00058o-6y; Tue, 01 Mar 2022 22:23:04 +0100
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
To:     Lee Jones <lee.jones@linaro.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
References: <163757721744154@kroah.com> <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com> <Yg6AbfbFgDqbhq0e@google.com>
 <YhNg4uM1gIN89B7U@google.com> <YhNoZy415MYPH+GR@kroah.com>
 <YhNtE/sIdv5OkBQT@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f01b6557-ed8f-1385-c5f6-95f73b940b7f@iogearbox.net>
Date:   Tue, 1 Mar 2022 22:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YhNtE/sIdv5OkBQT@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26468/Tue Mar  1 10:31:38 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lee, [ also Cc'ing Rafael, ]

On 2/21/22 11:44 AM, Lee Jones wrote:
> On Mon, 21 Feb 2022, Greg KH wrote:
>> On Mon, Feb 21, 2022 at 09:52:34AM +0000, Lee Jones wrote:
>>> On Thu, 17 Feb 2022, Lee Jones wrote:
>>>> On Thu, 17 Feb 2022, Greg KH wrote:
>>>>> On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
>>>>>> On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
>>>>>>>
>>>>>>> The patch below does not apply to the 5.4-stable tree.
>>>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>>>> tree, then please email the backport, including the original git commit
>>>>>>> id to <stable@vger.kernel.org>.
>>>>>>
>>>>>> We are in receipt of a bug report which cites this patch as the fix.
>>>>>
>>>>> Does the bug report really say that this issue is present in the 5.4
>>>>> kernel tree?  Anything older?
>>>>
>>>> Not specifically, but the commit referenced in the Fixes tag landed in
>>>> v5.5. and was successfully back-ported to v5.4.144.
>>>
>>> Another potential avenue might to be revert the back-ported commit
>>> which caused the issue from v5.4.y.
>>
>> Unless that was fixing a different issue?  I have no idea at this point
>> what commit you are talking about, sorry :(
> 
> The bad-commit mentioned in "the Fixes tag":
> 
> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
> 
> Which as you say, could well have been fixing another issue.
> 
> In fact, yes it was:
> 
> https://lore.kernel.org/stable/20210821203108.215937-2-rafaeldtinoco@gmail.com/
> 
> Daniel, what do you suggest please?

Hm, okay, so a23740ec43ba ("bpf: Track contents of read-only maps as scalars") was
backported to 5.4.144 given Rafael needed it to fix a failing regression test [0].

Normally, I would have said that we should just revert a23740ec43ba given it was
not a 'fix' in the first place, but then we are getting into a situation where it
would break Rafael's now functioning test case again on 5.4.144+ released kernels.

Rafael, given you need this, do you have some cycles to help out Lee on this backport
for 5.4 stable?

Thanks guys,
Daniel

  [0] https://lore.kernel.org/stable/20210821203108.215937-1-rafaeldtinoco@gmail.com/
