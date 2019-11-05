Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0413CEFC3C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 12:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbfKELUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 06:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbfKELUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 06:20:40 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7ADEF2DE1C
        for <stable@vger.kernel.org>; Tue,  5 Nov 2019 11:20:40 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id 92so12187630wro.14
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 03:20:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5janaQiAy9etIrtoTKNZEMcekAz7aNQTX2gwL6KQh/I=;
        b=CFRH7K7Q6SIfqTyx0Nnu7UHXG+z4T9vQsCXXOtRkGh49aFjRUlYxrvOnd/vnPThWA5
         FDcnc5DFNbGLCVm4MjjBOuxCk8M3+9hhtjT1v50vV/trbTCFp7dYkivCxURUSo2JuwMu
         7Bfk+1niDiMj3TBSvybvYDzWzcfHuUIgeqiilR6wjhSn4+GDEi+P5dWXnCMpPKoOfPD3
         7SgpxuslKHMH81zGpGTvugCFkuAxyuqQK5huNcvOElAFQrlsPbycqBJXOZFZ/oBNTZfc
         cJ2NMDZ4J41t9fKaSr4u6RlYYkiUmI9hY8DLJ9UohULBdrb1xvfLLXWJM44mRGl6ndRP
         HyTg==
X-Gm-Message-State: APjAAAX0sSPOBnf8fuSmoXpbswysKfo/PkVVEac+cV8qlrttYlHqEwJh
        Jn2IPFAQY42hfawqUHy4SRuh5el5333EdSDnDuZCgi0FS50ruNxXr25By7u8cq0Nv2JBYd+2yUp
        8XLqVS0yBTiB5c0XG
X-Received: by 2002:a1c:9dd3:: with SMTP id g202mr3873316wme.43.1572952838951;
        Tue, 05 Nov 2019 03:20:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxsuia9tBKGpWgRmg+Z8P0Q9Irh3IwgwLmy64+8eNcq2e+aQvZmXii8Lt/Qm9y1etzxctpS9A==
X-Received: by 2002:a1c:9dd3:: with SMTP id g202mr3873296wme.43.1572952838688;
        Tue, 05 Nov 2019 03:20:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id s9sm2146939wmj.22.2019.11.05.03.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 03:20:38 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Dynamically allocating MSR number
 lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
 <6ed393eb-6402-ffe2-a652-c4fe51c9d301@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <75a63a8d-6d80-7749-a5c7-da7a43c2f53c@redhat.com>
Date:   Tue, 5 Nov 2019 12:20:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6ed393eb-6402-ffe2-a652-c4fe51c9d301@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/11/19 12:11, Xiaoyao Li wrote:
> On 11/5/2019 6:41 PM, Paolo Bonzini wrote:
>> On 05/11/19 10:20, Chenyi Qiang wrote:
>>> The three msr number lists(msrs_to_save[], emulated_msrs[] and
>>> msr_based_features[]) are global arrays of kvm.ko, which are
>>> initialized/adjusted (copy supported MSRs forward to override the
>>> unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
>>> reset these three arrays to their initial value when uninstalling
>>> kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
>>> will initialize the modified arrays with some MSRs lost and some MSRs
>>> duplicated.
>>>
>>> So allocate and initialize these three MSR number lists dynamically when
>>> installing kvm-{intel,amd}.ko and free them when uninstalling.
>>
>> I don't understand.  Do you mean insmod/rmmod when you say
>> installing/uninstalling? Global data must be reloaded from the ELF file
>> when insmod is executed.
> 
> Yes, we mean insmod/rmmod.
> The problem is that these three MSR arrays belong to kvm.ko but not
> kvm-{intel,amd}.ko. When we rmmod kvm_intel.ko, it does nothing to them.

Ok, thanks for the explanation.

Paolo
