Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BACA6D5D94
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjDDKeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjDDKeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:34:05 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD6910B;
        Tue,  4 Apr 2023 03:34:01 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pjdzD-00030k-US; Tue, 04 Apr 2023 12:34:00 +0200
Message-ID: <da479ebf-b3fb-0a58-16be-07fe55d36621@leemhuis.info>
Date:   Tue, 4 Apr 2023 12:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US, de-DE
To:     Oliver Neukum <oneukum@suse.com>,
        "Purohit, Kaushal" <kaushal.purohit@ti.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <da37bb0d43de465185c10aad9924f265@ti.com>
 <28ec4e65-647f-2567-fb7d-f656940d4e43@suse.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: issues with cdc ncm host class driver
In-Reply-To: <28ec4e65-647f-2567-fb7d-f656940d4e43@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680604441;88f2e5ac;
X-HE-SMSGID: 1pjdzD-00030k-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[adding Miguel Rodríguez Pérez and Bjørn Mork from the signed-off-by
chain of the culprit to the list of recipients]

Side note: there is now a bug tracking ticket for this issue, too:
https://bugzilla.kernel.org/show_bug.cgi?id=217290

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 03.04.23 12:09, Oliver Neukum wrote:
> On 03.04.23 08:14, Purohit, Kaushal wrote:

>> Referring to patch with commit ID
>> (*e10dcb1b6ba714243ad5a35a11b91cc14103a9a9*).
>>
>> This is a spec violation for CDC NCM class driver. Driver clearly says
>> the significance of network capabilities. (snapshot below)
>>
>> However, with the mentioned patch these values are disrespected and
>> commands specific to these capabilities are sent from the host
>> regardless of device' capabilities to handle them.
> 
> Right. So for your device, the correct behavior would be to do
> nothing, wouldn't it? The packets would be delivered and the host
> needs to filter and discard unrequested packets.
> 
>> Currently we are setting these bits to 0 indicating no capabilities on
>> our device and still we observe that Host (Linux kernel host cdc
>> driver) has been sending requests specific to these capabilities.
>>
>> Please let me know if there is a better way to indicate host that
>> device does not have these capabilities.
> 
> no you are doing things as they are supposed to be done and
> the host is at fault. This kernel bug needs to be fixed.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced e10dcb1b6ba714243ad
https://bugzilla.kernel.org/show_bug.cgi?id=217290
#regzbot from: Purohit, Kaushal
#regzbot title net: cdc_ncm: spec violation for CDC NCM
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
