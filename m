Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B006E4662
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDQL1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 07:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDQL1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 07:27:42 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E24C1C;
        Mon, 17 Apr 2023 04:26:51 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1poMyw-0000Lo-Iw; Mon, 17 Apr 2023 13:25:14 +0200
Message-ID: <69602f1b-4afa-d864-b6d3-d8237f81a51d@leemhuis.info>
Date:   Mon, 17 Apr 2023 13:25:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: kernel error at led trigger "phy0tpt"
Content-Language: en-US, de-DE
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Tobias Dahms <dahms.tobias@web.de>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
 <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
 <fcecf6fc-bf18-73a0-9fc1-6850e183323a@web.de>
 <d14fb08c-70e3-4cc7-caf9-87e73eab9194@gmail.com>
 <8b07ead5-f105-da86-e7da-ee49616f7c1d@collabora.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <8b07ead5-f105-da86-e7da-ee49616f7c1d@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681730811;1bf629c5;
X-HE-SMSGID: 1poMyw-0000Lo-Iw
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[adding Matthias to the list of recipients, who back then applied to
culprit]

Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
for once, to make this easily accessible to everyone.

AngeloGioacchino, Has any progress been made to fix below regression? It
doesn't look like it from here, hence I wondered if it fall through the
cracks.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

On 27.03.23 10:23, AngeloGioacchino Del Regno wrote:
> Il 26/03/23 15:23, Bagas Sanjaya ha scritto:
>> On 3/26/23 02:20, Tobias Dahms wrote:
>>> Hello,
>>>
>>> the bisection gives following result:
>>> --------------------------------------------------------------------
>>> 18c7deca2b812537aa4d928900e208710f1300aa is the first bad commit
>>> commit 18c7deca2b812537aa4d928900e208710f1300aa
>>> Author: AngeloGioacchino Del Regno
>>> <angelogioacchino.delregno@collabora.com>
>>> Date:   Tue May 17 12:47:08 2022 +0200
>>>
>>>      soc: mediatek: pwrap: Use readx_poll_timeout() instead of custom
>>> function
>>>
>>>      Function pwrap_wait_for_state() is a function that polls an address
>>>      through a helper function, but this is the very same operation that
>>>      the readx_poll_timeout macro means to do.
>>>      Convert all instances of calling pwrap_wait_for_state() to instead
>>>      use the read_poll_timeout macro.
>>>
>>>      Signed-off-by: AngeloGioacchino Del Regno
>>> <angelogioacchino.delregno@collabora.com>
>>>      Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>>>      Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>>>      Link:
>>> https://lore.kernel.org/r/20220517104712.24579-2-angelogioacchino.delregno@collabora.com
>>>      Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>>
>>>   drivers/soc/mediatek/mtk-pmic-wrap.c | 60
>>> ++++++++++++++++++++----------------
>>>   1 file changed, 33 insertions(+), 27 deletions(-)
>>> --------------------------------------------------------------------
>>>
>>
>> OK, I'm updating the regression status:
>>
>> #regzbot introduced: 18c7deca2b8125
>>
>> And for replying, don't top-post, but rather reply inline with
>> appropriate context instead; hence I cut the replied context.
>>
> 
> There are two possible solutions to that, specifically, either:
>  1. Change readx_poll_timeout() to readx_poll_timeout_atomic(); or
>  2. Fix the mt6323-led driver so that this operation gets done
>     out of atomic context, which is IMO the option to prefer.
> 
> Ideas?
> 
> Regards,
> Angelo
> 
> 
