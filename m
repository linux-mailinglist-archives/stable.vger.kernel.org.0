Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A529ADE2E3
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 06:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbfJUEGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 00:06:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54785 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfJUEGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 00:06:22 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46xNNq5r9cz9sPL; Mon, 21 Oct 2019 15:06:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571630779; bh=0gIwOYRl+uLZLFdtC8UjqQo4XwJkG5ky/1miRAY9OXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFrQ7d0o8UWnjar+mh+ZFxZ1mDSn3m5dIt9yNR6EqQjYSz1EYO+gIccKPoGpunI5w
         0AIDCeEV2WBtpDEynARdN3dmOcdhJM/fktF67Gj2ra7tJr4gvR28m8CQBssIPjSIwN
         U+u4hcS38D9+iwBu7BjxWGoo8+oFHHwNY4vNnciPhJ64J28qsWZqvIBSFwlYJtLfEH
         bZybTxodoBoGatjBQtJDljCS71wqI6zuDjmg3XA9343R20BAZQS+pbXCIDJDjHm8qN
         OdhRKdFynZLg5RyG/Xh6q1+iJlbfbEDRxoNwj79dGZ+VOCq7TUTKpG/Vvn//wnWYYs
         40PcjWjjhHX3g==
Date:   Mon, 21 Oct 2019 15:06:15 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/6] KVM: PPC: Book3S: HV: XIVE: Allocate less VPs in
 OPAL
Message-ID: <20191021040615.GA20714@oak.ozlabs.ibm.com>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
 <20191016234403.77cdf150@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016234403.77cdf150@bahia.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 11:44:03PM +0200, Greg Kurz wrote:
> On Fri, 27 Sep 2019 13:53:32 +0200
> Greg Kurz <groug@kaod.org> wrote:
> 
> > This brings some fixes and allows to start more VMs with an in-kernel
> > XIVE or XICS-on-XIVE device.
> > 
> > Changes since v1 (https://patchwork.ozlabs.org/cover/1166099/):
> > - drop a useless patch
> > - add a patch to show VP ids in debugfs
> > - update some changelogs
> > - fix buggy check in patch 5
> > - Cc: stable 
> > 
> > --
> > Greg
> > 
> > ---
> > 
> > Greg Kurz (6):
> >       KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
> >       KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use
> >       KVM: PPC: Book3S HV: XIVE: Show VP id in debugfs
> >       KVM: PPC: Book3S HV: XIVE: Compute the VP id in a common helper
> >       KVM: PPC: Book3S HV: XIVE: Make VP block size configurable
> >       KVM: PPC: Book3S HV: XIVE: Allow userspace to set the # of VPs
> > 
> > 
> >  Documentation/virt/kvm/devices/xics.txt |   14 +++
> >  Documentation/virt/kvm/devices/xive.txt |    8 ++
> >  arch/powerpc/include/uapi/asm/kvm.h     |    3 +
> >  arch/powerpc/kvm/book3s_xive.c          |  142 ++++++++++++++++++++++++-------
> >  arch/powerpc/kvm/book3s_xive.h          |   17 ++++
> >  arch/powerpc/kvm/book3s_xive_native.c   |   40 +++------
> >  6 files changed, 167 insertions(+), 57 deletions(-)
> > 
> 
> Ping ?

I'm about to send a pull request to Paolo for 2/6 (to go into 5.4) and
I'm preparing a tree of stuff for 5.5 that will include the rest of
the patches.  However, I have been delayed by the fact that multipath
SCSI is currently broken upstream on the P8 test box that I use, so I
haven't been able to test things.

Paul.
