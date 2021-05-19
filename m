Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF85388EC5
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhESNSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 09:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbhESNSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 09:18:02 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F9CC06175F;
        Wed, 19 May 2021 06:16:42 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 63C252FA; Wed, 19 May 2021 15:16:39 +0200 (CEST)
Date:   Wed, 19 May 2021 15:16:38 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/6] x86/sev-es: Forward page-faults which happen during
 emulation
Message-ID: <YKUPtrquQyImL3h5@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-3-joro@8bytes.org>
 <YJwQ1xsiDtv3LkBe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJwQ1xsiDtv3LkBe@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sean,

On Wed, May 12, 2021 at 05:31:03PM +0000, Sean Christopherson wrote:
> This got me looking at the flows that "inject" #PF, and I'm pretty sure there
> are bugs in __vc_decode_user_insn() + insn_get_effective_ip().
> 
> Problem #1: __vc_decode_user_insn() assumes a #PF if insn_fetch_from_user_inatomic()
> fails, but the majority of failure cases in insn_get_seg_base() are #GPs, not #PF.
> 
> 	res = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
> 	if (!res) {
> 		ctxt->fi.vector     = X86_TRAP_PF;
> 		ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
> 		ctxt->fi.cr2        = ctxt->regs->ip;
> 		return ES_EXCEPTION;
> 	}
> 
> Problem #2: Using '0' as an error code means a legitimate effective IP of '0'
> will be misinterpreted as a failure.  Practically speaking, I highly doubt anyone
> will ever actually run code at address 0, but it's technically possible.  The
> most robust approach would be to pass a pointer to @ip and return an actual error
> code.  Using a non-canonical magic value might also work, but that could run afoul
> of future shenanigans like LAM.
> 
> 	ip = insn_get_effective_ip(regs);
> 	if (!ip)
> 		return 0;

Your observations are all correct. I put some changes onto this
patch-set to fix these problems.

Regards,

	Joerg
