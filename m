Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF348C9AA9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfJCJTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 05:19:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfJCJTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 05:19:49 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30938369CA
        for <stable@vger.kernel.org>; Thu,  3 Oct 2019 09:19:48 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k67so446402wmf.3
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 02:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QwueJsBCANb/M3j55enpak6fl60pCfDYzF0vjsWIrUk=;
        b=MPwhmlHLgrPKIYNLKNv1e/xLPjM8us3flbAJkHdjnfez1BUt/erpNPm7n+9I8gbUFF
         siV3+YgEoDArSDOqv4p1w/3GEfPuBqBYmZ2YI9ZCI4J1FJKywzDQLMnryaSSv60DEVyS
         SyRkd8YijpJNXYTAbf7ECXBVo3unRWFZC4ZmXEzJL64ouCDmpVdjDAckvHXm1a/57DKh
         Ss0KbpcQ6kRl+tcG+kGgdLDpgulZwzKGPJXcWC4TTO+iq546KkA8dIJOnUa8FnXY3VSW
         opI0KhDW3qIZq5SP5vgqY2AeVuCgL3QvzmJXwRx/fzWxCrtgNRY6oFhcdQF4E8w/Zxpb
         qhEQ==
X-Gm-Message-State: APjAAAUF3IywcrIYp/TJ0zHDEEPjkijNfadHVUJ+HzFuk8GrW/ZeAcDA
        onOi0ZQNpc5y8nna20RhL7atjcLHX1fjkcFM9VrZosnTPqn+gT5ais0SVH7qrWIc1umTF8W5Cs4
        RFNbgwGuIpSFUiKoZ
X-Received: by 2002:a1c:2144:: with SMTP id h65mr6525095wmh.114.1570094386884;
        Thu, 03 Oct 2019 02:19:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzZyTcBIE4N0PZRq79Lh2cQ9GHYPRmyRCyPfjM4wb6NhZ/lG+nX7vjJFBLvM3qBEtWkmus7fQ==
X-Received: by 2002:a1c:2144:: with SMTP id h65mr6525080wmh.114.1570094386667;
        Thu, 03 Oct 2019 02:19:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id m16sm1648677wml.11.2019.10.03.02.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:19:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Subject: Re: FAILED: patch "[PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()" failed to apply to 5.3-stable tree
In-Reply-To: <1570089676108127@kroah.com>
References: <1570089676108127@kroah.com>
Date:   Thu, 03 Oct 2019 11:19:45 +0200
Message-ID: <87pnje18zy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 5.3-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From a061985b81a20248da60589d01375ebe9bec4dfc Mon Sep 17 00:00:00 2001
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Tue, 27 Aug 2019 12:38:52 +0300
> Subject: [PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()
>
> We refactored this code a bit and accidentally deleted the "-" character
> from "-EINVAL".  The kvm_vcpu_map() function never returns positive
> EINVAL.
>
> Fixes: c8e16b78c614 ("x86: KVM: svm: eliminate hardcoded RIP
> advancement from vmrun_interception()")

Hm, this commit wasn't backported to 5.3-stable so no fix is needed
(scripts don't check pre-requisites like commits mentioned in Fixes:?)

Also, c8e16b78c614 is not a stable@ candidate IMO.

> Cc: stable@vger.kernel.org

This wasn't needed as it's only 5.4 which will have the offending commit
and the fix.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index fdeaf8f44949..2854aafc489e 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3598,7 +3598,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
>  	vmcb_gpa = svm->vmcb->save.rax;
>  
>  	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
> -	if (ret == EINVAL) {
> +	if (ret == -EINVAL) {
>  		kvm_inject_gp(&svm->vcpu, 0);
>  		return 1;
>  	} else if (ret) {
>

-- 
Vitaly
