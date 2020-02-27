Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF8D170F06
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 04:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgB0Dft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 22:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgB0Dfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 22:35:48 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7CAE222C2;
        Thu, 27 Feb 2020 03:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582774548;
        bh=h4Lnac9LIpM/esPU58JdKRNIseClHQk6wv63724054A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XNAylt34d9vG/me0DMjCGUk4fRvVfBz+2pvYatkxuEPHkjN3bD+vRwDkvEi+gjmaw
         6oOZrBgtPXZapBdDnySawkE+4L90ks62svnXywCtoAROnfSROvSabni1nFb/HFI84h
         yi0cQgBY02tWHdAD5eHpsEGwqOO/oqQWjZuiN2NE=
Date:   Wed, 26 Feb 2020 22:35:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pbonzini@redhat.com, oupton@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: nVMX: Don't emulate instructions in
 guest mode" failed to apply to 4.14-stable tree
Message-ID: <20200227033546.GG22178@sasha-vm>
References: <158274106920052@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158274106920052@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 07:17:49PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 07721feee46b4b248402133228235318199b05ec Mon Sep 17 00:00:00 2001
>From: Paolo Bonzini <pbonzini@redhat.com>
>Date: Tue, 4 Feb 2020 15:26:29 -0800
>Subject: [PATCH] KVM: nVMX: Don't emulate instructions in guest mode
>
>vmx_check_intercept is not yet fully implemented. To avoid emulating
>instructions disallowed by the L1 hypervisor, refuse to emulate
>instructions by default.
>
>Cc: stable@vger.kernel.org
>[Made commit, added commit msg - Oliver]
>Signed-off-by: Oliver Upton <oupton@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index dcca514ffd42..5801a86f9c24 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -7164,7 +7164,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> 	}
>
> 	/* TODO: check more intercepts... */
>-	return X86EMUL_CONTINUE;
>+	return X86EMUL_UNHANDLEABLE;
> }

File was renamed, and we don't have fb6d4d340e05 ("KVM: x86: emulate
RDPID") on 4.14 and prior. I've fixed it and queued this patch for
4.14-4.4.

-- 
Thanks,
Sasha
