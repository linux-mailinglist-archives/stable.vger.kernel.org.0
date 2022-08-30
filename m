Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D185A74F6
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 06:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiHaEXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 00:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiHaEX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 00:23:27 -0400
X-Greylist: delayed 9861 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 21:23:26 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE142E4E;
        Tue, 30 Aug 2022 21:23:26 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 70EC524B059;
        Tue, 30 Aug 2022 22:16:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CD4B1A0068;
        Tue, 30 Aug 2022 22:16:26 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 68CB63C007B;
        Tue, 30 Aug 2022 22:16:25 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 8DFE413C2B0;
        Tue, 30 Aug 2022 15:16:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8DFE413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1661897784;
        bh=lSb6iPlm/e00kQHUQGYl6VDRSpB7b+OgWRMKI9nT3uU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CP3ZuQEG4SgFmdfJdIVeZc0bTNf4qlGF8he8eFS1a4zwosC7aG/QtHDE64dPnl7Kx
         1p4iZp4zW85Wt1Ln6PXqCh7R5DSv+Ov5Zkp2zDGjC/9WFa5uwhRs1umjDp2r9cdZ33
         ZwRzmX6mUxYi3CGyPC75afd2uHxfYR/7DgzMG08s=
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@helgaas.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220823080115.331990024@linuxfoundation.org>
 <20220823080123.228828362@linuxfoundation.org>
 <CABhMZUVycsyy76j2Z=K+C6S1fwtzKE1Lx2povXKfB80o9g0MtQ@mail.gmail.com>
 <YwXH/l37HaYQD66B@kroah.com>
 <47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com>
 <20220830205832.g3lyysmgkarijkvj@pali>
 <00735f18-11f9-c6c6-4abf-002d378957df@candelatech.com>
 <20220830215532.6nnl6d4cfg55dmcl@pali>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <370dee6c-919a-2f98-1404-a3feda14d1ba@candelatech.com>
Date:   Tue, 30 Aug 2022 15:16:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220830215532.6nnl6d4cfg55dmcl@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1661897787-3FcEtP5UB8oZ
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/30/22 2:55 PM, Pali Rohár wrote:
> On Tuesday 30 August 2022 14:28:14 Ben Greear wrote:
>> On 8/30/22 1:58 PM, Pali Rohár wrote:
>>> On Tuesday 30 August 2022 13:47:48 Ben Greear wrote:
>>>> On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
>>>>> On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
>>>>>> On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> wrote:
>>>>>>
>>>>>>> From: Stefan Roese <sr@denx.de>
>>>>>>>
>>>>>>> [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
>>>>>>>
>>>>>>
>>>>>> There's an open regression related to this commit:
>>>>>>
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=216373
>>>>>
>>>>> This is already in the following released stable kernels:
>>>>> 	5.10.137 5.15.61 5.18.18 5.19.2
>>>>>
>>>>> I'll go drop it from the 4.19 and 5.4 queues, but when this gets
>>>>> resolved in Linus's tree, make sure there's a cc: stable on the fix so
>>>>> that we know to backport it to the above branches as well.  Or at the
>>>>> least, a "Fixes:" tag.
>>>>
>>>> This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
>>>> that we did not see in 5.19.0+.  I just bisected the scary looking AER errors to this
>>>> patch, though I do not know for certain if it causes the iwlwifi related crashes yet.
>>>>
>>>> In general, from reading the commit msg, this patch doesn't seem to be a great candidate
>>>> for stable in general.  Does it fix some important problem?
>>>>
>>>> In case it helps, here is example of what I see in dmesg.  The kernel crashes in iwlwifi
>>>> had to do with rx messages from the firmware, and some warnings lead me to believe that
>>>> pci messages were slow coming back and/or maybe duplicated.  So maybe this AER patch changes
>>>> timing or otherwise screws up the PCI adapter boards we use...
>>>
>>>   From that log I have feeling that issue is in that intel wifi card and
>>> it was there also before that commit. Card is crashing (or something
>>> other happens on PCIe bus) and because kernel had disabled Error
>>> Reporting for this card, nobody spotted any issue. And that commit just
>>> opened eye to kernel to see those errors.
>>>
>>> I think this issue should be reported to intel wifi card developers,
>>> maybe they comment it, why card is reporting errors.
>>
>> My main concern is not that AER messages started showing up, but that there
>> started being kernel NPE and WARNINGS showing up sometime after 5.19.0.
>>
>> Possibly this AER thing is mis-direction and the real bug is elsewhere,
>> but since the bugzilla also indicated (different) driver crashes, then
>> I am suspicious this changes things more significantly, at least in a subset
>> of hardware out there.
> 
> Yea, of course, this is something needed to investigate.
> 
> Anyway, do you see driver crashes? Or just these AER errors? And are
> your PCIe cards working, or after seeing these messages in dmesg they
> stopped working? It is needed to know if you are just spammed by tons of
> lines in dmesg and otherwise everything works. Or if after AER errors
> your PCIe devices stop working and rebooting system is required.

We did see higher frequency of weird crashes (accessing null-ish pointer) after upgrading to 5.19.3,
I am building kernel now with 5.19.5 and that AER patch reverted.  We will
test to see if that solves the crashes.

>> Also, any idea what this error in my logs is actually indicating?
> 
> Your PCIe controller received non-fatal, but uncorrected error. There is
> also indication of Unsupported Request Completion Status. Unsupported
> Request is generated by PCIe device when controller / host / kernel try
> to do something which is not supported by device; pretty generic error.
> PCIe base spec describe lot of scenarios when card should return this
> error. Maybe some more detailed information are in TLP Header hexdump,
> but I cannot decode it now.
> 
> Basically it is PCIe card driver who could know how fatal it is that
> issue and how to recover from it. But as you can see intel wifi driver
> does not implement that callback.

Odds of me getting a good answer on that are pretty small.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

