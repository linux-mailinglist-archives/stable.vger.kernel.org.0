Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732294BE4DC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377812AbiBUOan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 09:30:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358822AbiBUOag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 09:30:36 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E3B1EC7B;
        Mon, 21 Feb 2022 06:30:13 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nM9ha-0002vS-2G; Mon, 21 Feb 2022 15:30:10 +0100
Message-ID: <7dce67c2-918e-3553-9dd3-1f59d3d37e05@leemhuis.info>
Date:   Mon, 21 Feb 2022 15:30:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 077/227] iwlwifi: fix use-after-free
Content-Language: en-BS
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20220221084934.836145070@linuxfoundation.org>
 <20220221084937.429986092@linuxfoundation.org>
 <fd5bacfa-b357-a2e2-f0b2-2098cdc734f2@leemhuis.info>
 <87h78swggw.fsf@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87h78swggw.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1645453813;dabea8c3;
X-HE-SMSGID: 1nM9ha-0002vS-2G
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.02.22 13:29, Kalle Valo wrote:
> Thorsten Leemhuis <regressions@leemhuis.info> writes:
> 
>> Hi, this is your Linux kernel regression tracker.
>>
>> On 21.02.22 09:48, Greg Kroah-Hartman wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> commit bea2662e7818e15d7607d17d57912ac984275d94 upstream.
>>>
>>> If no firmware was present at all (or, presumably, all of the
>>> firmware files failed to parse), we end up unbinding by calling
>>> device_release_driver(), which calls remove(), which then in
>>> iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
>>> the new code I added will still erroneously access it after it
>>> was freed.
>>>
>>> Set 'failure=false' in this case to avoid the access, all data
>>> was already freed anyway.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Stefan Agner <stefan@agner.ch>
>>> Reported-by: Wolfgang Walter <linux@stwm.de>
>>> Reported-by: Jason Self <jason@bluehome.net>
>>> Reported-by: Dominik Behr <dominik@dominikbehr.com>
>>> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
>>> Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>> Signed-off-by: Kalle Valo <kvalo@kernel.org>
>>> Link:
>>> https://lore.kernel.org/r/20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> Great to see that you quickly picked up this patch. Once the new stable
>> and longterm releases are out on Wednesday, it will fix a regression
>> that made it into many stable and longterm kernels nearly four weeks
>> earlier. I tracked the issue, which made me we wonder: should I have
>> done something differently in this case to get the regression resolved
>> more quickly? Should I maybe have suggested to remove the culprit
>> temporarily until the fix was merged to mainline?
>>
>> For context, this is the story of the regression afaics: the change
>> ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
>> was merged for 5.17-rc1 (released on 2022-01-23). Shortly after it was
>> backported to several stable/longterm series with new versions released
>> on 2022-01-27. It triggered a general protection fault, if the proper
>> firmware file was missing. Afaics at least five people reported the
>> problem between 2022-02-01 and 2022-02-11 for at least 5.10.y, 5.15.y
>> and 5.16.y (some of those reports were on the stable list), which shows
>> that such a setup is not that unusual. A fix was posted on 2022-02-08
>> and approved and committed by a maintainer on 2022-02-10. It was then
>> merged to mainline on 2022-02-17 (I hope we can find ways to reduce such
>> particular timeframes in the future, but that's a different story).
> 
> From mainline point of view there is not really any easy way to make
> this faster. There are multiple trees involved and pull requests always
> take time (we cannot submit a pull request for every commit sepately),

Well, I'm aware of all that, but OTOH I might be missing something, as
your reply makes me wonder: what is stopping you from asking Dave/Jakub
or even Linus himself to directly pick up a regression fix that
obviously bothers multiple people (the handful we known about might be
the tip of the iceberg)? Some mailing list posts from Linus iirc
indicate something like that is not a big problem for him, if it doesn't
happen too often. With such a approach the issue could have vanished a
from all our versions a week earlier (if that worth it in this
particular case is a different question; same for skipping linux-next,
but you accepted the patch on a Thursday, so it could have been in there
for one regular work day). Or would that also skip some wireless
specific CI that you want to chew on the patch first?

The thing is: I noticed how quickly regressions sometimes get fixed when
Linus is directly involved somehow, especially in cases where he himself
is affected by the issue. Obviously he deserves some special treatment,
but OTOH it kinda feels wrong to me when other regression fixes hang
around in git tree for weeks before they finally make it to mainline
(which is needed to also get them fixed in stable trees).

But okay, let's assume for a moment that things can't be sped up, to
bring me back to the question that made me write the mail you replied
to: Should I (or you/Johannes?) in that case have asked Greg to
temporarily revert the culprit in the stable tree until the fix is ready?

Ciao, Thorsten
