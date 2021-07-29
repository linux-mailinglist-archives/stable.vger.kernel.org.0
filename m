Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB7C3D9FA8
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhG2Ihc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 04:37:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235105AbhG2Ihc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 04:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627547848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQ8gV+YIADo6zDvC7mR81jZfTRNtnMPFCYoiUg9hymQ=;
        b=dQImuKuBcft1snq5RqEHXli9yT63IgC0f98zILgtb5uMdvNou/9cBYpuQ8a/ksXp8PvhOs
        YoAH6OOhoea6wmxmeiGH+wnkcdBtbHxhySncE0aIQ72wPJc8Zy/7W6LD0/2nIyl9onEU9V
        I0acc2r55ns8ddRz4a/hYM3ka0IXu1c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-xajCKRPENfWVo852O1OdkA-1; Thu, 29 Jul 2021 04:37:26 -0400
X-MC-Unique: xajCKRPENfWVo852O1OdkA-1
Received: by mail-ej1-f70.google.com with SMTP id pv7-20020a1709072087b02905119310d7b9so1721517ejb.23
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 01:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQ8gV+YIADo6zDvC7mR81jZfTRNtnMPFCYoiUg9hymQ=;
        b=IunEzgieXxst2YumqQpEzY4sL/B1jHubxHQ4Xb45uP2Bc3OESqgVx0inPv+qGf2/tB
         JtHa0X1CFLUEaYxb01TjECCtm0I6vq5b8/h6tou9hUscNkpchR6HetyWzAgBhwXPdIba
         dUjP6ejpJeVgCOttCBi286XrmeFF84SFJXknJpEUVv1PffoDQIL0erc+Gw9hN3PbtxOW
         M+jovDc18ryNZ8NW8fEwElPnxLqjFL0OXn1Tl0PmEmevjgAnFtGGb6c9chiRwEpg6/m4
         nLKkfs3bxq6QPKK+8HtBWFOMTBuer7migEqQU3zL2t0NRnhTmNUrVXHRrfrZo8ZsvL1a
         yT2Q==
X-Gm-Message-State: AOAM532zg7KAGRb7e4viKX+ByPvKV156+QXNepAYGsuoEzaJVShPFkno
        t2+asfvL+Jq9z+agfQz0JW9IC95R20TvdewihqpF8EhOdhnWZncAOr80SLTJi4+Mn8bo5iDu3jV
        inWu/l4HoGAetAFBG
X-Received: by 2002:a17:906:844b:: with SMTP id e11mr3625222ejy.446.1627547845669;
        Thu, 29 Jul 2021 01:37:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBcAAflmQxJFojE0/zEzTFNhzWxkhwNJVZ/qZ9Q5I9O6bzqTyNFzHcyNl60k6LS9j3QKgLFA==
X-Received: by 2002:a17:906:844b:: with SMTP id e11mr3625207ejy.446.1627547845452;
        Thu, 29 Jul 2021 01:37:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d2sm722458ejo.13.2021.07.29.01.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 01:37:24 -0700 (PDT)
Subject: Re: [linux-5.10.y] KVM: x86: determine if an exception has an error
 code only when injecting it.
To:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com
References: <20210728230700.1762131-1-zsm@chromium.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57cbbeb9-9706-f6a5-11c1-82062aa1f14c@redhat.com>
Date:   Thu, 29 Jul 2021 10:37:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728230700.1762131-1-zsm@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/07/21 01:07, Zubin Mithra wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> commit b97f074583736c42fb36f2da1164e28c73758912 upstream.
> 
> A page fault can be queued while vCPU is in real paged mode on AMD, and
> AMD manual asks the user to always intercept it
> (otherwise result is undefined).
> The resulting VM exit, does have an error code.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Backport Note:
> * Syzkaller triggered a WARNING with the following stacktrace:
>   WARNING: CPU: 3 PID: 3402 at arch/x86/kvm/x86.c:9387 kvm_arch_vcpu_ioctl_run+0x35b/0x21b0
>   Modules linked in:
>   CPU: 3 PID: 3402 Comm: poc Not tainted 5.10.54-00289-g08277b9dde63 #1
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   RIP: 0010:kvm_arch_vcpu_ioctl_run+0x35b/0x21b0
>   Code: 8d bd 50 0e 00 00 e8 1f 22 38 00 48 83 bd 50 0e 00 00 00 75 15 48 8d bd 00 02 00 00 e8 1c 21 38 00 83 bd 00 02 00 00 00 74 02 <0f> 0b 48 8b 04 24 48 8d 78 01 e8 98 1f 38 00 48 8b 04 24 80 78 01
>   RSP: 0018:ffff888009bcfc10 EFLAGS: 00010202
>   RAX: 1ffff110010e9000 RBX: ffff888007cd7400 RCX: ffffffff8105f65a
>   RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffff888008748200
>   RBP: ffff888008748000 R08: 0000000000000004 R09: ffffffff84ac9963
>   R10: 0000000000000000 R11: ffffffff81040a0b R12: ffff888008748000
>   R13: ffff888008748100 R14: 1ffff11001379fae R15: ffff8880075c8000
>   FS:  00007d6063ce7700(0000) GS:ffff88806d380000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 000059fbd456d2c8 CR3: 000000000c6ed002 CR4: 0000000000372ee0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    ? put_pid+0x60/0x72
>    ? kvm_arch_vcpu_runnable+0x1ca/0x1ca
>    ? rcu_read_lock_held_common+0x3c/0x3c
>    ? slab_free_freelist_hook+0xcf/0x123
>    ? kmem_cache_free+0x17d/0x1f9
>    kvm_vcpu_ioctl+0x256/0x6e1
>    ? kvm_free_memslots+0xa8/0xa8
>    ? rcu_read_lock_held_common+0x3c/0x3c
>    ? do_vfs_ioctl+0x6b0/0x8a6
>    ? ioctl_file_clone+0xb4/0xb4
>    ? selinux_file_ioctl+0x1f9/0x2da
>    ? selinux_file_mprotect+0x1d9/0x1d9
>    ? rcu_read_lock_held+0x73/0x9f
>    vfs_ioctl+0x46/0x5a
>    __do_sys_ioctl+0x63/0x86
>    ? __x64_sys_ioctl+0x2a/0x3c
>    do_syscall_64+0x2d/0x3a
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   RIP: 0033:0x44dd39
> 
> * This commit is present in linux-5.13.y.
> 
> * Conflict arises as the following commit is is not present in
> linux-5.10.y and older.
> - b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")
> 
> * Tests run: syzkaller reproducer
> 
>   arch/x86/kvm/x86.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 800914e9e12b..3ad6f77ea1c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -541,8 +541,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   
>   	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>   	queue:
> -		if (has_error && !is_protmode(vcpu))
> -			has_error = false;
>   		if (reinject) {
>   			/*
>   			 * On vmentry, vcpu->arch.exception.pending is only
> @@ -8265,6 +8263,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
>   	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
>   }
>   
> +static void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
> +		vcpu->arch.exception.error_code = false;
> +	kvm_x86_ops.queue_exception(vcpu);
> +}
> +
>   static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>   {
>   	int r;
> @@ -8273,7 +8278,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>   	/* try to reinject previous events if any */
>   
>   	if (vcpu->arch.exception.injected) {
> -		kvm_x86_ops.queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   		can_inject = false;
>   	}
>   	/*
> @@ -8336,7 +8341,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>   			}
>   		}
>   
> -		kvm_x86_ops.queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   		can_inject = false;
>   	}
>   
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

