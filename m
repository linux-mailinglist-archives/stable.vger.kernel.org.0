Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2138D4BE4E3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357946AbiBUM3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 07:29:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357937AbiBUM3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 07:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DBE13E30;
        Mon, 21 Feb 2022 04:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1A11612F4;
        Mon, 21 Feb 2022 12:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD119C340E9;
        Mon, 21 Feb 2022 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645446566;
        bh=OmaFrsn4s+m3QVaKvKOf/kobmLt37ekHUhLTfYwN+aY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pJmp+/omTpvcZWxpevQ0CyeM0kuRuVZmPXc9F0Bqhe8LOlZV69V0uAx7KZ1+NH2S8
         17hNJgYkXykg698Q8cAmm14xQj7l94k9+uri99h2NR4BzW8hUA3K2wsUvJMpeM2aLI
         ikfBkhYFP1wB9RHq48Ccx4M0vjuaTInxavS6weLNHmxxoXW+l6BufjbINWTLVtycap
         KBzwsBCNcRna0p2HoTp85M/+hhu//31c4Wrw3rxqnCk2D0ruWf4jN5ZI/US+6Le6hm
         aDFFnr3iAR+K7uOyLSFkdDTvtUnyhN8ajPtzpIQyQNM+j+T4+pzrseQn1lMeJlIEjA
         GpG8pLJjgoWQQ==
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
Date:   Mon, 21 Feb 2022 14:29:19 +0200
In-Reply-To: <fd5bacfa-b357-a2e2-f0b2-2098cdc734f2@leemhuis.info> (Thorsten
        Leemhuis's message of "Mon, 21 Feb 2022 13:00:40 +0100")
Message-ID: <87h78swggw.fsf@kernel.org>
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

> Hi, this is your Linux kernel regression tracker.
>
> On 21.02.22 09:48, Greg Kroah-Hartman wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>=20
>> commit bea2662e7818e15d7607d17d57912ac984275d94 upstream.
>>=20
>> If no firmware was present at all (or, presumably, all of the
>> firmware files failed to parse), we end up unbinding by calling
>> device_release_driver(), which calls remove(), which then in
>> iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
>> the new code I added will still erroneously access it after it
>> was freed.
>>=20
>> Set 'failure=3Dfalse' in this case to avoid the access, all data
>> was already freed anyway.
>>=20
>> Cc: stable@vger.kernel.org
>> Reported-by: Stefan Agner <stefan@agner.ch>
>> Reported-by: Wolfgang Walter <linux@stwm.de>
>> Reported-by: Jason Self <jason@bluehome.net>
>> Reported-by: Dominik Behr <dominik@dominikbehr.com>
>> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingsla=
b.com>
>> Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware =
load")
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> Signed-off-by: Kalle Valo <kvalo@kernel.org>
>> Link:
>> https://lore.kernel.org/r/20220208114728.e6b514cf4c85.Iffb575ca2a623d785=
9b542c33b2a507d01554251@changeid
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Great to see that you quickly picked up this patch. Once the new stable
> and longterm releases are out on Wednesday, it will fix a regression
> that made it into many stable and longterm kernels nearly four weeks
> earlier. I tracked the issue, which made me we wonder: should I have
> done something differently in this case to get the regression resolved
> more quickly? Should I maybe have suggested to remove the culprit
> temporarily until the fix was merged to mainline?
>
> For context, this is the story of the regression afaics: the change
> ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
> was merged for 5.17-rc1 (released on 2022-01-23). Shortly after it was
> backported to several stable/longterm series with new versions released
> on 2022-01-27. It triggered a general protection fault, if the proper
> firmware file was missing. Afaics at least five people reported the
> problem between 2022-02-01 and 2022-02-11 for at least 5.10.y, 5.15.y
> and 5.16.y (some of those reports were on the stable list), which shows
> that such a setup is not that unusual. A fix was posted on 2022-02-08
> and approved and committed by a maintainer on 2022-02-10. It was then
> merged to mainline on 2022-02-17 (I hope we can find ways to reduce such
> particular timeframes in the future, but that's a different story).

From mainline point of view there is not really any easy way to make
this faster. There are multiple trees involved and pull requests always
take time (we cannot submit a pull request for every commit sepately),

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
