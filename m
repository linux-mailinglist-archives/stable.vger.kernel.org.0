Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF86E63B15F
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 19:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiK1Sc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 13:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiK1Sbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 13:31:39 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08D419289
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669660086; x=1701196086;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MAyxQtNicqvP3IaJSN+h3u46GfcwrPmRhhCAxiwZHEU=;
  b=i0VacUIFLQAdZ7xTRn6Ug889E6C7CHXr3peLBnPAydFT7dfClnpwF/o/
   BXAhtNDkLlykXpVTmfyHW56d5ihVeWGmxuk+RelRcDWzbGZTgDzLxIV+4
   qcsT8mlNF9VNPlLXOgjGP+CNPDxnp278jHlQESurXJ8L7jD9dtX19IoUV
   4=;
X-IronPort-AV: E=Sophos;i="5.96,200,1665446400"; 
   d="scan'208";a="244332499"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 18:27:58 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id B370BA2989;
        Mon, 28 Nov 2022 18:27:56 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 28 Nov 2022 18:27:55 +0000
Received: from [10.136.11.48] (10.43.161.14) by EX19D028UEC003.ant.amazon.com
 (10.252.137.159) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 28 Nov
 2022 18:27:54 +0000
Message-ID: <8b594878-17a2-a708-7102-2e50aabb114b@amazon.com>
Date:   Mon, 28 Nov 2022 13:27:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATH stable 5.15, 5.10 0/4] Fix EBS volume attach on AWS ARM
 instances
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
CC:     <stable@vger.kernel.org>, <tglx@linutronix.de>,
        <lcapitulino@gmail.com>
References: <cover.1669655291.git.luizcap@amazon.com>
 <86h6yjm0cs.wl-maz@kernel.org>
From:   Luiz Capitulino <luizcap@amazon.com>
In-Reply-To: <86h6yjm0cs.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D18UWA001.ant.amazon.com (10.43.160.11) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-12.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2022-11-28 12:53, Marc Zyngier wrote:
> On Mon, 28 Nov 2022 17:08:31 +0000,
> Luiz Capitulino <luizcap@amazon.com> wrote:
>> Hi,
>>
>> [ Marc, can you help reviewing? Esp. the first patch? ]
>>
>> This series of backports from upstream to stable 5.15 and 5.10 fixes an issue
>> we're seeing on AWS ARM instances where attaching an EBS volume (which is a
>> nvme device) to the instance after offlining CPUs causes the device to take
>> several minutes to show up and eventually nvme kworkers and other threads start
>> getting stuck.
>>
>> This series fixes the issue for 5.15.79 and 5.10.155. I can't reproduce it
>> on 5.4. Also, I couldn't reproduce this on x86 even w/ affected kernels.
> That's because x86 has a very different allocation policy compared to
> what the ITS does. The x86 vector space is tiny, so vectors are only
> allocated when required. In your case, that's when the CPUs are
> onlined.
>
> With the ITS, all the vectors are allocated upfront, as this is
> essentially free. But in the case of managed interrupts, these vectors
> are now pointing to offline CPUs. The ITS tries to fix that, but
> doesn't nearly have enough information. And the correct course of
> action is to keep these interrupts in the shutdown state, which is
> what the series is doing.

Thank you for the explanation, Marc. I also immensely

appreciate the super fast response! (more below).


>
>> An easy reproducer is:
>>
>> 1. Start an ARM instance with 32 CPUs
> To satisfy my own curiosity, is that in a guest or bare metal? It
> shouldn't make any difference, but hey...

This is a guest. I'll test on a bare-metal instance, it may

take a few hours. I'll reply here.


> Anyway, patch #1 looks OK to me, but I haven't tried to dig further
> into something that is "oh so last year" ;-). Specially as we're
> rewriting the whole of the MSI stack! FWIW:
>
> Acked-by: Marc Zyngier <maz@kernel.org>

Thank you again, Marc!


>
>          M.
>
> --
> Without deviation from the norm, progress is not possible.
