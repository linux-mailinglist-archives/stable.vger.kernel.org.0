Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D41B171129
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 07:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgB0G4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 01:56:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgB0G4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 01:56:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D52824683;
        Thu, 27 Feb 2020 06:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582786582;
        bh=aaqmDj9o2XQg5x73d97UAF71hgYfNIYC+SJPY61O5Ro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGHoMnqdiL4VIW5+copJzELdJgsUzCeLdIREw8f6/UNaBbtFmkfb84aP4BDa7lsRR
         r20/Qo95euo2NjKv3GkmKc//r6WXN8bNxTHfBolyjTHEaoeufUo1fsVjwxtnFkZfXA
         PzIiDwmTQEs4Hu+r48aC3jrqCdejfYqNpj9QXGgU=
Date:   Thu, 27 Feb 2020 07:56:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     pbonzini@redhat.com, oupton@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: nVMX: Don't emulate instructions in
 guest mode" failed to apply to 4.14-stable tree
Message-ID: <20200227065619.GA287375@kroah.com>
References: <158274106920052@kroah.com>
 <20200227033546.GG22178@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227033546.GG22178@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 10:35:46PM -0500, Sasha Levin wrote:
> On Wed, Feb 26, 2020 at 07:17:49PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 07721feee46b4b248402133228235318199b05ec Mon Sep 17 00:00:00 2001
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > Date: Tue, 4 Feb 2020 15:26:29 -0800
> > Subject: [PATCH] KVM: nVMX: Don't emulate instructions in guest mode
> > 
> > vmx_check_intercept is not yet fully implemented. To avoid emulating
> > instructions disallowed by the L1 hypervisor, refuse to emulate
> > instructions by default.
> > 
> > Cc: stable@vger.kernel.org
> > [Made commit, added commit msg - Oliver]
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index dcca514ffd42..5801a86f9c24 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7164,7 +7164,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
> > 	}
> > 
> > 	/* TODO: check more intercepts... */
> > -	return X86EMUL_CONTINUE;
> > +	return X86EMUL_UNHANDLEABLE;
> > }
> 
> File was renamed, and we don't have fb6d4d340e05 ("KVM: x86: emulate
> RDPID") on 4.14 and prior. I've fixed it and queued this patch for
> 4.14-4.4.

Thanks for this, and all of the other fixups.

greg k-h
