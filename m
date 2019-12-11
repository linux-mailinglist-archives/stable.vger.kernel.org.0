Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F56B11A675
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 10:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfLKJIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 04:08:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727888AbfLKJIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 04:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576055278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+7CWlGvo3J1aqX5URICLxANHtApPrtUz6Ly50hT0k8=;
        b=OAFFQcbl+GANBHUp05SJjRbuv9zIXvKUiDKVKmHAAMiZH85MA7AnQS8wzu/mfHwW+r7EZr
        3ziip3zZVi3GFrbVwdjEBGhttLm91ko5grBeA6ow+dyP0euq0fYvOe5w06AcsRnEIafAkU
        hpHmLnJQfK+M51RLQG0C+SZA63IlSKk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-oV301jayNgOqIBSHTnp3tQ-1; Wed, 11 Dec 2019 04:07:58 -0500
Received: by mail-wm1-f69.google.com with SMTP id l11so362801wmi.0
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 01:07:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+7CWlGvo3J1aqX5URICLxANHtApPrtUz6Ly50hT0k8=;
        b=qF7bwHuw3kDdDMCbs3mHa2dgR2PbVkvYV5X6Lh8wHYdhBVd8xRClYdtYNcCAyb6BiD
         5BXOoVW/qUvZGHZeGdDiPx+2u4V9r2iyuDaVa17Vkx/5X3XQSX4ng2YUTqe9oy5zItDK
         lEcuk/CjNSfY9pnZZliONHZaQEvPauOLxdSsPghCEEODbbBaLEI6kI/oa/Lq74Tie9v1
         CQX7FFDvV8r7nu22tEcQLs8jjKXx8u3fqHYsK7Qp7PSq5UaKN3/MXcCDryFLb5L2hhVq
         kFCsXRclqNNMnPwqxSznuLIo9D4OgQy//GOe/TtgRdSp72M2uL3+11/8TImtXovlWKuO
         JqhQ==
X-Gm-Message-State: APjAAAXa0yxp6cuoqeM+Ps3OYKJLukxPsbBvGLD+Z8hwtlb6Tuhhcy+h
        7KMG30nzP/miJUxL9/6eWB3UbR+aj0pNPTXoW07kUHBeDsKjXaZQjrZJySRLWeTsQ6s/LMCK34f
        d4pRO3VWShRU0HCwk
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr2392693wrw.255.1576055276747;
        Wed, 11 Dec 2019 01:07:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqyk530KPtCatGmVOoZqOVtdEa4CHIdMd2QUgErjQSW25mSow9KbdltraJ00JOs309bCAh7DDw==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr2392670wrw.255.1576055276544;
        Wed, 11 Dec 2019 01:07:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id g2sm1496891wrw.76.2019.12.11.01.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 01:07:55 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     "Huang, Kai" <kai.huang@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
 <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
 <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <62438ac9-e186-32a7-d12f-5806054d56b2@redhat.com>
Date:   Wed, 11 Dec 2019 10:07:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
Content-Language: en-US
X-MC-Unique: oV301jayNgOqIBSHTnp3tQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/12/19 01:11, Huang, Kai wrote:
>> kvm_get_shadow_phys_bits() must be conservative in that:
>>
>> 1) if a bit is reserved it _can_ return a value higher than its index
>>
>> 2) if a bit is used by the processor (for physical address or anything
>> else) it _must_ return a value higher than its index.
>>
>> In the SEV case we're not obeying (2), because the function returns 43
>> when the C bit is bit 47.  The patch fixes that.
> Could we guarantee that C-bit is always below bits reported by CPUID?

That's a question for AMD. :)  The C bit can move (and probably will,
otherwise they wouldn't have bothered adding it to CPUID) in future
generations of the processor.

Paolo

