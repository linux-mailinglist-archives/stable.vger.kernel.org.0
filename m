Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A16C520A
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 18:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjCVRPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 13:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjCVRPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 13:15:53 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9813664C7;
        Wed, 22 Mar 2023 10:15:23 -0700 (PDT)
Received: from [192.168.2.24] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 23AAD20FB61D;
        Wed, 22 Mar 2023 10:07:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 23AAD20FB61D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679504852;
        bh=wIsk4VwZDr4i8NB881GJXyBcyN6S4COQ4x0IkZr3KZc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mWhRSBZfExqgWD10q75sV5rrToRw+UGv6h02KGIlks+eaU7nU4rVaYg0qmSaKO2PU
         nyQ0oWcfv5yq/CHy6iU19RDCjBaWjoxtOPkC5vkO8m/+ut0ivy+ENkXWW01zj6usM/
         lOdNfAQr5LqSgCdPwxzkGr7jgGG04guEUmN4pN+Q=
Message-ID: <be381bad-3331-495d-d5a5-acf8ae9d6a8e@linux.microsoft.com>
Date:   Wed, 22 Mar 2023 18:07:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
 <ZBsqxeRDh+iV8qmm@google.com> <87355wralt.fsf@redhat.com>
 <ZBs0fTo72LjnR22r@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZBs0fTo72LjnR22r@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/03/2023 18:01, Sean Christopherson wrote:
> On Wed, Mar 22, 2023, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
>>> index cff838f15db5..d91e019fb7da 100644
>>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>>> @@ -15,6 +15,13 @@ static struct kvm_x86_ops svm_x86_ops;
>>>  
>>>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>>>  
>>> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
>>> +
>>> +	return !!hve->hv_enlightenments_control.enlightened_npt_tlb;
>>
>> In theory, we should not look at Hyper-V enlightenments in VMCB control
>> just because our kernel has CONFIG_HYPERV enabled.
> 
> Oooh, right, because hv_enlightenments uses software reserved bits, and in theory
> KVM could be running on a different hypervisor that uses those bits for something
> completely different.
> 
>> I'd suggest we add a
>> real check that we're running on Hyper-V and we can do it the same way
>> it is done in svm_hv_hardware_setup()/svm_hv_init_vmcb():
>>
>> 	return (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
>> 		&& !!hve->hv_enlightenments_control.enlightened_npt_tlb;
> 
> Jeremi, if you grab this, can you put the && on the previous line?  I.e.
> 
> 	return (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) &&
> 	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;

Will do. I'll need to read the replies in more detail tomorrow.
