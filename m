Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E9D45CBF8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348801AbhKXSXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243787AbhKXSXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 13:23:23 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C9DC061574;
        Wed, 24 Nov 2021 10:20:12 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y12so14293962eda.12;
        Wed, 24 Nov 2021 10:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5X/H5cpbOg8DWFCvCb2zd7KFfrCv4djQdmOexLgCbLM=;
        b=pSsXQ2GywQe7hPQjiSgm8OUXlyw/ElJg6+HZ1gtYjlBDFWjTScsfbsb/0BDZ3I1vL1
         dyoVXbua6b1tQbd2W+l0gJjIXrhPzgGPAGeQM1pI8OhZsV25I6wD43Il7oyeMxjK2EW7
         qNxOlutV8iWfwC0y5WNDEQAu8acp2EnKHpHi0ELstbWO3gwXCDvyjUvY81+ptfCxSTyU
         9mHY278XOCyAwKBBbvsE6k+Swx/0Q8q5fh6LaDIofn+wzOIVLPc03PZrsZmiiPR0nYM3
         5eLEWD1XTwm4+yEJXhapOQH0sXCFOTOU7XvZjwijXIKudT1tEQDAMpmd8PIj9dkJRBF1
         3owg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5X/H5cpbOg8DWFCvCb2zd7KFfrCv4djQdmOexLgCbLM=;
        b=ZnVB0Z6a68BnIASIsmb7glQgAwn5qvleEmzkcedyz75dyCj9lg301LDhIHudVsnWbT
         dsN74Kqj3MbfM/lZzECNzZiqCJaHRGX9PDZNrYUerFADBU2CTGwuyEa7ASkcDENyyPOu
         r70tu+E1bvnSGf2jK2k+U6C/OA65AFuzjd4gGQTCmY8RWqcfrLAwR96ZuZFop7S3FpXA
         UfMrW4dXzcKanOwVnRIqetDuTbIWraJv7Nvgwj1GQ8lX6Rd4CKxsxqexICvkTPdU2Gz8
         5JQniNKeuid2h0QXIKLIqT2aWuUZqE/391phiNgvKs/RUEUYcJpTzqGf198zSm4zNa/Y
         J96A==
X-Gm-Message-State: AOAM533BVFOqwJzYWfCtpdQBlYUJAslXactnE9hA0t3gW2+GEfycIq2S
        nbeEjTcXgd4AIvcLNZs57Mk=
X-Google-Smtp-Source: ABdhPJz2nnnjfaOKn/GWtWInlU0rOpQ8j3J38ut24SU5TJNwQEm/jYBV++SpSTtNHRmjwxzpWaqTlA==
X-Received: by 2002:a17:907:6d07:: with SMTP id sa7mr23312627ejc.339.1637778010878;
        Wed, 24 Nov 2021 10:20:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z6sm484493edc.76.2021.11.24.10.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 10:20:10 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8b3b34a6-3aba-8471-453b-f15935edf438@redhat.com>
Date:   Wed, 24 Nov 2021 19:20:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 1/8] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211123163630.289306-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211123163630.289306-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/21 17:36, Sasha Levin wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> [ Upstream commit e45e9e3998f0001079b09555db5bb3b4257f6746 ]
> 
> The KVM doesn't know whether any TLB for a specific pcid is cached in
> the CPU when tdp is enabled.  So it is better to flush all the guest
> TLB when invalidating any single PCID context.
> 
> The case is very rare or even impossible since KVM generally doesn't
> intercept CR3 write or INVPCID instructions when tdp is enabled, so the
> fix is mostly for the sake of overall robustness.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> Message-Id: <20211019110154.4091-2-jiangshanlai@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

for this patch, but not to all the others.

Paolo
