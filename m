Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18A375C54
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 22:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhEFUmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 16:42:08 -0400
Received: from 8bytes.org ([81.169.241.247]:37800 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhEFUmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 16:42:07 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E58A0312; Thu,  6 May 2021 22:41:07 +0200 (CEST)
Date:   Thu, 6 May 2021 22:41:05 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        kexec@lists.infradead.org, stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/2] x86/kexec/64: Forbid kexec when running as an SEV-ES
 guest
Message-ID: <YJRUYWRItEziB2eP@8bytes.org>
References: <20210506093122.28607-1-joro@8bytes.org>
 <20210506093122.28607-3-joro@8bytes.org>
 <m17dkb4v4k.fsf@fess.ebiederm.org>
 <YJQ4QTtvG76WpcNf@suse.de>
 <m1o8dn1ye9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1o8dn1ye9.fsf@fess.ebiederm.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 01:59:42PM -0500, Eric W. Biederman wrote:
> Joerg Roedel <jroedel@suse.de> writes:

> Why does it need that?
> 
> Would it not make sense to instead teach kexec how to pass a cpu from
> one kernel to another.  We could use that everywhere.
> 
> Even the kexec-on-panic case should work as even in that case we have
> to touch the cpus as they go down.
> 
> The hardware simply worked well enough that it hasn't mattered enough
> for us to do something like that, but given that we need to do something
> anyway.  It seems like it would make most sense do something that
> will work everywhere, and does not introduce unnecessary dependencies
> on hypervisors.

Well, I guess we could implement something that even works for non
SEV-ES guests and bare-metal. The question is what benefit we get from
that. Is the SIPI sequence currently used not reliable enough?

The benefit of being able to rely on the SIPI sequence is that the
kexec'ed kernel can use the same method to bring up APs as the first
kernel did.

Btw, the same is true for SEV-ES guests, The goal is bring the APs of
an SEV-ES guest into a state where they will use the SEV-ES method of
AP-bringup when they wake up again. This method involves a
firmware-owned page called the AP-jump-table, which contains the reset
vector for the AP in its first 4 bytes.

> > As I said above, for protocol version 1 it will stay disabled, so it is
> > not only a temporary hack.
> 
> Why does bringing up a cpu need hypervisor support?

When a CPU is taken offline under SEV-ES it will do a special hypercall
named AP-reset-hold. The hypervisor will put the CPU into a halt state
until the next SIPI arrives. In protocol version 1 this hypercall
requires a GHCB shared page to be set up for the CPU doing the hypercall
and upon CPU wakeup the HV will write to that shared page. Problem with
that is that the page which contains the GHCB is already owned by the
new kernel then and is probably not shared anymore, which can cause data
corruption in the new kernel.

Version 2 of the protocol adds a purely MSR based version of the
AP-reset-hold hypercall. This one does not need a GHCB page and has to
be used to bring the APs offline before doing the kexec. That is the
reason I plan to only support kexec when the hypervisor provides version
2 of the protocol.

Regards,

	Joerg
