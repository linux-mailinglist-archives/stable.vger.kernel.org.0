Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1955A32D99D
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 19:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhCDSsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 13:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbhCDSsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 13:48:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9A7C061574;
        Thu,  4 Mar 2021 10:47:32 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1614883650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYogmClDGDXtIzdBl8gkVqqR3vAy5iANA7xK1vY2Nlc=;
        b=GQPABAiw+cfBTFsyYImaZOaNL8FVuOL7qQHtMoIGKF0tB7VZZerILjiqTVE7+95qCfT3R5
        lNXDseRnMnzfU7/Eb5RPjHRAz08bUZUnIFspQ3n3oLkZDpyeI8G0ZtjriY82zpS5S2M5X+
        fjnpSad3jDegHDjiuyE/avOzx32jsXCwlVhoz5CLZ4mHoIm0N4TAMbOjiGyFDfVo0ypjEs
        N3gmgpMbZTdJSdLyFL+PAGH7oAIGCLlHdZsLxgGuhpbujrH5tWu8gSxlFZ8+dmJzp7a1e4
        rVymdq1MN6A/hKHUbJL9DWrQ/nZ4TeMYFGP18yLUvDTcp0K0hpE2KXuYJS/7SA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1614883650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYogmClDGDXtIzdBl8gkVqqR3vAy5iANA7xK1vY2Nlc=;
        b=6zktYvJBTI94Aw3LkXaLYmmRRHVesQIcZpIDB15MZr7KIlBbr8k9vSz53Qwj+ZLuvu94TY
        77Vpy7kGwmyi03CA==
To:     Mike Galbraith <efault@gmx.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: futex breakage in 4.9 stable branch
In-Reply-To: <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
References: <161408880177110@kroah.com> <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk> <YDygp3WYafzcgt+s@kroah.com> <YD0kkNH+I4xyoTwy@decadent.org.uk> <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
Date:   Thu, 04 Mar 2021 19:47:30 +0100
Message-ID: <87r1ku69j1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04 2021 at 10:12, Mike Galbraith wrote:
> On Mon, 2021-03-01 at 18:29 +0100, Ben Hutchings wrote:
>
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -874,8 +874,12 @@ static void free_pi_state(struct futex_p
>  	 * and has cleaned up the pi_state already
>  	 */
>  	if (pi_state->owner) {
> +		unsigned long flags;
> +
> +		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
>  		pi_state_update_owner(pi_state, NULL);
>  		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
> +             raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);

This hunk is missing in 4.9 as well.

>  	}
>
>  	if (current->pi_state_cache)
> @@ -1406,7 +1410,7 @@ static int wake_futex_pi(u32 __user *uad
>  	if (pi_state->owner != current)
>  		return -EINVAL;
>
> -	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> +	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>
>  	/*

That looks correct.

Thanks,

        tglx
