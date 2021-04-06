Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807C7355B7C
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhDFSgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 14:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239302AbhDFSgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 14:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617734162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onYMsdqIwwMtCr/o99OSThEm1roisnCtNhad6j+yKxI=;
        b=XZGUU0HVW5I2L7PPT4NVGK+/ds3rGnG4W1t/E4HO9QqNahw81DTQUbFeiHYs/Z4ksAsz1l
        NrszE6ITzyCeFazN0JT7R7xBv16kr2/XOgN4OdagD8vawiQB68HroL06iG9gTklOAE3ML3
        78iYlPkJISRitXND9dJoF9p9GrpD8mU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-H4WCYQVaN5ekBmwDG1sxBA-1; Tue, 06 Apr 2021 14:35:58 -0400
X-MC-Unique: H4WCYQVaN5ekBmwDG1sxBA-1
Received: by mail-ej1-f72.google.com with SMTP id e23so1336998ejt.19
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 11:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onYMsdqIwwMtCr/o99OSThEm1roisnCtNhad6j+yKxI=;
        b=aliKoq2uxWl+fqVyyBsFSE0bAlxQI6zBwyrEuoM3fetqg9zPtB1zDdwvAK86SjPHUd
         NXkifrH1j3jBruhyiR8FFH947sMl1b157N744DpIOPqCugghmhZiPZ5puVAZGPvhjZNZ
         LF1eLReiq5i6hvvcNVcjpbEojqivLlSeX0YCYLcMUppLdIhXLBkaSC0ZUKGhF3v+V0FO
         RKx37AHtQkI8YDBQ8ZXtktmulS8c4uIo8l1g7SshV2LMVyWQ8G1vQ8UOA3KOHLilC8dw
         9KQ8FC82KZHdCmeyW34fqqwMxp/SW+nwNBpB0MgJ1EFaOR4BrzYQM9nQK/wSatdu4aCE
         e10Q==
X-Gm-Message-State: AOAM531KAAaCF+v7GoIBywnxj5LmmqnfTK8g2xjWCxuU00iF5RhQmAq+
        QBSgNukWTpmNo951VnO+txfTrx1Oj2LHbxl9y+P+zEZA9CyhWCfdgxjRnCGWOvhUpsZvg34ufX3
        v39grbC3rt1pI9o/pg8ZjzhD0Mj0bx9t581K3GMkoI3fPBBxqwGJj89GP69Qc8wJFiukH
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr1792144ejf.145.1617734157090;
        Tue, 06 Apr 2021 11:35:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+m3afEzHGEFBRSYcpNWuNWxD4R4p0GKyEey8a1eUb3RGjB3HAAYaJy/46vwEJJQyto184DQ==
X-Received: by 2002:a17:906:c09:: with SMTP id s9mr1792113ejf.145.1617734156774;
        Tue, 06 Apr 2021 11:35:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b24sm1413630ejq.75.2021.04.06.11.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 11:35:56 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
References: <20210406162550.3732490-1-pbonzini@redhat.com>
 <YGynf54vwWpyxhz4@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d93cb5c8-e54a-6f5a-c660-9d044ff2c743@redhat.com>
Date:   Tue, 6 Apr 2021 20:35:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGynf54vwWpyxhz4@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/21 20:25, Greg KH wrote:
> On Tue, Apr 06, 2021 at 12:25:50PM -0400, Paolo Bonzini wrote:
>> Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
>> will skip the TLB flush, which is wrong.  There are two ways to fix
>> it:
>>
>> - since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
>>    the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
>>    use "flush |= ..."
>>
>> - or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
>>    to __kvm_tdp_mmu_zap_gfn_range.
>>
>> This patch does the former to simplify application to stable kernels.
>>
>> Cc: seanjc@google.com
>> Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
>> Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
>> Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Is this for only the stable kernels, or is it addressed toward upstream
> merges?
> 
> Confused,

It's for upstream.  I'll include it (with the expected "[ Upstream 
commit abcd ]" header) when I post the complete backport.  I'll send 
this patch to Linus as soon as I get a review even if I don't have 
anything else in the queue, so (as a general idea) the full backport 
should be sent and tested on Thursday-Friday.

Paolo

