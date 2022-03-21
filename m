Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA1C4E2B9B
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 16:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348479AbiCUPRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 11:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241870AbiCUPRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 11:17:44 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB65BEDF31
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 08:16:18 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nWJlY-00084F-Q1; Mon, 21 Mar 2022 16:16:16 +0100
Message-ID: <09be42ec-9eee-8237-83e9-054956381aab@leemhuis.info>
Date:   Mon, 21 Mar 2022 16:16:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com>
 <db755852-effe-c4ca-726c-200d28b0b8a5@leemhuis.info>
 <20220321133529.2d3addaf@xps13>
 <f950bfe4-9c8d-199d-120f-cc8c1ecca8e3@leemhuis.info>
 <20220321144134.3076a2ba@xps13>
 <3ed10e7e-1c73-6464-b1df-6c6e086fa162@leemhuis.info>
 <20220321155618.7bfa214e@xps13>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220321155618.7bfa214e@xps13>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647875778;be2e6bd2;
X-HE-SMSGID: 1nWJlY-00084F-Q1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.03.22 15:56, Miquel Raynal wrote:
> regressions@leemhuis.info wrote on Mon, 21 Mar 2022 15:17:50 +0100:
>> On 21.03.22 14:41, Miquel Raynal wrote:
>>> regressions@leemhuis.info wrote on Mon, 21 Mar 2022 13:51:10 +0100:  
>>>> On 21.03.22 13:35, Miquel Raynal wrote:  
>>>>> regressions@leemhuis.info wrote on Mon, 21 Mar 2022 12:48:11 +0100:
>>>>>  
>>>>>> On 16.03.22 16:54, Tokunori Ikegami wrote:  
>>>>>>> As pointed out by this bug report [1], buffered writes are now broken on
>>>>>>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>>>>>>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>>>>>>> returned by chip_good(). One way to solve the issue is to revert the change
>>>>>>> partially to use chip_ready for S29GL064N.
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/    
>>>>>>
>>>>>> Why did you switch from the documented format for links you added on my
>>>>>> request (see
>>>>>> https://lore.kernel.org/stable/f1b44e87-e457-7783-d46e-0d577cea3b72@leemhuis.info/
>>>>>>
>>>>>> ) to v2 to something else that is not recognized by tools and scripts
>>>>>> that rely on proper link tags? You are making my and maybe other peoples
>>>>>> life unnecessary hard. :-((
>>>>>>
>>>>>> FWIW, the proper style should support footnote style like this:
>>>>>>
>>>>>> Link:
>>>>>> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>>>>>  [1]
>>>>>>
>>>>>> Ciao, Thorsten
>>>>>>
>>>>>> #regzbot ^backmonitor:
>>>>>> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>>>>>  
>>>>>
>>>>> Because today's requirement from maintainers is to provide a Link
>>>>> tag that points to the mail discussion of the patch being applied.  
>>>>
>>>> That can be an additional Link tag, that is done all the time.
>>>>  
>>>>> I
>>>>> then asked to use the above form instead to point to the bug report
>>>>> because I don't see the point of having a "Link" tag for it?  
>>>
>>> Perhaps I should emphasize that I don't remember your initial request
>>> regarding the use of a Link tag  
>>
>> Happen, no worries.
>>
>>> and my original idea was to help this
>>> contributor, not kill your tools which I actually know very little
>>> about.  
>>>>> But it's not your own project, we are all working with thousands of  
>>>> people together on this project on various different fronts. That needs
>>>> coordination, as some things otherwise become hard or impossible. That's
>>>> why we have documentation that explains how to do some things. Not
>>>> following it just because you don't like it is not helpful and in this
>>>> case makes my life as a volunteer a lot harder.  
>>>
>>> Let's be honest, you are referring to a Documentation patch that *you*
>>> wrote  
>>
>> Correct, but in case of submitting-patches it was just a clarification
>> how to place links; why the whole aspect was missing in the other is
>> kinda odd and likely lost in history...
>>
>>> and was merged into Linus' tree mid January. How often do you
>>> think people used to the contribution workflow monitor these files?  
>>
>> Not often, that's why I have no problem pointing it out, even if that's
>> slightly annoying. But you can imagine that it felt kinda odd on my side
>> when asking someone to set the links (with references to the docs
>> explaining how to set them) and seeing them added then in v2, just so
>> see they vanished again in v3 of the same patch. :-/
> 
> I fully understand. I actually learned that these tags had to be used
> for this purpose, so I will actually enforce their use in my next
> reviews.
> 
> Just a side question, should the Documentation also mention how
> to refer to links for people not used to it? Something like
> [5.Posting.rst]:
> 
> 	"Link: <link> [1]
> 	 Link: <link> [2]"

Maybe. But I think the better approach would be: introduce more specify
tags like "Reported:" (and maybe drop "Reported-by" at the same time?)
or "BugLink" (some people use that already!) would be better -- and then
maybe "Posted:", "Reviewposting", or something like that for the link to
the patch that is being applied; and leave "Link" for the rest. I
proposed that a while ago, but that didn't get any traction.

> My original point was that maintainers would almost always add
> a Link tag at the end, containing the mailing-list thread about the
> patch being applied. Just saying in the commit log "see the link below"
> then becomes misleading.

Maybe, but OTOH that link is normally at the end, which kinda makes it
obvious.

> [...]

Ciao, Thorsten
