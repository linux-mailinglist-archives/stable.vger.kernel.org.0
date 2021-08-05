Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F326A3E0DDE
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 07:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhHEFt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 01:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhHEFt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 01:49:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09518C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 22:49:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so7032852pjb.2
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 22:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dNsQY+F/nTZDlRa7s8E02CpCEHGRnjF0leqZ8/MnW8A=;
        b=XlRrQdL9k7bXH9baTOiW0UScO0BXEPiwuTl8Ed5xr1VY4LwTSCHjHNHUdxdHo1xgun
         HOyIPLyZ0sXVDlyztY+TJGlCWpHwQX+cEMOj1Ezq1Act+q9Lq1CjbUzbPm/a+tTkHkkT
         1QAKMZlgAqTXh/ShUtsRC8Jot8Elr5U958dhkuqDFna618ZYUT6TearZNMmCwyvRtDzF
         gK6VnVJBUnlvi8mCCXeL/GYrcSCHGqZz5SiTWGh0cL56p8CdE4rztSX6IvO2Zxl/u7fk
         LWfTs+x8UBBqY3OnBJaMP7fSODsRhvCCWw57l/qhkoz0Mj6HpbVR5pPD08XRcC3maJgc
         AdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dNsQY+F/nTZDlRa7s8E02CpCEHGRnjF0leqZ8/MnW8A=;
        b=oi+LwofgV9hwkmqltNgtrOFM69MQJ58f0hhdVA1MRdOHueeK7syn0v5JTnWg5Hbe6a
         yxpyAjNJ/iiZd3o+hiuJaPO7MdZkBq/k0rEGJXCh2PajDM902O+QrQ8RTJtDx2aoqvVu
         zahU85va4UZwV8OojaRPV8giPV9480FAc5KyH4n7pW10XgBGNUUOW/GgnTRBuWoE47UH
         AHJ0dyydewSQIWUrgPXp0v+mQwE4GoxBgRVbY6CPa+QUM/HWHM6iss/g1z69RUflU19C
         uGqkBkQOkAG3I/B2/uhzAthwkQjh5WNJus8YdgEcAL2zV6k4Pvh1ZckCvr9R0ogcjLD7
         LyVg==
X-Gm-Message-State: AOAM533Q6Ch049f/7GRe7QX2cVXcdWsMUH9pQPGT6MiEVYvK2eRDF7jB
        V++2CY4LK22aqgFYzqmIMA/8kA==
X-Google-Smtp-Source: ABdhPJyq36kr7e5TFNOzJSVQEXm6NeJWJM6IIWNfcQVUeMByEtQjPVrmwruLaFRK0kiCDYVpeqsClQ==
X-Received: by 2002:a17:902:6bc8:b029:117:6a8a:f7af with SMTP id m8-20020a1709026bc8b02901176a8af7afmr2530078plt.51.1628142551592;
        Wed, 04 Aug 2021 22:49:11 -0700 (PDT)
Received: from localhost (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with UTF8SMTPSA id g19sm8114748pjl.25.2021.08.04.22.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 22:49:11 -0700 (PDT)
Message-ID: <b2d4af96-ea66-982f-54c0-919546d39aa3@ozlabs.ru>
Date:   Thu, 5 Aug 2021 15:49:05 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:88.0) Gecko/20100101
 Thunderbird/88.0
Subject: Re: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210804093737.2536206-1-pbonzini@redhat.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210804093737.2536206-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/4/21 19:37, Paolo Bonzini wrote:
> KVM creates a debugfs directory for each VM in order to store statistics
> about the virtual machine.  The directory name is built from the process
> pid and a VM fd.  While generally unique, it is possible to keep a
> file descriptor alive in a way that causes duplicate directories, which
> manifests as these messages:
> 
>    [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!
> 
> Even though this should not happen in practice, it is more or less
> expected in the case of KVM for testcases that call KVM_CREATE_VM and
> close the resulting file descriptor repeatedly and in parallel.
> 
> When this happens, debugfs_create_dir() returns an error but
> kvm_create_vm_debugfs() goes on to allocate stat data structs which are
> later leaked.  The slow memory leak was spotted by syzkaller, where it
> caused OOM reports.
> 
> Since the issue only affects debugfs, do a lookup before calling
> debugfs_create_dir, so that the message is downgraded and rate-limited.
> While at it, ensure kvm->debugfs_dentry is NULL rather than an error
> if it is not created.  This fixes kvm_destroy_vm_debugfs, which was not
> checking IS_ERR_OR_NULL correctly.
> 
> Cc: stable@vger.kernel.org
> Fixes: 536a6f88c49d ("KVM: Create debugfs dir and stat files for each VM")
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>


after another try, works brilliant.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks,


> ---
>   virt/kvm/kvm_main.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d20fba0fc290..b50dbe269f4b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -892,6 +892,8 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
>   
>   static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>   {
> +	static DEFINE_MUTEX(kvm_debugfs_lock);
> +	struct dentry *dent;
>   	char dir_name[ITOA_MAX_LEN * 2];
>   	struct kvm_stat_data *stat_data;
>   	const struct _kvm_stats_desc *pdesc;
> @@ -903,8 +905,20 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>   		return 0;
>   
>   	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
> -	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> +	mutex_lock(&kvm_debugfs_lock);
> +	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
> +	if (dent) {
> +		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> +		dput(dent);
> +		mutex_unlock(&kvm_debugfs_lock);
> +		return 0;
> +	}
> +	dent = debugfs_create_dir(dir_name, kvm_debugfs_dir);
> +	mutex_unlock(&kvm_debugfs_lock);
> +	if (IS_ERR(dent))
> +		return 0;
>   
> +	kvm->debugfs_dentry = dent;
>   	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
>   					 sizeof(*kvm->debugfs_stat_data),
>   					 GFP_KERNEL_ACCOUNT);
> @@ -5201,7 +5215,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>   	}
>   	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
>   
> -	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
> +	if (kvm->debugfs_dentry) {
>   		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
>   
>   		if (p) {
> 

-- 
Alexey
