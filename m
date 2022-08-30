Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2442F5A6F0F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 23:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiH3VWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 17:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiH3VWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 17:22:22 -0400
X-Greylist: delayed 2065 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 14:22:20 PDT
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADD57E81C;
        Tue, 30 Aug 2022 14:22:20 -0700 (PDT)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 22F472E567;
        Tue, 30 Aug 2022 20:47:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.134])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4FF4920080;
        Tue, 30 Aug 2022 20:47:50 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4F34EBC0079;
        Tue, 30 Aug 2022 20:47:49 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 7A23413C2B0;
        Tue, 30 Aug 2022 13:47:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 7A23413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1661892468;
        bh=IWicMtCVoSqbenm0Io1txAB5st81R43ZF1d7pF9EvXI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=W+SqcU3LQqLEdlEqyqVWKs/FDKKI5Cb0a92lWjyd+dB0d13sCe/xd8nGRt18ZnjpE
         Qf4mUlTfun1cOFA0K5Ps/9bptWBSK+QlLCN4daW6NoCP99H6nIPmy5+GpCNpZMyWdP
         1fnWbwWnGU4mhGGMHDChy6Fca1Lru0UnneEIzElE=
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@helgaas.com
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
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
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com>
Date:   Tue, 30 Aug 2022 13:47:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YwXH/l37HaYQD66B@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1661892470-e0BElUr0M9MX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
> On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
>> On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> wrote:
>>
>>> From: Stefan Roese <sr@denx.de>
>>>
>>> [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
>>>
>>
>> There's an open regression related to this commit:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=216373
> 
> This is already in the following released stable kernels:
> 	5.10.137 5.15.61 5.18.18 5.19.2
> 
> I'll go drop it from the 4.19 and 5.4 queues, but when this gets
> resolved in Linus's tree, make sure there's a cc: stable on the fix so
> that we know to backport it to the above branches as well.  Or at the
> least, a "Fixes:" tag.

This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
that we did not see in 5.19.0+.  I just bisected the scary looking AER errors to this
patch, though I do not know for certain if it causes the iwlwifi related crashes yet.

In general, from reading the commit msg, this patch doesn't seem to be a great candidate
for stable in general.  Does it fix some important problem?

In case it helps, here is example of what I see in dmesg.  The kernel crashes in iwlwifi
had to do with rx messages from the firmware, and some warnings lead me to believe that
pci messages were slow coming back and/or maybe duplicated.  So maybe this AER patch changes
timing or otherwise screws up the PCI adapter boards we use...


[   50.905809] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
[   50.905830] pcieport 0000:03:01.0: AER: device recovery failed
[   50.905831] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:01.0
[   50.905845] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   50.915679] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
[   50.922735] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
[   50.928230] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
[   50.935126] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
[   50.935133] pcieport 0000:03:01.0: AER: device recovery failed
[   50.935134] pcieport 0000:00:1c.0: AER: Multiple Uncorrected (Non-Fatal) error received: 0000:03:01.0
[   50.935222] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   50.945059] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
[   50.952120] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
[   50.957614] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
[   50.964492] pcieport 0000:03:01.0: AER:   Error of this Agent is reported first
[   50.970519] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   50.980344] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
[   50.987399] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
[   50.992891] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
[   50.999785] pcieport 0000:03:03.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.009611] pcieport 0000:03:03.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.016665] pcieport 0000:03:03.0:    [20] UnsupReq               (First)
[   51.022161] pcieport 0000:03:03.0: AER:   TLP Header: 34000000 06001f10 00000000 88c888c8
[   51.029052] pcieport 0000:03:05.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.038881] pcieport 0000:03:05.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.045931] pcieport 0000:03:05.0:    [20] UnsupReq               (First)
[   51.051430] pcieport 0000:03:05.0: AER:   TLP Header: 34000000 07001f10 00000000 88c888c8
[   51.058320] pcieport 0000:03:07.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.068147] pcieport 0000:03:07.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.075200] pcieport 0000:03:07.0:    [20] UnsupReq               (First)
[   51.080696] pcieport 0000:03:07.0: AER:   TLP Header: 34000000 08001f10 00000000 88c888c8
[   51.087589] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
[   51.087598] pcieport 0000:03:01.0: AER: device recovery failed
[   51.087611] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
[   51.087615] pcieport 0000:03:02.0: AER: device recovery failed
[   51.087628] iwlwifi 0000:06:00.0: AER: can't recover (no error_detected callback)
[   51.087631] pcieport 0000:03:03.0: AER: device recovery failed
[   51.087643] iwlwifi 0000:07:00.0: AER: can't recover (no error_detected callback)
[   51.087646] pcieport 0000:03:05.0: AER: device recovery failed
[   51.087659] iwlwifi 0000:08:00.0: AER: can't recover (no error_detected callback)
[   51.087662] pcieport 0000:03:07.0: AER: device recovery failed
[   51.103761] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
[   51.103778] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.113608] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.120658] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
[   51.126152] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
[   51.133044] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
[   51.133068] pcieport 0000:03:0f.0: AER: device recovery failed
[   51.168925] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
[   51.168940] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.178773] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.185823] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
[   51.191318] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
[   51.198211] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
[   51.198234] pcieport 0000:03:0f.0: AER: device recovery failed
[   51.260695] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
[   51.260710] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.270548] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.277605] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
[   51.283103] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
[   51.290009] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
[   51.290033] pcieport 0000:03:0f.0: AER: device recovery failed
[   51.328514] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
[   51.328530] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[   51.331638] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
[   51.338363] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
[   51.338364] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
[   51.345413] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
[   51.350900] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
[   51.350927] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

