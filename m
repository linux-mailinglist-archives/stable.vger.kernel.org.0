Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74264BE24D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354372AbiBUPIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 10:08:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378823AbiBUPIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 10:08:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED47D1A39A;
        Mon, 21 Feb 2022 07:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF3560C75;
        Mon, 21 Feb 2022 15:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8307DC340E9;
        Mon, 21 Feb 2022 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645456065;
        bh=RYYa6zFcQ22JEsyjITU8QJ+Wj7LZink/DxdONAv5rUQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S9cP1ZaMM2NMffYrB4iVtPpxNXglHYAXg2vwNAkdK35fOFZkidliJTujFBLUI3woB
         cw2GgggyAN56lPwsP1KvntRCOVaBrXXQOZfWrrtVAM4H4yY3Q9wrU+N5oQZzLD0TEs
         DIYTjL+29+0TuJALBrO9avpUWasc9UcE7mhnS5fdZWI8MpDPt1FjlZxP30et51scaq
         jDfW1NXwviBT7iQT+zd7EsAPS/JHkySOjcTcJABXeQR9gR6lD7DR0zWyGmc9wJ16F3
         wqzTamuQQYFkLRYaFIYfnpQBHv3wK3sozgiT8tfv4Ca6pGba86ny9MZCiERQjtPICA
         PNOzrXPsS3S8A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>,
        Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.16 077/227] iwlwifi: fix use-after-free
References: <20220221084934.836145070@linuxfoundation.org>
        <20220221084937.429986092@linuxfoundation.org>
        <fd5bacfa-b357-a2e2-f0b2-2098cdc734f2@leemhuis.info>
        <87h78swggw.fsf@kernel.org>
        <7dce67c2-918e-3553-9dd3-1f59d3d37e05@leemhuis.info>
Date:   Mon, 21 Feb 2022 17:07:39 +0200
In-Reply-To: <7dce67c2-918e-3553-9dd3-1f59d3d37e05@leemhuis.info> (Thorsten
        Leemhuis's message of "Mon, 21 Feb 2022 15:30:09 +0100")
Message-ID: <87czjgw950.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thorsten Leemhuis <regressions@leemhuis.info> writes:

> On 21.02.22 13:29, Kalle Valo wrote:
>> Thorsten Leemhuis <regressions@leemhuis.info> writes:
>>=20
>>> Hi, this is your Linux kernel regression tracker.
>>>
>>> On 21.02.22 09:48, Greg Kroah-Hartman wrote:
>>>> From: Johannes Berg <johannes.berg@intel.com>
>>>>
>>>> commit bea2662e7818e15d7607d17d57912ac984275d94 upstream.
>>>>
>>>> If no firmware was present at all (or, presumably, all of the
>>>> firmware files failed to parse), we end up unbinding by calling
>>>> device_release_driver(), which calls remove(), which then in
>>>> iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
>>>> the new code I added will still erroneously access it after it
>>>> was freed.
>>>>
>>>> Set 'failure=3Dfalse' in this case to avoid the access, all data
>>>> was already freed anyway.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: Stefan Agner <stefan@agner.ch>
>>>> Reported-by: Wolfgang Walter <linux@stwm.de>
>>>> Reported-by: Jason Self <jason@bluehome.net>
>>>> Reported-by: Dominik Behr <dominik@dominikbehr.com>
>>>> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethings=
lab.com>
>>>> Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmwar=
e load")
>>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>>> Signed-off-by: Kalle Valo <kvalo@kernel.org>
>>>> Link:
>>>> https://lore.kernel.org/r/20220208114728.e6b514cf4c85.Iffb575ca2a623d7=
859b542c33b2a507d01554251@changeid
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> Great to see that you quickly picked up this patch. Once the new stable
>>> and longterm releases are out on Wednesday, it will fix a regression
>>> that made it into many stable and longterm kernels nearly four weeks
>>> earlier. I tracked the issue, which made me we wonder: should I have
>>> done something differently in this case to get the regression resolved
>>> more quickly? Should I maybe have suggested to remove the culprit
>>> temporarily until the fix was merged to mainline?
>>>
>>> For context, this is the story of the regression afaics: the change
>>> ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
>>> was merged for 5.17-rc1 (released on 2022-01-23). Shortly after it was
>>> backported to several stable/longterm series with new versions released
>>> on 2022-01-27. It triggered a general protection fault, if the proper
>>> firmware file was missing. Afaics at least five people reported the
>>> problem between 2022-02-01 and 2022-02-11 for at least 5.10.y, 5.15.y
>>> and 5.16.y (some of those reports were on the stable list), which shows
>>> that such a setup is not that unusual. A fix was posted on 2022-02-08
>>> and approved and committed by a maintainer on 2022-02-10. It was then
>>> merged to mainline on 2022-02-17 (I hope we can find ways to reduce such
>>> particular timeframes in the future, but that's a different story).
>>=20
>> From mainline point of view there is not really any easy way to make
>> this faster. There are multiple trees involved and pull requests always
>> take time (we cannot submit a pull request for every commit sepately),
>
> Well, I'm aware of all that, but OTOH I might be missing something, as
> your reply makes me wonder: what is stopping you from asking Dave/Jakub
> or even Linus himself to directly pick up a regression fix that
> obviously bothers multiple people (the handful we known about might be
> the tip of the iceberg)? Some mailing list posts from Linus iirc
> indicate something like that is not a big problem for him, if it doesn't
> happen too often. With such a approach the issue could have vanished a
> from all our versions a week earlier (if that worth it in this
> particular case is a different question; same for skipping linux-next,
> but you accepted the patch on a Thursday, so it could have been in there
> for one regular work day). Or would that also skip some wireless
> specific CI that you want to chew on the patch first?

There is no wireless CI at the moment.

> The thing is: I noticed how quickly regressions sometimes get fixed when
> Linus is directly involved somehow, especially in cases where he himself
> is affected by the issue. Obviously he deserves some special treatment,
> but OTOH it kinda feels wrong to me when other regression fixes hang
> around in git tree for weeks before they finally make it to mainline
> (which is needed to also get them fixed in stable trees).

In my case it's just lack of time. Thanks to patchwork my patch handling
is pretty much automated, but if I were to ask other maintainers take
patches directly it's more manual work. In some cases I would send a
revert or fix directly to Linus but I can't recall if that has ever
happened, luckily the worst regressions are pretty rare.

> But okay, let's assume for a moment that things can't be sped up, to
> bring me back to the question that made me write the mail you replied
> to: Should I (or you/Johannes?) in that case have asked Greg to
> temporarily revert the culprit in the stable tree until the fix is ready?

I'm not involved with the stable trees so I'm the wrong person to
answer.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
