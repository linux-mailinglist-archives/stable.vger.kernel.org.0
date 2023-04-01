Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110BD6D3101
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjDANYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Apr 2023 09:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDANYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Apr 2023 09:24:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A12B4EEA;
        Sat,  1 Apr 2023 06:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFCE60E17;
        Sat,  1 Apr 2023 13:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2362BC433D2;
        Sat,  1 Apr 2023 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680355435;
        bh=sAx2eyoHZphV7y6Ejbx4McAtoXE+uA+9ASpvRgIQZqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=igOLlc1qJ2ipXS93uDABV2VrzqSUuSQSg+ylXfKyUAr3oN5Qn0iBWTg/F/Eedj8oh
         f+H+R07Mmu9Q9uBvm98/yFjL8KThB6e4nSI3jvTOfCeiaXg429ouI2wJrwFOXYjcr1
         VFJCH4cqp8IR/rvt3rCD62qmAHqTZMo9PaggzYJr8SqnKKT0OnBEL2mqNiFi8cxYe3
         ahlx+kh4oGJEr9Vm5BdDL6KIQlmMRWjAcGb66nw8ktlC1xSLs9YPIlhD+dD6O9zgze
         13Mi9SnyeSK1xgAWyayjM0M4dy1qezVRWC08kwUx9yhIP0mEwrHmhcFuBk7LE3FxDq
         v2GyatgGzZ2Yg==
Date:   Sat, 1 Apr 2023 09:23:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        lwn@lwn.net, jslaby@suse.cz,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: Linux 5.15.103
Message-ID: <ZCgwaWSgnUWAPyiv@sashalap>
References: <1679040264214179@kroah.com>
 <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
 <ZCLaLWJiIsDV5yGr@kroah.com>
 <f86cb36e-b331-8b8d-f087-5e2e8a5ae962@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f86cb36e-b331-8b8d-f087-5e2e8a5ae962@grsecurity.net>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 02:29:11PM +0200, Mathias Krause wrote:
>On 28.03.23 14:14, Greg Kroah-Hartman wrote:
>> On Tue, Mar 28, 2023 at 02:02:03PM +0200, Mathias Krause wrote:
>>> On 17.03.23 09:04, Greg Kroah-Hartman wrote:
>>>> I'm announcing the release of the 5.15.103 kernel.
>>>>
>>>> [...]
>>>>
>>>> Vitaly Kuznetsov (4):
>>>>       KVM: Optimize kvm_make_vcpus_request_mask() a bit
>>>>       KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
>>>>       KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
>>>>       KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
>>>>
>>>
>>> That list is missing commit 6470accc7ba9 ("KVM: x86: hyper-v: Avoid
>>> calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL") to fulfill
>>> the prerequisite of "KVM: Optimize kvm_make_vcpus_request_mask() a bit".
>>>
>>> Right now the kvm selftests trigger a kernel NULL deref for the hyperv
>>> test, making the system hang.
>>>
>>> Please consider applying commit 6470accc7ba9 for the next v5.15.x release.
>>
>> It wasn't tagged for the stable kernels, so we didn't pick it up :(
>
>Neither were any of the above commits. o.O
>
>Commit 3e48a6349d29 ("KVM: Optimize kvm_make_vcpus_request_mask() a
>bit") has this tag, though:
>
>Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last
>thing during initialization")
>
>I don't know why, though. These two commits have little in common.
>Maybe Sasha knows why?

Because you've skipped the commit in the middle of the two you've
pointed out :)

3e48a6349d29 is needed by 0a0ecaf0988b ("KVM: Pre-allocate cpumasks for
kvm_make_all_cpus_request_except()"), which in turn is needed by
2b0128127373.

-- 
Thanks,
Sasha
