Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3504C96AC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiCAUZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238610AbiCAUXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:23:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2084A2F03
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1x6QUK4FLEy8ROUzJyVZ/cWy4d8A2hzSu/J8ehfsP+g=;
        b=Xuzs1Tok81E2oNm2MdB1zv2pbp0rlGDwOrzGMvRkPIW1O02TeeSSDWXEW4SkgWpg5Zf4yT
        FTzsnpi/LeEmcvJQjDUOZbTtiOk7Z6DGafqVIUflaFofVHeqiuiIMfd3T+7tYlTpzZXiUm
        Kqyu4V8rca4qMKMv9RuwMjqMJz0ueys=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-qF1N7NFrNLm3HJW7Pvh5Ag-1; Tue, 01 Mar 2022 15:19:29 -0500
X-MC-Unique: qF1N7NFrNLm3HJW7Pvh5Ag-1
Received: by mail-wr1-f70.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so3743174wrp.10
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1x6QUK4FLEy8ROUzJyVZ/cWy4d8A2hzSu/J8ehfsP+g=;
        b=BSa+/ySHuzwy+gdqVZ8Kd/vmv6sJ7YU0JUJ+xwaSdRzQB+R6XsdAU6ho8eHObtwO1I
         zPdH6BsDX1tOrti3JuSYGsSdVMb+Q1z9YlksDlGevnfXMGr2f2XI4ZKi0BFNGiecWLJx
         /3lGeu6CKNzlLUO1nfC5rdAwqNzbGCF1CJ8THKPkXa/RDXuu6n6Acs2+Rn3lj2dww0Ik
         EadYvT2iP+g9k7xzAu9L79sVm8ew06Iqc8y7/KfyPObGNArkauqcSghUUVCNGxHW9N87
         +E9/h11vbi7QDsmwzfKQGixzgahzmy383otuvwJTZgPq3F09a64SIBRQqhw4C//Vpciz
         Cj6w==
X-Gm-Message-State: AOAM5339JSFciWb3jzRomdDu1dJvEsnGn4p/O0VHU3XaK2fvQLcL+r3j
        PHdqMiaCVPAkqDcYjhNJoEu2ZCbJX376G+P4l5JODgeAFF5CHyppAEdKcGGtRf6P1Q2U1ZOcLjW
        V22ZqOohN0Ig916uU
X-Received: by 2002:a05:600c:2f8f:b0:381:2009:f5bb with SMTP id t15-20020a05600c2f8f00b003812009f5bbmr18448302wmn.163.1646165967846;
        Tue, 01 Mar 2022 12:19:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+d4NI+GBVH5ewxls8mvm7BLZHAMn8s6kj98Mu7E4d1X/x3eFx3aILtaWlsRQEjJTRxazgDg==
X-Received: by 2002:a05:600c:2f8f:b0:381:2009:f5bb with SMTP id t15-20020a05600c2f8f00b003812009f5bbmr18448286wmn.163.1646165967602;
        Tue, 01 Mar 2022 12:19:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id v20-20020a7bcb54000000b0037fa63db8aasm3539049wmj.5.2022.03.01.12.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:19:27 -0800 (PST)
Message-ID: <38116323-b990-9bf6-18a4-71f6ff66f32f@redhat.com>
Date:   Tue, 1 Mar 2022 21:19:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 05/28] KVM: Fix lockdep false negative during
 host resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201344.18191-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:13, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 4cb9a998b1ce25fad74a82f5a5c45a4ef40de337 ]
> 
> I saw the below splatting after the host suspended and resumed.
> 
>     WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
>     CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
>     RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
>     Call Trace:
>      <TASK>
>      syscore_resume+0x90/0x340
>      suspend_devices_and_enter+0xaee/0xe90
>      pm_suspend.cold+0x36b/0x3c2
>      state_store+0x82/0xf0
>      kernfs_fop_write_iter+0x1b6/0x260
>      new_sync_write+0x258/0x370
>      vfs_write+0x33f/0x510
>      ksys_write+0xc9/0x160
>      do_syscall_64+0x3b/0xc0
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> lockdep_is_held() can return -1 when lockdep is disabled which triggers
> this warning. Let's use lockdep_assert_not_held() which can detect
> incorrect calls while holding a lock and it also avoids false negatives
> when lockdep is disabled.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 71ddc7a8bc302..6ae9e04d0585e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5347,9 +5347,7 @@ static int kvm_suspend(void)
>   static void kvm_resume(void)
>   {
>   	if (kvm_usage_count) {
> -#ifdef CONFIG_LOCKDEP
> -		WARN_ON(lockdep_is_held(&kvm_count_lock));
> -#endif
> +		lockdep_assert_not_held(&kvm_count_lock);
>   		hardware_enable_nolock(NULL);
>   	}
>   }

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

