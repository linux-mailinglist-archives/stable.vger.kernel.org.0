Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898E111836C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 10:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLJJUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 04:20:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34409 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726883AbfLJJUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 04:20:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bYiIJtudCWkuxmJ3U7uh+uE9YOFh6uPtLmRweTcPTI=;
        b=VRigSIQvgmmL3aTkFvwbmeqOOgiDDJqpDX1K809rTgR8Pznicw4pRpjHZFVTQfF8r43C4n
        LR8yYgNOV3lPtOMirGxAxzyf3/FeBjS/vqf8Z5FyNwl3hZopFvL/B4xlgT33KcApEhy4FU
        vPP0BNrqrpW+uNA2TqN+dDQiGn3aRHI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-SVLwobqzOX2mx22gYMRc_Q-1; Tue, 10 Dec 2019 04:19:59 -0500
Received: by mail-wm1-f69.google.com with SMTP id b131so754271wmd.9
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 01:19:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/bYiIJtudCWkuxmJ3U7uh+uE9YOFh6uPtLmRweTcPTI=;
        b=l7ERx7aYO+jP+DPudksAEWXt5EO/yHDwk82k1H/vriJBWoBMB8UKxNCpWQqfR+7kr7
         6gF/27cs73poXLNYcFsA1/BJHlIYglNVWgKsc/EBGunH1HMqKYrKatsvWV7qA8MKJuwt
         ohLhg4CzX9k9JOLXwtPZWYnEKANHBjuFfRL5A1QsEpTbUYBUxy3yHHdIDhTyL2ZzeV+C
         oqIj/JRkiDjSeDKcSNhwtqL8sqwXWPr8OyAEMp+A0ouLjTh4661YX11QPr+1CqVUi6Ep
         oiWWg2TNObuq9SQIICOnIXSY8g2eiSNKGC7D3d/bjtW93dSM/LV3hSicsNT1yDsHEhQx
         e/vQ==
X-Gm-Message-State: APjAAAVGkwLZz5j6nahkayULNLlX/mjD9OhH8bS9O5tSKV6UuIEbbZn6
        req0BgOa/JFe0oaKNxhfSn4QrRHf7+l467hMTLkExOKwzjzisoFXEiCLvqZ5kV+jYgfbupIO+CQ
        liBTSyks0ESPj7v8a
X-Received: by 2002:adf:f803:: with SMTP id s3mr1955415wrp.7.1575969597795;
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzDnyT2KZKAXq1IvkcmoircMXuSHIe+B7ZX1hbvwigcGPf4Y/msYzb6HapPfHPkh1RodEdyw==
X-Received: by 2002:adf:f803:: with SMTP id s3mr1955389wrp.7.1575969597600;
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id m3sm2549644wrs.53.2019.12.10.01.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 01:19:57 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, stable@vger.kernel.org
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <20191204154806.GC6323@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9951afb8-8f91-2fe1-3893-04307fafa570@redhat.com>
Date:   Tue, 10 Dec 2019 10:19:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191204154806.GC6323@linux.intel.com>
Content-Language: en-US
X-MC-Unique: SVLwobqzOX2mx22gYMRc_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/19 16:48, Sean Christopherson wrote:
>> +	/*
>> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
>> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
>> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
> No love for MKTME?  :-D

I admit I didn't check, but does MKTME really require CPUID leaves in
the "AMD range"?  (My machines have 0x80000008 as the highest supported
leaf in that range).

Paolo

