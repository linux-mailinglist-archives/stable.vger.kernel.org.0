Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD75A7608
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 07:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiHaF5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 01:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHaF5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 01:57:19 -0400
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 22:57:16 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:101:465::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CFBBA9C0;
        Tue, 30 Aug 2022 22:57:16 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4MHYGV3p7Zz9sSJ;
        Wed, 31 Aug 2022 07:52:02 +0200 (CEST)
Message-ID: <cdcf3377-c3fe-f22b-6f43-8ae8cb889da3@denx.de>
Date:   Wed, 31 Aug 2022 07:52:00 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@helgaas.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        linux-wireless@vger.kernel.org
References: <20220830221159.GA132418@bhelgaas>
From:   Stefan Roese <sr@denx.de>
In-Reply-To: <20220830221159.GA132418@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4MHYGV3p7Zz9sSJ
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31.08.22 00:11, Bjorn Helgaas wrote:
> [+cc Gregory, linux-wireless for iwlwifi issue]
> 
> On Tue, Aug 30, 2022 at 01:47:48PM -0700, Ben Greear wrote:
>> On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
>>>> On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> wrote:
>>>>
>>>>> From: Stefan Roese <sr@denx.de>
>>>>>
>>>>> [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
>>>>>
>>>>
>>>> There's an open regression related to this commit:
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=216373
>>>
>>> This is already in the following released stable kernels:
>>> 	5.10.137 5.15.61 5.18.18 5.19.2
>>>
>>> I'll go drop it from the 4.19 and 5.4 queues, but when this gets
>>> resolved in Linus's tree, make sure there's a cc: stable on the fix so
>>> that we know to backport it to the above branches as well.  Or at the
>>> least, a "Fixes:" tag.
>>
>> This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
>> that we did not see in 5.19.0+.  I just bisected the scary looking
>> AER errors to this patch, though I do not know for certain if it
>> causes the iwlwifi related crashes yet.
>>
>> In general, from reading the commit msg, this patch doesn't seem to
>> be a great candidate for stable in general.  Does it fix some
>> important problem?
> 
> I agree, I don't think this is a good candidate for stable.  It has
> already exposed latent amdgpu issues and we'll likely find more.  It's
> good to find and fix these things, but I'd rather do it in -rc than in
> stable kernels.

I also agree. It was not my intention to have this patch added to
the stable branches. Frankly I missed intervening when seeing the
mails about the integration into stable a few weeks ago.

Still I find it very interesting to see, if and what now pops up with
full AER enabled in such more complex (PCIe wise) systems. I expect to
see more users detecting PCIe related problems in their system now.
This will definitely help fixing some bug, as already seen in the
AMD GPU thread. But again not really stable material but better -next
and -rc.

Thanks,
Stefan

> It would be interesting to know whether similar crashes or AER reports
> occur in v6.0-rc.
> 
>> In case it helps, here is example of what I see in dmesg.  The
>> kernel crashes in iwlwifi had to do with rx messages from the
>> firmware, and some warnings lead me to believe that pci messages
>> were slow coming back and/or maybe duplicated.  So maybe this AER
>> patch changes timing or otherwise screws up the PCI adapter boards
>> we use...
> 
> It shouldn't.  This looks like a latent issue that happened before but
> was ignored because we didn't have AER enabled at the switch that
> detected the error.
> 
>> [   50.905809] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
>> [   50.905830] pcieport 0000:03:01.0: AER: device recovery failed
>> [   50.905831] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:01.0
>> [   50.905845] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
>> [   50.915679] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
>> [   50.922735] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
>> [   50.928230] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
> 
> This is an LTR message (Message Code 0x10), Requester ID 04:00.0.  I
> think the iwlwifi device at 04:00.0 sent the LTR message, and 03:01.0
> (probably a Switch Downstream Port leading to bus 04) received it but
> had LTR disabled.  In that case, 03:01.0 would treat the LTR message
> as an Unsupported Request.
> 
> The other errors below are the same but from different devices.
> 
> Does this happen during or after a suspend/resume?  I assume no
> hotplug involved.  Can you collect the output of "sudo lspci -vv" so
> we can see the LTR config for the entire path?
> 
> You can boot with "pci=noaer" to shut up the AER messages (that
> shouldn't affect the parts of lspci output I'm interested in).  Would
> be interesting to know whether "pci=noaer" affects the iwlwifi
> crashes, though.
> 
>> [   51.331638] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
>> [   51.345413] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
> 
> These look like they're from iwlwifi:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/wireless/intel/iwlwifi/fw/acpi.c?id=v5.19#n13
> 
> No idea what this is about.  Maybe unrelated, but the fact that Google
> can't find anything with that UUID makes me think it might actually be
> related.  The UUID was only added to the message in v5.19-rc1 by
> 06eb8dc097b3 ("ACPI: utils: include UUID in _DSM evaluation warning"),
> but that should be enough time to see some for a common device like
> iwlwifi.
> 
> Too bad we print the GUID in a different byte order than GUID_INIT
> takes, which makes it hard to search for, even in the Linux source.
> 
> Bjorn

Viele Grüße,
Stefan Roese

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-51 Fax: (+49)-8142-66989-80 Email: sr@denx.de
