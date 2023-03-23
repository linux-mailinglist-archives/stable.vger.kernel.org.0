Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8836C6898
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 13:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjCWMjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 08:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjCWMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 08:39:39 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541BB26C15
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 05:39:38 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pfKEB-0007XV-1v; Thu, 23 Mar 2023 13:39:35 +0100
Message-ID: <61065a7f-19ce-0308-57ed-4cd4c4d681a0@leemhuis.info>
Date:   Thu, 23 Mar 2023 13:39:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [REGRESSION] kbl-r5514-5663-max hdmi no longer working
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Jason Montleon <jmontleo@redhat.com>, stable@vger.kernel.org,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Mark Brown <broonie@kernel.org>,
        Alsa-devel <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
References: <CAJD_bPKQdtaExvVEKxhQ47G-ZXDA=k+gzhMJRHLBe=mysPnuKA@mail.gmail.com>
 <f96431ee-abc0-ff76-3963-c45d3b092840@leemhuis.info>
In-Reply-To: <f96431ee-abc0-ff76-3963-c45d3b092840@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1679575178;0a36e1c5;
X-HE-SMSGID: 1pfKEB-0007XV-1v
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.03.23 18:32, Linux regression tracking (Thorsten Leemhuis) wrote:
> [adding a push of people and lists to the recipients that dealt with the
> culprit; leaving the stable list in CC for now, even if this is a
> mainline issue (apart from the backport of the culprit to 5.10.y Takashi
> asked for a while ago)]
> 
> On 13.03.23 17:34, Jason Montleon wrote:
>> It looks like HDMI audio stopped working in 5.17-rc1. I ran a bisect
>> which points to 636110411ca726f19ef8e87b0be51bb9a4cdef06.
> 
> FWIW, that's "ASoC: Intel/SOF: use set_stream() instead of
> set_tdm_slots() for HDAudio" from Pierre-Louis Bossart.

Pierre-Louis Bossart, did you find time to look into this?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

>> I built
>> 5.17.14 with it reverted and it restored HDMI output, but it doesn't
>> revert cleanly from 5.18 onward.
>>
>> >From what I can tell it looks like -ENOTSUPP is returned from
>> snd_soc_dai_set_stream for hdmi1 and hdmi2 now. I'm not sure if that's
>> expected, but I made the following change and I have working HDMI
>> audio now. https://gist.github.com/jmontleon/4780154c309f956d97ca9a304a00da3f
> 
> Thanks for the report and the patch. I CCed the relevant people for this.
> 
> [TLDR For the rest of the mail: : I'm adding this report to the list of
> tracked Linux kernel regressions; the text you find below is based on a
> few templates paragraphs you might have encountered already in similar
> form. See link in footer if these mails annoy you.]
> 
> To be sure the issue doesn't fall through the cracks unnoticed, I'm
> adding it to regzbot, the Linux kernel regression tracking bot:
> 
> #regzbot ^introduced 636110411ca726f19ef8e87b0be51bb9a4cdef06
> #regzbot title alsa/asoc: kbl-r5514-5663-max hdmi stopped working
> #regzbot ignore-activity
> 
> This isn't a regression? This issue or a fix for it are already
> discussed somewhere else? It was fixed already? You want to clarify when
> the regression started to happen? Or point out I got the title or
> something else totally wrong? Then just reply and tell me -- ideally
> while also telling regzbot about it, as explained by the page listed in
> the footer of this mail.
> 
> Developers: When fixing the issue, remember to add 'Link:' tags pointing
> to the report (the parent of this mail). See page linked in footer for
> details.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> That page also explains what to do if mails like this annoy you.
