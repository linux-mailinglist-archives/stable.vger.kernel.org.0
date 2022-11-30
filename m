Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E59463CDB6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 04:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiK3DMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 22:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiK3DMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 22:12:46 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9A3D12A
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 19:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669777966; x=1701313966;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=3s4ylgw4TLprGYmkMSDpwCpmRFUj+PW5gb5FHbTiSyM=;
  b=Jd+MAEf/vG5+g0lzrhHjlz0ismhGU9IzyTMtDEneudyZhGRtHTuIeYuf
   XfWgDgfmI3JsFOSH6UEwHdBE15ors8aED3FrHJ6l997IMaukbQBF/wzAA
   CxE/q+izO5luObNsVvo3v0CZW/CZ8F9iCCfSzYcWWQ/VnWVePa3GAGsVa
   o=;
X-IronPort-AV: E=Sophos;i="5.96,205,1665446400"; 
   d="scan'208";a="285395494"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 03:12:40 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 36723C24E0;
        Wed, 30 Nov 2022 03:12:37 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 30 Nov 2022 03:12:37 +0000
Received: from [192.168.12.85] (10.43.161.14) by EX19D028UEC003.ant.amazon.com
 (10.252.137.159) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Wed, 30 Nov
 2022 03:12:36 +0000
Message-ID: <9c875262-fa88-d60d-4641-575d105a238b@amazon.com>
Date:   Tue, 29 Nov 2022 22:12:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATH stable 5.15, 5.10 0/4] Fix EBS volume attach on AWS ARM
 instances
Content-Language: en-US
From:   Luiz Capitulino <luizcap@amazon.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     <stable@vger.kernel.org>, <tglx@linutronix.de>,
        <lcapitulino@gmail.com>
References: <cover.1669655291.git.luizcap@amazon.com>
 <86h6yjm0cs.wl-maz@kernel.org>
 <8b594878-17a2-a708-7102-2e50aabb114b@amazon.com>
In-Reply-To: <8b594878-17a2-a708-7102-2e50aabb114b@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D28UWB001.ant.amazon.com (10.43.161.98) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022-11-28 13:27, Luiz Capitulino wrote:
> 
> On 2022-11-28 12:53, Marc Zyngier wrote:
>> On Mon, 28 Nov 2022 17:08:31 +0000,
>> Luiz Capitulino <luizcap@amazon.com> wrote:
>>> Hi,
>>>
>>> [ Marc, can you help reviewing? Esp. the first patch? ]
>>>
>>> This series of backports from upstream to stable 5.15 and 5.10 fixes 
>>> an issue
>>> we're seeing on AWS ARM instances where attaching an EBS volume 
>>> (which is a
>>> nvme device) to the instance after offlining CPUs causes the device 
>>> to take
>>> several minutes to show up and eventually nvme kworkers and other 
>>> threads start
>>> getting stuck.
>>>
>>> This series fixes the issue for 5.15.79 and 5.10.155. I can't 
>>> reproduce it
>>> on 5.4. Also, I couldn't reproduce this on x86 even w/ affected kernels.
>> That's because x86 has a very different allocation policy compared to
>> what the ITS does. The x86 vector space is tiny, so vectors are only
>> allocated when required. In your case, that's when the CPUs are
>> onlined.
>>
>> With the ITS, all the vectors are allocated upfront, as this is
>> essentially free. But in the case of managed interrupts, these vectors
>> are now pointing to offline CPUs. The ITS tries to fix that, but
>> doesn't nearly have enough information. And the correct course of
>> action is to keep these interrupts in the shutdown state, which is
>> what the series is doing.
> 
> Thank you for the explanation, Marc. I also immensely
> 
> appreciate the super fast response! (more below).
> 
> 
>>
>>> An easy reproducer is:
>>>
>>> 1. Start an ARM instance with 32 CPUs
>> To satisfy my own curiosity, is that in a guest or bare metal? It
>> shouldn't make any difference, but hey...
> 
> This is a guest. I'll test on a bare-metal instance, it may
> 
> take a few hours. I'll reply here.

I was able to test this on a bare-metal instance on both arm64 and x86 
with and without this series. It all works as expected.

The only difference in that on the arm64 bare-metal instance, I get
a PCI error on an unfixed kernel (below) and the system never hangs
(whereas on a guest, I get no PCI error and eventually threads start
hanging).

This series fixes this case too and the device is added as expected
on a fixed kernel.

So, all seems good!

[  162.618277] pcieport 0000:14:06.0: bridge window [io  0x1000-0x0fff] 
to [bus 1b] add_size 1000
[  162.618905] pcieport 0000:14:06.0: BAR 13: no space for [io  size 0x1000]
[  162.619398] pcieport 0000:14:06.0: BAR 13: failed to assign [io  size 
0x1000]
[  162.619916] pcieport 0000:14:06.0: BAR 13: no space for [io  size 0x1000]
[  162.620410] pcieport 0000:14:06.0: BAR 13: failed to assign [io  size 
0x1000]
[  162.620929] pci 0000:1b:00.0: BAR 0: assigned [mem 
0x83200000-0x833fffff 64bit]
[  162.621472] pcieport 0000:14:06.0: PCI bridge to [bus 1b]
[  162.621872] pcieport 0000:14:06.0:   bridge window [mem 
0x83200000-0x833fffff]
[  162.622398] pcieport 0000:14:06.0:   bridge window [mem 
0x18019000000-0x18019ffffff 64bit pref]
[  162.623411] nvme 0000:1b:00.0: Adding to iommu group 56
[  162.624081] nvme nvme2: pci function 0000:1b:00.0
[  162.624455] nvme 0000:1b:00.0: enabling device (0000 -> 0002)
[  162.627776] nvme nvme2: Removing after probe failure status: -5
[  187.396805] nvme nvme1: I/O 3 QID 0 timeout, reset controller
[  187.399390] nvme nvme1: Identify namespace failed (-4)
[  187.429068] nvme nvme1: Removing after probe failure status: -5

> 
> 
>> Anyway, patch #1 looks OK to me, but I haven't tried to dig further
>> into something that is "oh so last year" ;-). Specially as we're
>> rewriting the whole of the MSI stack! FWIW:
>>
>> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> Thank you again, Marc!
> 
> 
>>
>>          M.
>>
>> -- 
>> Without deviation from the norm, progress is not possible.
