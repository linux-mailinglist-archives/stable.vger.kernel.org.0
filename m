Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5E239D7E2
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGIvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 04:51:00 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39728 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhFGIvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 04:51:00 -0400
Received: from zn.tnic (p200300ec2f0b4f006e4c94f9871f2fda.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:4f00:6e4c:94f9:871f:2fda])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A99E71EC0301;
        Mon,  7 Jun 2021 10:49:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623055747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rdLasSxegzkWiQ/LEYu/db+S6HGIdzjYwkuMrqrwDFg=;
        b=cSCr2ZEYgb+YBeu8EI7Huew00jgvgLkeM68zlb2AxZ3dxb91r6wX5rUCD9DS7glplxopZI
        R9f8ptvi2Sgovedq/L6fEOmihHmCYYLtp+vFdHc6aScsqhigx5y95yD1nfLSds7JuuH8Uf
        4WgKwy2lA18MeE4PVmLga09Sh/YHO5Q=
Date:   Mon, 7 Jun 2021 10:49:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [patch V2 02/14] x86/fpu: Prevent state corruption in
 __fpu__restore_sig()
Message-ID: <YL3dfjIM9YHTW5S2@zn.tnic>
References: <20210605234742.712464974@linutronix.de>
 <20210606001323.067157324@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210606001323.067157324@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 06, 2021 at 01:47:44AM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The non-compacted slowpath uses __copy_from_user() and copies the entire
> user buffer into the kernel buffer, verbatim.  This means that the kernel
> buffer may now contain entirely invalid state on which XRSTOR will #GP.
> validate_user_xstate_header() can detect some of that corruption, but that
> leaves the onus on callers to clear the buffer.
> 
> Prior to XSAVES support it was possible just to reinitialize the buffer,
> completely, but with supervisor states that is not longer possible as the
> buffer clearing code split got it backwards. Fixing that is possible, but
> not corrupting the state in the first place is more robust.
> 
> Avoid corruption of the kernel XSAVE buffer by using copy_user_to_xstate()
> which validates the XSAVE header contents before copying the actual states
> to the kernel. copy_user_to_xstate() was previously only called for
> compacted-format kernel buffers, but it works for both compacted and
> non-compacted forms.
> 
> Using it for the non-compacted form is slower because of multiple
> __copy_from_user() operations, but that cost is less important than robust
> code in an already slow path.
> 
> [ Changelog polished by Dave Hansen ]
> 
> Fixes: b860eb8dce59 ("x86/fpu/xstate: Define new functions for clearing fpregs and xstates")
> Reported-by: syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
> V2: Removed the make validate_user_xstate_header() static hunks (Borislav)
> ---
>  arch/x86/kernel/fpu/signal.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)

Very nice.

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
