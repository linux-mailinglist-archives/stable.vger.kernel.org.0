Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836BD5F8CAF
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJIRuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 13:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJIRuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 13:50:20 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BC5DFB4;
        Sun,  9 Oct 2022 10:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665337818; x=1696873818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1w/EVmNT7psEnsmxWuhy+bUOj1fiP2N+jrdt5vLYEOY=;
  b=QAJxXejz1Peoqowrf4/LrE4r8LlcIUyiXtieCZpilCGL1nVWbmNrlxEr
   mDGQaDAdXqnboGyjTlYJu0S4NNouinoLQVRy0gT76Z6yiHY6Z3fByImb7
   RfCn4HLz190FfZ76zp8yH2y4Z5TtWkOpHdm4tHhsvsqkZVggCwmFr77VS
   E=;
X-IronPort-AV: E=Sophos;i="5.95,172,1661817600"; 
   d="scan'208";a="1062316103"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2022 17:50:18 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id E582B45618;
        Sun,  9 Oct 2022 17:50:17 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Sun, 9 Oct 2022 17:50:17 +0000
Received: from [192.168.22.91] (10.43.160.95) by EX19D002UWC004.ant.amazon.com
 (10.13.138.186) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12; Sun, 9 Oct 2022
 17:50:16 +0000
Message-ID: <e35b7856-138c-a255-a32e-41f57ad6f76d@amazon.com>
Date:   Sun, 9 Oct 2022 10:50:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Content-Language: en-US
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
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
In-Reply-To: <58294d242fc256a48abb31926232565830197f02.camel@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.95]
X-ClientProxiedBy: EX13D03UWA004.ant.amazon.com (10.43.160.250) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-15.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/6/22 8:07 PM, Herrenschmidt, Benjamin wrote:
> (putting my @amazon.com hat on)
>
> On Sun, 2022-10-02 at 17:30 +0200, Greg KH wrote:
>
>
>> On Thu, Sep 29, 2022 at 09:06:45PM +0000, Rishabh Bhatnagar wrote:
>>> This patch series backports a bunch of patches related IRQ handling
>>> with respect to freeing the irq line while IRQ is in flight at CPU
>>> or at the hardware level.
>>> Recently we saw this issue in serial 8250 driver where the IRQ was
>>> being
>>> freed while the irq was in flight or not yet delivered to the CPU.
>>> As a
>>> result the irqchip was going into a wedged state and IRQ was not
>>> getting
>>> delivered to the cpu. These patches helped fixed the issue in 4.14
>>> kernel.
>> Why is the serial driver freeing an irq while the system is running?
>> Ah, this could happen on a tty hangup, right?
> Right. Rishabh answered that separately.
>
>>> Let us know if more patches need backporting.
>> What hardware platform were these patches tested on to verify they
>> work properly?  And why can't they move to 4.19 or newer if they
>> really need this fix?  What's preventing that?
>>
>> As Amazon doesn't seem to be testing 4.14.y -rc releases, I find it
>> odd that you all did this backport.  Is this a kernel that you all
>> care about?
> These were tested on a collection of EC2 instances, virtual and metal I
> believe (Rishabh, please confirm).
Yes these patches were tested on multiple virt/metal EC2 instances.
>
> Amazon Linux 2 runs 4.14 or 5.10. Unfortunately we still have to
> support customers running the former.
>
> We'll be including these patches in our releases, we thought it would
> be nice to have them in -stable as well for the sake of whoever else
> might be still using this kernel. No huge deal if they don't.
>
> As for testing -rc's, yes, we need to get better at that (and publish
> what we test). Point taken :-)
>
> Cheers,
> Ben.
>
