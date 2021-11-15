Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27F94514EC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349518AbhKOUOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:14:21 -0500
Received: from mail.hallyn.com ([178.63.66.53]:39844 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347167AbhKOTjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:39:02 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 14:38:57 EST
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 92EC38DA; Mon, 15 Nov 2021 13:26:26 -0600 (CST)
Date:   Mon, 15 Nov 2021 13:26:26 -0600
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Alistair Delva <adelva@google.com>
Cc:     linux-kernel@vger.kernel.org,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, john.johansen@canonical.com
Subject: Re: [PATCH v2] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Message-ID: <20211115192626.GA25294@mail.hallyn.com>
References: <20211115181655.3608659-1-adelva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115181655.3608659-1-adelva@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 06:16:55PM +0000, Alistair Delva wrote:
> Booting to Android userspace on 5.14 or newer triggers the following
> SELinux denial:
> 
> avc: denied { sys_nice } for comm="init" capability=23
>      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>      permissive=0
> 
> Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> better compatibility with older SEPolicy, check ADMIN before NICE.
> 
> Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
> Signed-off-by: Alistair Delva <adelva@google.com>
> Cc: Khazhismel Kumykov <khazhy@google.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Serge Hallyn <serge@hallyn.com>

This won't harm anything, so

Acked-by: Serge Hallyn <serge@hallyn.com>

but questions below.

> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: selinux@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: stable@vger.kernel.org # v5.14+
> ---
> v2: added comment requested by Jens
>  block/ioprio.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/block/ioprio.c b/block/ioprio.c
> index 0e4ff245f2bf..313c14a70bbd 100644
> --- a/block/ioprio.c
> +++ b/block/ioprio.c
> @@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
>  
>  	switch (class) {
>  		case IOPRIO_CLASS_RT:
> -			if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
> +			/*
> +			 * Originally this only checked for CAP_SYS_ADMIN,
> +			 * which was implicitly allowed for pid 0 by security

What do you mean, implicitly allowed for pid 0?  Can you point to where
that happens?

> +			 * modules such as SELinux. Make sure we check
> +			 * CAP_SYS_ADMIN first to avoid a denial/avc for
> +			 * possibly missing CAP_SYS_NICE permission.
> +			 */
> +			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
>  				return -EPERM;

But whichever one comes first can cause an avc denial message.  It seems
like we need a new capable() primitive which supports multiple bits,
when more than one can authorize an action, and which emits an audit
message only if all bits are missing.

>  			fallthrough;
>  			/* rt has prio field too */
> -- 
> 2.34.0.rc1.387.gb447b232ab-goog
