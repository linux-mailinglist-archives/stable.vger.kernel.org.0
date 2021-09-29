Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468BB41C509
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbhI2M7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 08:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343943AbhI2M7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 08:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632920258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpZea9PfMakNmCoBD5I1m62foJfzIGiMSLO3InTSSbU=;
        b=A3fEYFxvLIYW4/WCAjvdzN8wjJno14RcZ7lSvj8+c4Oe954TDSvN2kP5Iviglz4mz5z+n+
        E9JVPUiIgby99zsF3bbzf9kQg7zCO8flMbqtZVIDMUhSfPnyNdoAlT/Netx0NFgXKwCqro
        HnGhOfw3O9tAkxrnRtSUfuNOQ+S0IDE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459--YAGKtl_OqWXimC-QF-upw-1; Wed, 29 Sep 2021 08:57:37 -0400
X-MC-Unique: -YAGKtl_OqWXimC-QF-upw-1
Received: by mail-ed1-f72.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso2345263edi.1
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 05:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bpZea9PfMakNmCoBD5I1m62foJfzIGiMSLO3InTSSbU=;
        b=3Aslwswv7UK45O4W1BQzt2kuJZMu+XloKP3DdAKSxnTDTQ6vKqAM/QhaP1V0V2EDfS
         g0CRFDVCerFwMqZVQE20a4A7z9IXszQ1491KGOy8WRuXNFCeYvpBhSX2hWTPuh7M5gyE
         j1/WATppLjz4UWR0SbJ9CTGIbpcEbEbOOmyXLbIAuGuxkivqysacqg83oXZhbN7t5TAZ
         +iBSALFCaPmx6Gn3EfkpT1Ibs+aR3Q/YLzT9MPkdnJR+r95vPw19V+cp3/1ofyRNiPVN
         DK20SvKH9V9XYmg7sEvmeBkY9ue5IAKwmcHbcj+t8/O7S50nZ4xxc8AyC4uQDuYTmhNE
         h5aw==
X-Gm-Message-State: AOAM5307l38KHMu3pReooZLVrr4c4dbSXU4sPdUiq+jKHi6PVmB+SxcC
        c5eMv5rWH5t5oshgczfIuAVR48sju4WIB46nS4tqDQiJYyVahoLTXXk39QzfLMzxFb/jp8vfDfc
        E+EQQ9jl9aKToGHU/
X-Received: by 2002:a17:906:facf:: with SMTP id lu15mr13847349ejb.93.1632920256322;
        Wed, 29 Sep 2021 05:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLC1v3Po7islv73cKGJ2aC+qXBOQrx7DNPXg7NAfW1+AgjzaOohtOVUPjZiE/wftSniaBSEQ==
X-Received: by 2002:a17:906:facf:: with SMTP id lu15mr13847335ejb.93.1632920256155;
        Wed, 29 Sep 2021 05:57:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k10sm1382488ejo.117.2021.09.29.05.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:57:35 -0700 (PDT)
Message-ID: <e194b33f-cc6e-bdfe-186b-12fa37b81a3e@redhat.com>
Date:   Wed, 29 Sep 2021 14:57:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/2] Fix wild/dangling pointer in x86 ptp_kvm
Content-Language: en-US
To:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
References: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/09/21 07:13, Zelin Deng wrote:
> When I was doing PTP_SYS_OFFSET_PRECISE ioctl in VM which has 128 vCPUs,
> I got error returned occasionally. Then I checked the routine of
> "getcrosststamp". I found in kvm_arch_ptp_get_crosststamp() of x86,
> pvclock vcpu time info was got from hv_clock arrary which has only 64
> elements. Hence this ioctl is executed on vCPU > 64, a wild/dangling
> pointer will be got, which had casued the error.
> To confirm this finding, I wrote a simple PTP_SYS_OFFSET_PRECISE ioctl
> test and used "taskset -c n" to run the test, when it was executed on
> vCPUs >= 64 it returned error.
> This patchset exposes this_cpu_pvti() to get per cpu pvclock vcpu time
> info of vCPUs >= 64 insdead of getting them from hv_clock arrary.
> 
> Zelin Deng (2):
>    x86/kvmclock: Move this_cpu_pvti into kvmclock.h
>    ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
> 
>   arch/x86/include/asm/kvmclock.h | 14 ++++++++++++++
>   arch/x86/kernel/kvmclock.c      | 13 ++-----------
>   drivers/ptp/ptp_kvm_x86.c       |  9 ++-------
>   3 files changed, 18 insertions(+), 18 deletions(-)
> 

Queued, thanks.

Paolo

