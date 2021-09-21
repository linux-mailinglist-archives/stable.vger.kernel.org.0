Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82243413560
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhIUOcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233519AbhIUOcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632234667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOX0Dc/uscmy0FcdNSM5vS8dhWPJhduTSx1fXAnSXC8=;
        b=FwYtxjDjVCw9V/TUF/Wb9IJf5yoNA8Doc6Rwg0J7vse7+RufmDQJJjvOeF0DyEU1DRwcHy
        qAP2qhZIbo1eI6rItaSjj+rOrRolqVENP08qnseiteVadyWk6DusflwTp2bSggqOLY9Ql+
        ZXwd5eU0oTZh+spYV+2JHR38D60ysU0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-33d4yFOfNJatK1i1jflv6w-1; Tue, 21 Sep 2021 10:31:06 -0400
X-MC-Unique: 33d4yFOfNJatK1i1jflv6w-1
Received: by mail-wr1-f69.google.com with SMTP id v1-20020adfc401000000b0015e11f71e65so8999978wrf.2
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOX0Dc/uscmy0FcdNSM5vS8dhWPJhduTSx1fXAnSXC8=;
        b=pnUfESleyhwnCVImoss7GkYCjAZe3Wkx+V5uNuZCxdZtk/b/CU822G4PaSBt7NpmPU
         cxcB9/F0alqIvxycpN0pdeyOm8Zlbom1+Hd1EhzcX8YaM4J+HiBDIOoOq5zp0Iys2QZ9
         xNg7R6yvRodd8x5g2zFOq/7/0qqHLL6Yvkz7VOMI7cys0AhWSCzfk8X68jHWS/PDmSvH
         6QojgUua9oOc5IwiQ9gWbQGS8HtxyyBsmueRlvNrUFv0osB7veWWkknZmamRyh4lzUOg
         bVKnBmw/yOeI0jobA62zFIOn7Kkf3MOD2onCqXviBaen60fBGFtTJZ6EGtqeUv4Rcb7w
         gMFg==
X-Gm-Message-State: AOAM531TC024Z2oUhDdaX0oTpXiPqSw9OUHERElb1YCZLT77VtZD1pMr
        T/IKNe8DPwu50yWywwAMKuOiLV/4fl02/aBEJ0Ocq1r+Me3Cx7qAo+i4LgmcLL3vKRBcNcRNyIW
        JM7mnFu2A4apxpANK
X-Received: by 2002:a5d:618c:: with SMTP id j12mr5290849wru.189.1632234664880;
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEM4NkwElgrp8f4cKqvFX/IpJVIPqq7dPySdWEovhmE4HewFeU/2oUKAxYrjP8y0ckUQpo6w==
X-Received: by 2002:a5d:618c:: with SMTP id j12mr5290820wru.189.1632234664676;
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r27sm19634987wrr.70.2021.09.21.07.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
Subject: Re: [PATCH] [backport for 4.19/5.4 stable] KVM: remember position in
 kvm->vcpus array
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210921134815.17615-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <280d7fb4-a02a-f8db-8af0-b567699cea80@redhat.com>
Date:   Tue, 21 Sep 2021 16:31:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921134815.17615-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/09/21 15:48, Christian Borntraeger wrote:
> From: Radim Krčmář <rkrcmar@redhat.com>
> 
> Fetching an index for any vcpu in kvm->vcpus array by traversing
> the entire array everytime is costly.
> This patch remembers the position of each vcpu in kvm->vcpus array
> by storing it in vcpus_idx under kvm_vcpu structure.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [borntraeger@de.ibm.com]: backport to 4.19 (also fits for 5.4)
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   include/linux/kvm_host.h | 11 +++--------
>   virt/kvm/kvm_main.c      |  5 +++--
>   2 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8dd4ebb58e97..827f70ce0b49 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -248,7 +248,8 @@ struct kvm_vcpu {
>   	struct preempt_notifier preempt_notifier;
>   #endif
>   	int cpu;
> -	int vcpu_id;
> +	int vcpu_id; /* id given by userspace at creation */
> +	int vcpu_idx; /* index in kvm->vcpus array */
>   	int srcu_idx;
>   	int mode;
>   	u64 requests;
> @@ -551,13 +552,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>   
>   static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_vcpu *tmp;
> -	int idx;
> -
> -	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
> -		if (tmp == vcpu)
> -			return idx;
> -	BUG();
> +	return vcpu->vcpu_idx;
>   }
>   
>   #define kvm_for_each_memslot(memslot, slots)	\
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a3d82113ae1c..86ef740763b5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2751,7 +2751,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		goto unlock_vcpu_destroy;
>   	}
>   
> -	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
> +	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> +	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
>   
>   	/* Now it's all set up, let userspace reach it */
>   	kvm_get_kvm(kvm);
> @@ -2761,7 +2762,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		goto unlock_vcpu_destroy;
>   	}
>   
> -	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
> +	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
>   
>   	/*
>   	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

The backport makes sense given the code in the stable branch now calls 
kvm_vcpu_get_idx more than it used to.

Paolo

