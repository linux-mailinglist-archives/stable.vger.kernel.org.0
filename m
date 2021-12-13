Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D24472EEE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhLMOWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbhLMOWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:22:10 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9FEC061A32;
        Mon, 13 Dec 2021 06:22:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so51857915eda.12;
        Mon, 13 Dec 2021 06:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=laxE5jN2bHJG4Yo8WVS4mx5VPDFX4vkop6go8zl/3cQ=;
        b=lzIwCzNJvV86Boup6xgN3osyOJCZ5s9f7wssi8eyqby4QFK6mgh5w3tsozKTsJ3T59
         HVIqizJ9ZFY64dJp6KfX+cGRLOQJEUW1bzqXZGPlZkMjcWmDT+x4qJOaaQciaOAaqqaj
         HJrg2wpVesDIDnNnXE47hF9u2zKK0yR9ZEIGagxI6LOf8wbifVoIpR3Fzosc7syqYuLg
         JXWkIw+L3dFwO2b6bI896aMnKTfjnchtLGFfA5Q2ryaFoOBCw6IZ3EdA9NVzgftFprLF
         ozWGX0Iit8K1FK6gIfGRc+GIN4B5+EySkEsCFz5L1EEVwZq4JtYAomtfuyIuiB/U9+tJ
         P/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=laxE5jN2bHJG4Yo8WVS4mx5VPDFX4vkop6go8zl/3cQ=;
        b=7IiiVqeBS/ZVreZhSNvqqYo6G0cqrAe7nz07I4adOtYzRN69/VtWG71RqUPEJoyr35
         4ZF6GSjXE5G5OU1LcyDtFvvBaKdjCfYnuXmXPzxD+6eD2KvLA2iNIeJ47THX/hWmq4nX
         rf5vT+YFT/BmCStmoFCjyu8r3CO21hTN3V8iPKUXLg0i2YTKG0pIWJVEnHObywAql1ch
         FsIcE6eNIhRkuNxyYnR3Jo6z2cBGM1UTjFEGNKV+v+SieS9d6jk/e4qIqRUcPZ3mxmLG
         JmAyqG2JBR+4Can3Whz4iINBf9Z3ETPrLQAtSBdTERm7ZcFgxZRGIWECpYplDPon8KJa
         1row==
X-Gm-Message-State: AOAM530BJIZzKjfZmytkfgLLi1eJp0qb4gHXEn3+pPcwTc57teXSbHoc
        pQirwkOVmJJt9x71x0bkNZo=
X-Google-Smtp-Source: ABdhPJxNFRV6Oi2yANoqjyUMFO8hhvfktf+ywIKoyHutx2WmfJhwBnQg2syM5e7/uYTFHwNnzVsp7g==
X-Received: by 2002:a50:d543:: with SMTP id f3mr62764539edj.56.1639405324197;
        Mon, 13 Dec 2021 06:22:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 12sm147884eja.187.2021.12.13.06.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:22:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <72a3fabf-bb1d-002f-caaf-2656559aa2a8@redhat.com>
Date:   Mon, 13 Dec 2021 15:22:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.10 3/4] KVM: selftests: Make sure
 kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20211213142020.352376-1-sashal@kernel.org>
 <20211213142020.352376-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213142020.352376-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:20, Sasha Levin wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit 908fa88e420f30dde6d80f092795a18ec72ca6d3 ]
> 
> With the elevated 'KVM_CAP_MAX_VCPUS' value kvm_create_max_vcpus test
> may hit RLIMIT_NOFILE limits:
> 
>   # ./kvm_create_max_vcpus
>   KVM_CAP_MAX_VCPU_ID: 4096
>   KVM_CAP_MAX_VCPUS: 1024
>   Testing creating 1024 vCPUs, with IDs 0...1023.
>   /dev/kvm not available (errno: 24), skipping test
> 
> Adjust RLIMIT_NOFILE limits to make sure KVM_CAP_MAX_VCPUS fds can be
> opened. Note, raising hard limit ('rlim_max') requires CAP_SYS_RESOURCE
> capability which is generally not needed to run kvm selftests (but without
> raising the limit the test is doomed to fail anyway).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20211123135953.667434-1-vkuznets@redhat.com>
> [Skip the test if the hard limit can be raised. - Paolo]
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   .../selftests/kvm/kvm_create_max_vcpus.c      | 30 +++++++++++++++++++
>   1 file changed, 30 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> index 0299cd81b8ba2..aa3795cd7bd3d 100644
> --- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> +++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> @@ -12,6 +12,7 @@
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
> +#include <sys/resource.h>
>   
>   #include "test_util.h"
>   
> @@ -40,10 +41,39 @@ int main(int argc, char *argv[])
>   {
>   	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
>   	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> +	/*
> +	 * Number of file descriptors reqired, KVM_CAP_MAX_VCPUS for vCPU fds +
> +	 * an arbitrary number for everything else.
> +	 */
> +	int nr_fds_wanted = kvm_max_vcpus + 100;
> +	struct rlimit rl;
>   
>   	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
>   	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
>   
> +	/*
> +	 * Check that we're allowed to open nr_fds_wanted file descriptors and
> +	 * try raising the limits if needed.
> +	 */
> +	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl), "getrlimit() failed!");
> +
> +	if (rl.rlim_cur < nr_fds_wanted) {
> +		rl.rlim_cur = nr_fds_wanted;
> +		if (rl.rlim_max < nr_fds_wanted) {
> +			int old_rlim_max = rl.rlim_max;
> +			rl.rlim_max = nr_fds_wanted;
> +
> +			int r = setrlimit(RLIMIT_NOFILE, &rl);
> +			if (r < 0) {
> +				printf("RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
> +				       old_rlim_max, nr_fds_wanted);
> +				exit(KSFT_SKIP);
> +			}
> +		} else {
> +			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
> +		}
> +	}
> +
>   	/*
>   	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
>   	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
