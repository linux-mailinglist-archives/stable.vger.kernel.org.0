Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1458F2FD31F
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbhATOsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 09:48:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390763AbhATOnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 09:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B445923356;
        Wed, 20 Jan 2021 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611153791;
        bh=+Kp/DzcM4t8Flydae0JxYGhb3H3SDQaNbXWUlEwo80E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fkxi755gWhu+XzKSWG0MXrrixrIE/X2qleZRbExbr/iAhQxzyTg+9oilLuxHUYdaX
         4gp2Es9++hedJyoJjGyQHcdHJNgnywFLkbHh2E+8IvU7idGJMq4UnaxmkZDeBPQiaZ
         YpXdcHGKC+g7zU+WzydeomSSOYwmXoILyXOR+G+zDjR3zwmZfp3wXPs1jO+Vsh+aiK
         WARpBk5KOOsE3RQQOdKfVW6g8yXOESygtG+UklcIqyNwfp/SDKONM4fxbs8MSQ0+HX
         4crUv4NU6GmfgG1ApPgBVTOKrObgCmrkbJfP0UzVXyOfBv+oIrvKS15TGspwq+6Ynf
         aEop4YcLcxFBg==
Date:   Wed, 20 Jan 2021 16:43:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        kai.huang@intel.com, haitao.huang@intel.com, seanjc@google.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YAhBeaItbqYmf0oF@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <20210115071809.GA9138@zn.tnic>
 <YAJ11v5tuS2uMuNm@kernel.org>
 <20210118185712.GE30090@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118185712.GE30090@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 07:57:12PM +0100, Borislav Petkov wrote:
> On Sat, Jan 16, 2021 at 07:12:54AM +0200, Jarkko Sakkinen wrote:
> > > https://lkml.kernel.org/r/X/zoarV7gd/LNo4A@kernel.org
> > 
> > OK, I could recall the race that from but that must be partly because I've
> > been proactively working on it, i.e. getting your point.
> > 
> > So let's say I add this after the sequence:
> > 
> > "The sequence demonstrates a scenario where CPU B starts a new
> > grace period, which goes unnoticed by CPU A in sgx_release(),
> > because it did not remove the final entry from the enclave's
> > mm list."
> > 
> > Would this be sufficient or not?
> 
> Not sure.
> 
> That link above says:
> 
> "Now, let's imagine that there is exactly one entry in the encl->mm_list.
> and sgx_release() execution gets scheduled right after returning from
> synchronize_srcu().
> 
> With some bad luck, some process comes and removes that last entry befoe
> sgx_release() acquires mm_lock."
> 
> So, the last entry gets removed by some other process before
> sgx_release() acquires mm_lock. When it does acquire that lock, the test
> 
> 	if (list_empty(&encl->mm_list))
> 
> will be true because "some other process" has removed that last entry.
> 
> So why do you need the synchronize_srcu() call when this process sees an
> empty mm_list already?
> 
> Thx.

The other process aka some process using the enclave calls list_del_rcu()
(and synchronize_srcu()), which starts a new grace period. If we don't
do it, then the cleanup_srcu() will race with that grace period.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

/Jarkko
