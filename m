Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3303167A4CF
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbjAXVSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbjAXVSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:18:03 -0500
X-Greylist: delayed 3292 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Jan 2023 13:17:28 PST
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9EE51C72
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 13:17:28 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pKPoO-00ESTv-C3; Tue, 24 Jan 2023 21:22:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=ofpnODegQDOIRCO2eZN2SpGGzNBUu2sXhCtmyK94QM4=; b=eD07QtPIUxEY6K58yJAcgjTCJI
        fR61X2nt7aWWjOa3y8vvkRlm2332FFy4uo6pjGeuLB+3ZyeJJJd1fq/MvBRnQJTKcM/WRQJ0IA+xn
        w+jsF166ItraAHI3eWsCei5g79qfoVLwe8GvdERV9zqqIANo7+PHbGR4zcqn2STHxxwt+zXAxQLXI
        KwcSoajLmtYWpF67B8ErK25bNyCMyDvSYCALzK1ToWJKVVMXZiElGtPjpp4rmMW20mMIpfFqkHt2Y
        WN9MlhEOOUGdZjmF3++nKQJx6cPPEeeQ4HMY3eaaBgVBsrPFT/evkxdatR85gbyiXqtDyKGx7qbNY
        B+mbfEWA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pKPoN-0001OO-8D; Tue, 24 Jan 2023 21:22:31 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pKPoH-0005lf-HN; Tue, 24 Jan 2023 21:22:25 +0100
Message-ID: <85285ccd-7b1a-9a94-5471-8036cb824b28@rbox.co>
Date:   Tue, 24 Jan 2023 21:22:23 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Content-Language: pl-PL
To:     Sean Christopherson <seanjc@google.com>,
        Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
References: <20221229123302.4083-1-wei.w.wang@intel.com>
 <Y88XYR0L2DyiKnIM@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y88XYR0L2DyiKnIM@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/23 00:25, Sean Christopherson wrote:
> On Thu, Dec 29, 2022, Wei Wang wrote:
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 2a3ed401ce46..1b277afb545b 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
>>  		bus = kvm_get_bus(kvm, bus_idx);
>>  		if (bus)
>>  			bus->ioeventfd_count--;
>> -		ioeventfd_release(p);
>>  		ret = 0;
>>  		break;
>>  	}

I was wondering: would it make sense to simplify from
list_for_each_entry_safe() to list_for_each_entry() in this loop?

>> @@ -5453,18 +5459,18 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>>  	synchronize_srcu_expedited(&kvm->srcu);
>>  
>> -	/* Destroy the old bus _after_ installing the (null) bus. */
>> +	/*
>> +	 * If (null) bus is installed, destroy the old bus, including all the
>> +	 * attached devices. Otherwise, destroy the caller's device only.
>> +	 */
>>  	if (!new_bus) {
>>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
>> -		for (j = 0; j < bus->dev_count; j++) {
>> -			if (j == i)
>> -				continue;
>> -			kvm_iodevice_destructor(bus->range[j].dev);
>> -		}
>> +		kvm_io_bus_destroy(bus);
>> +		return -ENOMEM;
> 
> Returning an error code is unnecessary if unregister_dev() destroys the bus.
> Nothing ultimately consumes the result, e.g. kvm_vm_ioctl_unregister_coalesced_mmio()
> intentionally ignores the result other than to bail from the loop, and destroying
> the bus means it will immediately bail from the loop anyways.

But it is important to know _if_ the bus was destroyed, right?
IOW, doesn't your comment from commit 5d3c4c79384a still hold?

    (...) But, it doesn't tell the caller that it obliterated the
    bus and invoked the destructor for all devices that were on the bus.  In
    the coalesced MMIO case, this can result in a deleted list entry
    dereference due to attempting to continue iterating on coalesced_zones
    after future entries (in the walk) have been deleted.

Michal

