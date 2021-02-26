Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C3A326303
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 14:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBZNAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 08:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhBZNAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 08:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42EB64E4D;
        Fri, 26 Feb 2021 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614344391;
        bh=jROorbZuXee0443nkbVh1AgriDGvjjSbnVGbV2NXTR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1TIA6mp+T+bPraWU5z2dlFWxdQ3cLz1WnIxbWPN0DmPPXjgkMI2LUa53LP6L7ayi7
         qjDPX8w3GD9/gj3nzCMxC+hSnQJMTYSQdt3ojDkFZTw3fAbIOPbUjVklikvsKj+gDG
         0d/Qbz1oHdHdcGwACBB9qWF6Sd1morArLgWgOkfc=
Date:   Fri, 26 Feb 2021 13:59:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Mattson <jmattson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 12/47] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
Message-ID: <YDjwxF2RyKnsQqF/@kroah.com>
References: <20210104155705.740576914@linuxfoundation.org>
 <20210104155706.339275609@linuxfoundation.org>
 <85e3f488-4ec5-2ad3-26a6-097d532824e1@proxmox.com>
 <4fa31425-3c13-0a4f-167b-6566c6302334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fa31425-3c13-0a4f-167b-6566c6302334@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 12:27:49PM +0100, Paolo Bonzini wrote:
> On 26/02/21 12:03, Thomas Lamprecht wrote:
> > On 04.01.21 16:57, Greg Kroah-Hartman wrote:
> > > From: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > [ Upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ]
> > > 
> > > If the guest is configured to have SPEC_CTRL but the host does not
> > > (which is a nonsensical configuration but these are not explicitly
> > > forbidden) then a host-initiated MSR write can write vmx->spec_ctrl
> > > (respectively svm->spec_ctrl) and trigger a #GP when KVM tries to
> > > restore the host value of the MSR.  Add a more comprehensive check
> > > for valid bits of SPEC_CTRL, covering host CPUID flags and,
> > > since we are at it and it is more correct that way, guest CPUID
> > > flags too.
> > > 
> > > For AMD, remove the unnecessary is_guest_mode check around setting
> > > the MSR interception bitmap, so that the code looks the same as
> > > for Intel.
> > > 
> > 
> > A git bisect between 5.4.86 and 5.4.98 showed that this breaks boot of QEMU
> > guests running Windows 10 20H2 on AMD Ryzen X3700 CPUs with a BSOD showing
> > "KERNEL SECURITY CHECK FAILURE".
> > 
> > Reverting this commit or setting the CPU type of the QEMU/KVM command from
> > host to qemu64 allows one to boot Windows 10 in the VM again.
> > 
> > I found a followup, commit 841c2be09fe4f495fe5224952a419bd8c7e5b455 [0],
> > which has a fixes line for this commit and mentions Zen2 AMD CPUs (which
> > the X3700 is).
> > Applying a backport of that commit on top of 5.4.98 stable tree fixed the
> > issue here see below for the backport I used, it applies also cleanly on the
> > more current 5.4.101 release.
> > 
> > So can you please add this patch to the stable trees that backported the
> > problematic upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ?
> > 
> > If I should submit this in any other way just ask, was not sure about
> > what works best with a patch which cannot be cherry-picked cleanly.
> 
> Ok, I'll submit it.
> 
> Thanks for the testing.

Does that mean I should not take the patch here in this email and that
you will submit it after some timeperiod, or that I should take this
patch as-is?

thanks,

greg k-h
