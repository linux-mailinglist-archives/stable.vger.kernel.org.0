Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64D8EFC19
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 12:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfKELL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 06:11:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:50813 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbfKELL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 06:11:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 03:11:28 -0800
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="195785415"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 05 Nov 2019 03:11:25 -0800
Subject: Re: [PATCH] KVM: X86: Dynamically allocating MSR number
 lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191105092031.8064-1-chenyi.qiang@intel.com>
 <8ab7565c-df06-b5a5-d02d-899ba976414b@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <6ed393eb-6402-ffe2-a652-c4fe51c9d301@intel.com>
Date:   Tue, 5 Nov 2019 19:11:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8ab7565c-df06-b5a5-d02d-899ba976414b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/5/2019 6:41 PM, Paolo Bonzini wrote:
> On 05/11/19 10:20, Chenyi Qiang wrote:
>> The three msr number lists(msrs_to_save[], emulated_msrs[] and
>> msr_based_features[]) are global arrays of kvm.ko, which are
>> initialized/adjusted (copy supported MSRs forward to override the
>> unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
>> reset these three arrays to their initial value when uninstalling
>> kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
>> will initialize the modified arrays with some MSRs lost and some MSRs
>> duplicated.
>>
>> So allocate and initialize these three MSR number lists dynamically when
>> installing kvm-{intel,amd}.ko and free them when uninstalling.
> 
> I don't understand.  Do you mean insmod/rmmod when you say
> installing/uninstalling? Global data must be reloaded from the ELF file
> when insmod is executed.

Yes, we mean insmod/rmmod.
The problem is that these three MSR arrays belong to kvm.ko but not 
kvm-{intel,amd}.ko. When we rmmod kvm_intel.ko, it does nothing to them.

> How is the bug reproducible?

Suppose there is an intel machine.

1. You can first run
	#rmmod kvm-intel.ko
	#insmod kvm-intel.ko nested=0
2. and then
	#rmmod kvm-intel.ko
	#insmod kvm-intel.ko nested=1

In step 1, all the vmx-related MSRs in msr_based_features[] are not 
supported due to nested=0. And it will move MSR_IA32_UCODE_REV and 
MSR_IA32_ARCH_CAPABILITIES (on my Cascadelake server) forward to 
override array member 0 and 1 (MSR_IA32_VMX_BASIC and 
MSR_IA32_VMX_TRUE_PINBASED_CTLS).

In step 2, we just lose MSR_IA32_VMX_BASIC and 
MSR_IA32_VMX_TRUE_PINBASED_CTLS of VMX and get duplicated 
MSR_IA32_UCODE_REV and MSR_IA32_ARCH_CAPABILITIES.

> Paolo
> 
