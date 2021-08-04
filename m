Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D393E0B01
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 01:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhHDXxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 19:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbhHDXxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 19:53:54 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF00C061798
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 16:53:40 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k2so4854165plk.13
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 16:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=PjDXQCFJQ1b1/TW55vbzjX1inuaNudqEamanHyRcrzw=;
        b=Xz1MC0yU7hbxCLBST7ioS/2z+mGi4178sVS6bpxkdvUJTP3mJH9g6PXPTVvBHdURxR
         4hz1IdaVs6AJc7PcJatSlUta/Hhi72UosBuLnHpuWPC0qFlieKFDPCJ6aAFQe5F1xbzb
         j930NnfEnPU2pqRTfAXFgahDZ25YLMrvdzfQdiCVMTkHCSmtpIFM5Nm5zDrG5kiy9QNu
         Vp7pBMMu0VLuuCSDGyUW365GfDx8dEQ4nAziagcWdhi9BfLO+AAj0vKxAElK8ZguASA4
         Co/w8aObrDHiR42SS0n/k9fnvc7Gk5eBVCss3EEkHTXOdmPy2kH2R1786wXNSHqKdYBS
         xd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=PjDXQCFJQ1b1/TW55vbzjX1inuaNudqEamanHyRcrzw=;
        b=Mr5BACImPqRWO8oq3Q5t4GcJy03InW1cvFQNK2Ptx4nfPjrd1qip04MyaK4+koVeaz
         QB0UI4eEQN9APJ3MYQppWlqVTSxqEo7ryVxJT0GGA9KGfgZezZNpYifzUJZr3yFPd1dI
         pK40dqNqZVCUpZNK/b/2Jaj5pL2N2ZibZNpy5qcueeHgtK8G1YHXNM324T+5Hta5zdU5
         PnONxHlrGzhZAmsawtabHQ+oMds/ZBzYd6n9N0/pLDV/EKawqAjyCBK5G3IHujB5lKEC
         ttJq3AS426i/D8yio2E88wcL4pFv1Wbq4smOuMOPqQxpDWeZSvc6AJY7yFZCAnx3ospd
         oX4A==
X-Gm-Message-State: AOAM533+1PWYWsDLVM3DuQT+icGNGSmXHNHcgolkQDCOXLzJmYC+y5Cg
        2TdDKt2FJEF9TGMeHyGBIiIHtg==
X-Google-Smtp-Source: ABdhPJy2LyRCOkEuJQooU7DbiO5x4Of4EE/mTkmyt0xCmPseJYdFtOccV9FLaz6IH5ym3qewhBVzUA==
X-Received: by 2002:aa7:93c5:0:b029:3b6:cb47:30a4 with SMTP id y5-20020aa793c50000b02903b6cb4730a4mr1821702pff.53.1628121219843;
        Wed, 04 Aug 2021 16:53:39 -0700 (PDT)
Received: from [192.168.10.153] (219-90-184-65.ip.adam.com.au. [219.90.184.65])
        by smtp.gmail.com with UTF8SMTPSA id p20sm7107277pju.48.2021.08.04.16.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 16:53:39 -0700 (PDT)
Message-ID: <f360885d-1f4e-a6e8-5a0b-dec31fd0075f@ozlabs.ru>
Date:   Thu, 5 Aug 2021 09:53:35 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210804093737.2536206-1-pbonzini@redhat.com>
 <05ade6a2-2eb4-89c2-7c6e-651c8c53c6f6@ozlabs.ru>
In-Reply-To: <05ade6a2-2eb4-89c2-7c6e-651c8c53c6f6@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 05/08/2021 09:32, Alexey Kardashevskiy wrote:
> 
> 
> On 04/08/2021 19:37, Paolo Bonzini wrote:
>> KVM creates a debugfs directory for each VM in order to store statistics
>> about the virtual machine.  The directory name is built from the process
>> pid and a VM fd.  While generally unique, it is possible to keep a
>> file descriptor alive in a way that causes duplicate directories, which
>> manifests as these messages:
>>
>>    [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' 
>> already present!
>>
>> Even though this should not happen in practice, it is more or less
>> expected in the case of KVM for testcases that call KVM_CREATE_VM and
>> close the resulting file descriptor repeatedly and in parallel.
>>
>> When this happens, debugfs_create_dir() returns an error but
>> kvm_create_vm_debugfs() goes on to allocate stat data structs which are
>> later leaked. 
> 
> Rather the already allocated srructs leak, no?
> 
>> The slow memory leak was spotted by syzkaller, where it
>> caused OOM reports.
> 
> I gave it a try and almost replied with "tested-by" but after running it 
> over night I got 1 of these with followed OOM:
> 
> [ 1104.951394][  T544] debugfs: Directory '544-4' with parent 'kvm' 
> already present!
> [ 1104.951600][  T544] Failed to create 544-4
> 
> This is definitely an improvement as this used to happen a few times 
> every hour but still puzzling :-/


ah rats, I was running a wrong kernel, retrying now. sorry for the noise.


-- 
Alexey
