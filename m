Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC6DD08C2
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 09:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfJIHrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 03:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfJIHrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 03:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BDD020B7C;
        Wed,  9 Oct 2019 07:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570607266;
        bh=NGL/1f7ZuWs2O39sGH/f7QSgqDVNJKllc9lHdfzwi0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfBODdTXL/UbL+UClqwWaqBNqXWe2OZf/o39uKIjW3EsWnnkBgqN8DSl8fmblQQuy
         kSc7gUKqhgWX8EJbc0o8vNeYtM5BWyPsBKFVvh6V23dftquCmx9IrsSQ/1QzBVhgTd
         lbPSbEyP8KZGwHKWzzmRipCmJMjhAXzcSryce6vc=
Date:   Wed, 9 Oct 2019 09:47:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        namit@vmware.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: nVMX: Fix consistency check on
 injected exception error" failed to apply to 5.3-stable tree
Message-ID: <20191009074744.GA3843287@kroah.com>
References: <1570519311128161@kroah.com>
 <20191008221527.GF1396@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008221527.GF1396@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 06:15:27PM -0400, Sasha Levin wrote:
> On Tue, Oct 08, 2019 at 09:21:51AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.3-stable tree.
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
> > > From 567926cca99ba1750be8aae9c4178796bf9bb90b Mon Sep 17 00:00:00 2001
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > Date: Tue, 1 Oct 2019 09:21:23 -0700
> > Subject: [PATCH] KVM: nVMX: Fix consistency check on injected exception error
> > code
> > 
> > Current versions of Intel's SDM incorrectly state that "bits 31:15 of
> > the VM-Entry exception error-code field" must be zero.  In reality, bits
> > 31:16 must be zero, i.e. error codes are 16-bit values.
> > 
> > The bogus error code check manifests as an unexpected VM-Entry failure
> > due to an invalid code field (error number 7) in L1, e.g. when injecting
> > a #GP with error_code=0x9f00.
> > 
> > Nadav previously reported the bug[*], both to KVM and Intel, and fixed
> > the associated kvm-unit-test.
> > 
> > [*] https://patchwork.kernel.org/patch/11124749/
> > 
> > Reported-by: Nadav Amit <namit@vmware.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> There were minor conflicts due to missing tracepoint in 5.3 and code
> movement in 4.19. I've fixed it up.

Thanks for fixing these, and all of the other FAILED: issues.

thanks,

greg k-h
