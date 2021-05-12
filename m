Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000AA37B829
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhELIis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:38:48 -0400
Received: from 8bytes.org ([81.169.241.247]:38784 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhELIiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:38:46 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E8C872A5; Wed, 12 May 2021 10:37:37 +0200 (CEST)
Date:   Wed, 12 May 2021 10:37:34 +0200
From:   'Joerg Roedel' <joro@8bytes.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
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
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Message-ID: <YJuTzhSp2XAJIYlv@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 08:04:33AM +0000, David Laight wrote:
> That can't be right at all.
> __put/get_user() are only valid on user addresses and will try to
> fault in a missing page - so can sleep.

Yes, in general these functions can sleep, but not in this context. They
are called in atomic context and the page-fault handler will notice that
and goes down the __bad_area_nosemaphore() path and only do the fixup.

I also thought about adding page_fault_disable()/page_fault_enable()
calls, but being in atomic context is enough according to the
faulthandler_disabled() implementation.

This is exactly what is needed here. All I want to know is whether a
fault happened or not, the page-fault handler must not try to fix the
fault in any way. If a fault happens it is later fixed up in
vc_forward_exception().

> At best this is abused the calls.

Yes, but that is only due to the naming of these functions. In this case
they do exactly what is needed.

Regards,

	Joerg
