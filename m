Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD17860EF8A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 07:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJ0Fhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 01:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiJ0Fhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 01:37:40 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D63615A955;
        Wed, 26 Oct 2022 22:37:37 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1onvaA-00010u-Qi; Thu, 27 Oct 2022 07:37:34 +0200
Message-ID: <fdca8918-730c-c36d-a3ca-4c95f16d1e8e@leemhuis.info>
Date:   Thu, 27 Oct 2022 07:37:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] Bug 216613 - Sound stopped working with v6.0.3 on
 Lenovo T14 Gen2i: ASoC: error at snd_soc_component_probe
Content-Language: en-US, de-DE
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     alsa-devel@alsa-project.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
References: <2c028797-b313-be93-7b1e-8d838e694948@leemhuis.info>
 <f34cafd4-f224-ad10-6962-e8f6c709cb39@leemhuis.info>
 <3f207f82-e177-c833-b2b0-ca9e64a6e9a7@linux.intel.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <3f207f82-e177-c833-b2b0-ca9e64a6e9a7@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1666849058;76a7e5dd;
X-HE-SMSGID: 1onvaA-00010u-Qi
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CCing Takashi in case he is interested in this and/or wants to make my
life as regression tracker a little easier in the future]

On 26.10.22 22:41, Pierre-Louis Bossart wrote:
> On 10/26/22 07:08, Thorsten Leemhuis wrote:
>> On 22.10.22 08:35, Thorsten Leemhuis wrote:
>>>
>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>>> kernel developer don't keep an eye on it, I decided to forward it by
>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216613 :
>>>
>>>> After upgrade kernel from 6.0.2 to 6.0.3 on Lenovo T14 Gen2i, sound stopped working.
>>>> dmesg:
>>>>
>>>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: failed to create hda codec -12
>>>> paź 21 21:11:45 kernel: snd_hda_codec_hdmi ehdaudio0D2: ASoC: error at snd_soc_component_probe on ehdaudio0D2: -12
>>>> paź 21 21:11:45 kernel: skl_hda_dsp_generic skl_hda_dsp_generic: ASoC: failed to instantiate card -12
>>>>
>>
>> #regzbot introduced: 7494e2e6c55ed19
>> #regzbot fixed-by: 02356311982b
> 
> Revert on its way:
> https://lore.kernel.org/r/20221024143931.15722-1-tiwai@suse.de

Thx, in fact it was already merged:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.0.y&id=02356311982bbb117310a27985fa8938e82c0b6e

That "#regzbot fixed-by: 02356311982b" above told my regression tracking
bot about the commit. I sadly had to do that manually, as Takashi used
the non-standard "BugLink" tag to link to the report, which Linus
doesn't want:

https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/

To quote: ```please stop making up random tags that make no sense. Just
use "Link:"```

Maybe regzbot nevertheless should resolve a tracked regression as
resolved, if it sees BugLink to a tracked regression. But I think the
real solution is: checkpatch.pl should complain.

Ciao, Thorsten
