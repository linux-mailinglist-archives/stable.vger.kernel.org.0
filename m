Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2D37B94C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhELJdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:33:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:55614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhELJdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:33:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35D6CAF75;
        Wed, 12 May 2021 09:32:38 +0000 (UTC)
Date:   Wed, 12 May 2021 11:32:35 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     'Joerg Roedel' <joro@8bytes.org>,
        David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Message-ID: <YJugs0CdiNo0/Gbd@suse.de>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
 <YJuW4TtRJKZ+OIhj@8bytes.org>
 <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 10:58:20AM +0200, Juergen Gross wrote:
> No, those were used before, but commit 9da3f2b7405440 broke Xen's use
> case. That is why I did commit 1457d8cf7664f.

I see, thanks for the heads-up. So here this is not a big issue, because
when an access to kernel space faults under SEV-ES, its a kernel bug
anyway. The issue is that it is not reported correctly.

I think I need to re-work the helper and use probe_kernel_read/write()
when the address is in kernel space. This distinction is already made
when fetching instruction bytes in the #VC handler, but I thought I
could get around it for data accesses.

Having the distinction between user and kernel memory accesses
explicitly in the code seems to be the most robust solution.

Regards,

	Joerg

