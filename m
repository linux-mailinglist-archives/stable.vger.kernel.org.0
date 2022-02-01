Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683DB4A62FE
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 18:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiBARwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 12:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiBARwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 12:52:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4007C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 09:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AA961265
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 17:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E6FC340EB;
        Tue,  1 Feb 2022 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643737926;
        bh=TRYGhzL70RJyw0hE4Xe5aA8dYUsaeL/blHdv5dXhy0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z5qFpiII6mdf6rTGTR+QZZDpAc2cizAG0zzMKFApBO3fXIPbgwqck/5OxYQlmHrmV
         GQOdt3P0Y410aWyz5Lz/lN+sSpqK1GoDUwj+qG6rBcyA7rYSo+EkGrjS+5F36XFBVI
         RoVfxuhjHLWoRyR/3Qx3Rd2Lz0XIWWYZmwHJBZBY=
Date:   Tue, 1 Feb 2022 18:52:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 4.4] KVM: x86: Fix misplaced backport of "work
 around leak of uninitialized stack contents"
Message-ID: <YflzRMVgi+NB4ETP@kroah.com>
References: <1643735871-15065-1-git-send-email-guillaume.bertholon@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643735871-15065-1-git-send-email-guillaume.bertholon@ens.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 06:17:51PM +0100, Guillaume Bertholon wrote:
> The upstream commit 541ab2aeb282 ("KVM: x86: work around leak of
> uninitialized stack contents") resets `exception` in the function
> `kvm_write_guest_virt_system`.
> However, its backported version in stable (commit ba7f1c934f2e
> ("KVM: x86: work around leak of uninitialized stack contents")) applied
> the change in `emulator_write_std` instead.
> 
> This patch moves the memset instruction back to
> `kvm_write_guest_virt_system`.
> 
> Fixes: ba7f1c934f2e ("KVM: x86: work around leak of uninitialized stack contents")
> Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8dce61c..9101002 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4417,13 +4417,6 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
>  	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
>  		access |= PFERR_USER_MASK;
> 
> -	/*
> -	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> -	 * is returned, but our callers are not ready for that and they blindly
> -	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
> -	 * uninitialized kernel stack memory into cr2 and error code.
> -	 */
> -	memset(exception, 0, sizeof(*exception));
>  	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>  					   access, exception);
>  }
> @@ -4431,6 +4424,13 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
>  int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>  				unsigned int bytes, struct x86_exception *exception)
>  {
> +	/*
> +	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> +	 * is returned, but our callers are not ready for that and they blindly
> +	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
> +	 * uninitialized kernel stack memory into cr2 and error code.
> +	 */
> +	memset(exception, 0, sizeof(*exception));
>  	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
>  					   PFERR_WRITE_MASK, exception);
>  }
> --
> 2.7.4
> 

All 3 now queued up.

Note, 4.4.y is about to go end-of-life now, so I wouldn't spend much
more time on it if you do not want to.

thanks,

greg k-h
