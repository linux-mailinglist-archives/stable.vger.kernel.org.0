Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA34472F31
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbhLMO1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239237AbhLMO1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:27:52 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAFDC061574;
        Mon, 13 Dec 2021 06:27:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o20so53109267eds.10;
        Mon, 13 Dec 2021 06:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OGf8TrNujot+Ve13va1rxUKEkc1B4LTb1fQHF2J07pg=;
        b=lRc3h2emtur4H0oIdG0WUpVAzhWC15xGOHb+vyyarEXOY6PdkrWCuD1IJ9ZuVcO8SM
         gMP+7npGhm53s/2tfeP3S2YpviDljw2NKZdu4hZDjglDS+rookMNwlNmBybFTS4TPGLs
         wBabvAHDxNRoG2Zl4Z8T0tXf6n27IYOUNT1LlXw03QYfM5YLBf8eTUrUtPbEzd845Ie3
         2NTwAfHO2OWDXKuTwL2Po1MxTcWVkUXJwC8L7Bhu+fPdtoUelrFSxc3AWyJNA4Mb6wJu
         VQyviekItU0NQmPnnn53+IEeMxYklasTFgmUElRMnJHHkTYJU0f3R9CK80dQIaOKL69v
         eDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OGf8TrNujot+Ve13va1rxUKEkc1B4LTb1fQHF2J07pg=;
        b=63PlvecvAtJjkODWB1GQkIG+6UMfgUX4e3qSyho07AvK82vJiBIsOJv0ShEYx28Fcg
         gV3I6YTzvQ3Ov5trZG65yTdRJaQZZUP0/QrWK4dE6+4lOcohKWkxOIB3Hfus/2R0YdET
         U15Joq8EMLT0lZgzOPGJkR9YV4zXvZd/vwWBag0s6jUpDObjmYQN9z73+mPN2FPzqbP2
         jUlYfzhUyqMX6KZENP+7pRfxdBKUsl9Is+NyC8LQ4AnLaxMc7WD7vBRLc/17ScolbB6z
         np78XCsAdI4vXHaTF/m22q0t4A5vt7nUsShOzdN4zYJS8t35yGP+hEyzhMLJPsDGUlqL
         UQqw==
X-Gm-Message-State: AOAM531xDsy8c4RYBWBqh1QJjQlCtiF++9Yy1msRYlsTMs0pmb6bxtpq
        nL6pnDB9gctrCz6m6riHskU=
X-Google-Smtp-Source: ABdhPJyXlsHxNJSA31cvmJuqKiXqSa/QN0PlN0+gwoB4F8LolQsclZLkb2UJQqUy8DlMVovUmHO7ZQ==
X-Received: by 2002:a17:906:4703:: with SMTP id y3mr44472010ejq.346.1639405669639;
        Mon, 13 Dec 2021 06:27:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cs15sm5508284ejc.31.2021.12.13.06.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:27:49 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <eb83e84d-26b1-aae6-fd2b-9b2fe89d37f0@redhat.com>
Date:   Mon, 13 Dec 2021 15:27:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 5/9] KVM: selftests: Make sure
 kvm_create_max_vcpus test won't hit RLIMIT_NOFILE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
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
