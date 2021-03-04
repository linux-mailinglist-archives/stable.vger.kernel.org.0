Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C4032D3F9
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbhCDNMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241160AbhCDNL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:11:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E2F60200;
        Thu,  4 Mar 2021 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614863477;
        bh=fiJoc141Ox+0/3y0Mk+fBbXEKUWXZpERHteNBMvVeYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8AHECZGiT6NQdL7UEgIZB/8n1/z7wToDaaiQ/u/yE3haDSWmTOp8I5mfFFIGdD8k
         rZFbCMeAHIyQigX5mncRWpM/n2ifE1/hLAfXRaSdEgCrDouqD8ubP2Jwy7xnKXYgSE
         0eUAlLjJIHO5KZJglvyQq6ckQbEZjKnn8xpDDSZk=
Date:   Thu, 4 Mar 2021 14:11:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sharan Turlapati <sturlapati@vmware.com>
Cc:     stable@vger.kernel.org, lee.jones@linaro.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, anishs@vmware.com, vsirnapalli@vmware.com,
        akaher@vmware.com
Subject: Re: [PATCH v4.4.y] futex: Ensure the correct return value from
 futex_lock_pi()
Message-ID: <YEDccyrqhM5gGy7d@kroah.com>
References: <20210302194749.82945-1-sturlapati@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302194749.82945-1-sturlapati@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 11:47:49AM -0800, Sharan Turlapati wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit 12bb3f7f1b03d5913b3f9d4236a488aa7774dfe9 upstream
> 
> In case that futex_lock_pi() was aborted by a signal or a timeout and the
> task returned without acquiring the rtmutex, but is the designated owner of
> the futex due to a concurrent futex_unlock_pi() fixup_owner() is invoked to
> establish consistent state. In that case it invokes fixup_pi_state_owner()
> which in turn tries to acquire the rtmutex again. If that succeeds then it
> does not propagate this success to fixup_owner() and futex_lock_pi()
> returns -EINTR or -ETIMEOUT despite having the futex locked.
> 
> Return success from fixup_pi_state_owner() in all cases where the current
> task owns the rtmutex and therefore the futex and propagate it correctly
> through fixup_owner(). Fixup the other callsite which does not expect a
> positive return value.
> 
> Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: stable@vger.kernel.org
> [Sharan: Backported patch for kernel 4.4.y. Also folded in is a part
>  of the cleanup patch d7c5ed73b19c("futex: Remove needless goto's")]
> Signed-off-by: Sharan Turlapati <sturlapati@vmware.com>
> ---
>  kernel/futex.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Now queued up, thanks.

greg k-h
