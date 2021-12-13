Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4A472EF7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhLMOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbhLMOWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:22:21 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93295C061756;
        Mon, 13 Dec 2021 06:22:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id t5so52347091edd.0;
        Mon, 13 Dec 2021 06:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2LITpO1CYGTluV5sVoz+T9RYcObziHlm+lKM2Eu5E+c=;
        b=Eq3H1cEm/k+bfdM9rk2YyzTzEGwPKBbj0dUcfS5mMe3hoBmyzvFLKH2b2cmUlNMTiI
         y6ZbWPrGfBbCeuHMlZWrxqgMuPVUGyOTQu52qnjH3dMiE/DEZo9xDGd859a6QbR2SyPT
         eJ6jm/UU4fSi+HSPhrNyvPvKkGhc729C4StcL9I9Kau6Uo++Ge4isc0m2JrzI7KzApPl
         HJtcgWGDAmiOu/Um0yJsU3MIIHj7Tu20nNWVgJrs2hJw8CdOgs9du3zxIRhC0Dq3QFlf
         QmtrTogKloaz8ctntvHcwLjVnLGB16UTsTqI6nECsXym94pbksd2JfGqYBO6XoR4z5KQ
         8vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2LITpO1CYGTluV5sVoz+T9RYcObziHlm+lKM2Eu5E+c=;
        b=UZB6YGCP24SU28bOUM1WMR9T/frEL/PATUf4iFtjwcVJY1Y37Evt2WSB4Zsd+zF85n
         YhPPJlf7Mnr1mu/pcCTcsX0oNxLUokionDgaDlr80YnFpojI5Wn+MRHb4+sH/qDHR8l3
         e3iXYGKf4QZWXSZlf1as2ehsKbCZG92u2SGvJNFxhWdgCXwzGirj6IvJCQAMhMzAZUip
         brorZaWyGMjJSmMfBb28Lr5r/aZ9j2OkGdTIb6TBKUh1N5chzAig0nyS+RGp8v30PDHZ
         K9dUX69NpZsmz+subfjLGwyB9lkPoDbuRUkN1tNDAAqUqsdoYgRhqpjV52LkEcYj6JeV
         Tlrg==
X-Gm-Message-State: AOAM531a2XnbXW5aPfoWMVixRkStcWwFgvjm/e1L8ns1VzjlNR4S6+jL
        n85rayPDoDQnkhGFK7dQnsjS9ALhA7s=
X-Google-Smtp-Source: ABdhPJxTuP3Dx15KI5NRtZQaCeAHAW3heXsW4nEwMxbLEhnuhRzr59vvT7O8wepJff+3yTRhUvhx4g==
X-Received: by 2002:a05:6402:26d4:: with SMTP id x20mr65921399edd.119.1639405338958;
        Mon, 13 Dec 2021 06:22:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g15sm6009639ejt.10.2021.12.13.06.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:22:18 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <12be6cce-8e56-d69d-3338-3662b1fee12d@redhat.com>
Date:   Mon, 13 Dec 2021 15:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.4 2/2] KVM: selftests: Make sure
 kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20211213142028.352438-1-sashal@kernel.org>
 <20211213142028.352438-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213142028.352438-2-sashal@kernel.org>
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
> index 231d79e57774e..cfe75536d8a55 100644
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
> @@ -43,10 +44,39 @@ int main(int argc, char *argv[])
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
>   	printf("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
>   	printf("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
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
