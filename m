Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60CF324C05
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhBYI0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhBYI0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 03:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F0664EC8;
        Thu, 25 Feb 2021 08:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614241540;
        bh=RwokqPiVETJX28uISu7iObNBcTWEjC5c9EqPt2h2nJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XRsybevjiPEkWP/o9R8jrmCnFCRbb3pJmgoSoJdt06Iq1u/iUKLpSJ8r3AfflNXjm
         KAmVf48u8WRsfAZADyNPmMaGNxCT65WYVV8QxaS8q9E69GquFeptfB4jrQFfGWCvc/
         7QP5OO4hA05OmT0stAGMVSMPYP1mZ2MNuzzEmJfI=
Date:   Thu, 25 Feb 2021 09:25:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org, tglx@linutronix.de, lee.jones@linaro.org,
        wangle6@huawei.com, zhengyejian1@huawei.com
Subject: Re: [PATCH] futex: fix dead code in attach_to_pi_owner()
Message-ID: <YDdfASEcv7i/DxHF@kroah.com>
References: <20210222125352.110124-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222125352.110124-1-nixiaoming@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 08:53:52PM +0800, Xiaoming Ni wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The handle_exit_race() function is defined in commit c158b461306df82
>  ("futex: Cure exit race"), which never returns -EBUSY. This results
> in a small piece of dead code in the attach_to_pi_owner() function:
> 
> 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> 	...
> 	if (ret == -EBUSY)
> 		*exiting = p; /* dead code */
> 
> The return value -EBUSY is added to handle_exit_race() in upsteam
> commit ac31c7ff8624409 ("futex: Provide distinct return value when
> owner is exiting"). This commit was incorporated into v4.9.255, before
> the function handle_exit_race() was introduced, whitout Modify
> handle_exit_race().
> 
> To fix dead code, extract the change of handle_exit_race() from
> commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
>  is exiting"), re-incorporated.
> 
> Fixes: c158b461306df82 ("futex: Cure exit race")
> Cc: stable@vger.kernel.org # 4.9.258-rc1
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

What is the git commit id of this patch in Linus's tree?

Also, what kernel tree(s) is this supposed to go to?

thanks,

greg k-h
