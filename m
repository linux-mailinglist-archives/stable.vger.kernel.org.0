Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6863991E4
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 19:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhFBRqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 13:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhFBRqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 13:46:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD45C06174A;
        Wed,  2 Jun 2021 10:45:01 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f0e00ae3ef7328f799462.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:e00:ae3e:f732:8f79:9462])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 377D61EC0521;
        Wed,  2 Jun 2021 19:44:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622655899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=AzM3xhTrlH7s73CtL8W+qobgXBYEp/7QTHcuM3yZjUk=;
        b=bSI/YpWeMhu1qHX5eFypbKURlxDJn/X/QNsHOjgChw1Ftauxji3MkZI95g6OCG4Gf968dN
        N/mRgivrKA1bFXZ/1JzKmu2GfVd826sUNOBg4EUzBVB/UhdQpumOtQyXCxG4Wl9+nC0LE4
        Dn3zFJE+I5TvDHLuyBkLlZi6GPkVHSo=
Date:   Wed, 2 Jun 2021 19:44:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
Subject: Re: [patch 4/8] x86/fpu: Limit xstate copy size in xstateregs_set()
Message-ID: <YLfDleG9X32a/KaU@zn.tnic>
References: <20210602095543.149814064@linutronix.de>
 <20210602101618.736036127@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210602101618.736036127@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 11:55:47AM +0200, Thomas Gleixner wrote:
> If the count argument is larger than the xstate size, this will happily
> copy beyond the end of xstate.
> 
> Fixes: 91c3dba7dbc1 ("x86/fpu/xstate: Fix PTRACE frames for XSAVES")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/fpu/regset.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/fpu/regset.c
> +++ b/arch/x86/kernel/fpu/regset.c
> @@ -117,7 +117,7 @@ int xstateregs_set(struct task_struct *t
>  	/*
>  	 * A whole standard-format XSAVE buffer is needed:
>  	 */
> -	if ((pos != 0) || (count < fpu_user_xstate_size))
> +	if (pos != 0 || count != fpu_user_xstate_size)
>  		return -EFAULT;
>  
>  	xsave = &fpu->state.xsave;

Looking at this one, I guess it and all the CC:stable ones should be at
the beginning of the set so that they go to Linus now...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
