Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37D9388CDC
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 13:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhESLfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 07:35:09 -0400
Received: from 8bytes.org ([81.169.241.247]:39854 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhESLfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 07:35:09 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 689F82FA; Wed, 19 May 2021 13:33:48 +0200 (CEST)
Date:   Wed, 19 May 2021 13:33:46 +0200
From:   'Joerg Roedel' <joro@8bytes.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Juergen Gross <jgross@suse.com>,
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
Message-ID: <YKT3mpYlPqNHo1QU@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
 <YJuW4TtRJKZ+OIhj@8bytes.org>
 <92244e37-4443-98bd-24aa-bf59548aab47@suse.com>
 <YJugs0CdiNo0/Gbd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJugs0CdiNo0/Gbd@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:32:35AM +0200, Joerg Roedel wrote:
> On Wed, May 12, 2021 at 10:58:20AM +0200, Juergen Gross wrote:
> > No, those were used before, but commit 9da3f2b7405440 broke Xen's use
> > case. That is why I did commit 1457d8cf7664f.
>
> [...]
>
> Having the distinction between user and kernel memory accesses
> explicitly in the code seems to be the most robust solution.

On the other hand, as I found out today, 9da3f2b7405440 had a short
life-time and got reverted upstream. So using __get_user()/__put_user()
should be fine in this code path. It just deserves a comment explaining
its use here and why pagefault_enable()/disable() is not needed.
Even the get_kernel* helpers use __get_user_size() internally.

Regards,

	Joerg
