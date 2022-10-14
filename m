Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CC55FF3E7
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 21:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJNTAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 15:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJNTAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 15:00:48 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA325C78;
        Fri, 14 Oct 2022 12:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665774046; x=1697310046;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=GXoD9gRB2Hvbmyc4m6TRPnO3SU6oxhVMCZ99nFZXCTs=;
  b=kmlbJDgDARB2uYSv8s75cK/H/EycW2ZXIKh8BNOgP97RMZUKKYQ3EJlA
   Ae7gF4kERrThUVSyTdGSIRqKYIxf7GDkTYaYwjW120gqrXnH93iQqa82V
   w/NymC6n+ptkN5kEcpXWb6tpja+9JK+yowF8L0+cM5HVI3NtDTcpNU7vu
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,185,1661817600"; 
   d="scan'208";a="140426874"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 19:00:45 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 6B880C090F;
        Fri, 14 Oct 2022 19:00:43 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 14 Oct 2022 19:00:42 +0000
Received: from [192.168.28.131] (10.43.162.230) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 14 Oct 2022 19:00:42 +0000
Message-ID: <0d923959-1b93-6133-6609-ac2c0c5711ee@amazon.com>
Date:   Fri, 14 Oct 2022 12:00:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Content-Language: en-US
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
To:     "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
 <YzmujBxtwUxHexem@kroah.com>
 <58294d242fc256a48abb31926232565830197f02.camel@amazon.com>
 <e35b7856-138c-a255-a32e-41f57ad6f76d@amazon.com>
In-Reply-To: <e35b7856-138c-a255-a32e-41f57ad6f76d@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.230]
X-ClientProxiedBy: EX13D08UWC001.ant.amazon.com (10.43.162.110) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-14.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/9/22 10:50 AM, Bhatnagar, Rishabh wrote:
>
> On 10/6/22 8:07 PM, Herrenschmidt, Benjamin wrote:
>> (putting my @amazon.com hat on)
>>
>> On Sun, 2022-10-02 at 17:30 +0200, Greg KH wrote:
>>
>>
>>> On Thu, Sep 29, 2022 at 09:06:45PM +0000, Rishabh Bhatnagar wrote:
>>>> This patch series backports a bunch of patches related IRQ handling
>>>> with respect to freeing the irq line while IRQ is in flight at CPU
>>>> or at the hardware level.
>>>> Recently we saw this issue in serial 8250 driver where the IRQ was
>>>> being
>>>> freed while the irq was in flight or not yet delivered to the CPU.
>>>> As a
>>>> result the irqchip was going into a wedged state and IRQ was not
>>>> getting
>>>> delivered to the cpu. These patches helped fixed the issue in 4.14
>>>> kernel.
>>> Why is the serial driver freeing an irq while the system is running?
>>> Ah, this could happen on a tty hangup, right?
>> Right. Rishabh answered that separately.
>>
>>>> Let us know if more patches need backporting.
>>> What hardware platform were these patches tested on to verify they
>>> work properly?  And why can't they move to 4.19 or newer if they
>>> really need this fix?  What's preventing that?
>>>
>>> As Amazon doesn't seem to be testing 4.14.y -rc releases, I find it
>>> odd that you all did this backport.  Is this a kernel that you all
>>> care about?
>> These were tested on a collection of EC2 instances, virtual and metal I
>> believe (Rishabh, please confirm).
> Yes these patches were tested on multiple virt/metal EC2 instances.
>>
>> Amazon Linux 2 runs 4.14 or 5.10. Unfortunately we still have to
>> support customers running the former.
>>
>> We'll be including these patches in our releases, we thought it would
>> be nice to have them in -stable as well for the sake of whoever else
>> might be still using this kernel. No huge deal if they don't.
>>
>> As for testing -rc's, yes, we need to get better at that (and publish
>> what we test). Point taken :-)
>>
>> Cheers,
>> Ben.
>>
Hi Greg

Let us know if you think it would be beneficial to take these backports 
for 4.14 stable.
We can drop this patch set otherwise.

Thanks alot,
Rishabh

