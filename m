Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319303490C4
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhCYLio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhCYLcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 07:32:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29454C061760;
        Thu, 25 Mar 2021 04:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=YGID0xECimIMLryZR+HuzR7e4RnLnX9dphMfMmTGiJk=; b=azC0nK9NpKbp3grfr43aYCxHKv
        aI92k3eUQe0wzp+ds+Wnc8FIeJqoGp4OhfcyjjaZniaxbKjCi93dJoOlAAcMvgB/+GgmfUko91SUm
        V4MFz6oQ4OEaLFdql2IdCc0pJyDjz6YSNJePEiiOKG3zMuZP641SrnA/DNqBISoAvtVTcYLuxl1Bg
        ETr6Zq24hVJqnuAIEvVj0DOUV5tHQzHNOKtcLMvjuanaeUeidqIsrN2lOC+h3BikfhXy7Kj2wa1Hs
        17TSFgjFmRt3IWshunlpEqDR75mY++nrxMWlDUt0cjNdlSaBxGNNW9TPQxzL8eHrgCxZ5d48OLRzc
        yw01SxKb26HLscvEwCnzAUyJPAVVN+GdnrtTURB1bSsZmtBEtOrrOEF/oaK3ebCf0C6MbB7qKERIr
        3IyHJqWju11ZAV8um5K4gFXWV2JfW9KaUvZKoFzyc9NjWaHqt7Sr/avis1zRLUZIP/ys01r7gPhl0
        7YFoH6KDG7dxHTQzqIu43MO3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPOEH-0007MD-2v; Thu, 25 Mar 2021 11:32:45 +0000
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-42-sashal@kernel.org>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH AUTOSEL 5.11 42/44] signal: don't allow sending any
 signals to PF_IO_WORKER threads
Message-ID: <ca2fdf0b-d140-524f-1533-b3390a54c5de@samba.org>
Date:   Thu, 25 Mar 2021 12:32:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210325112459.1926846-42-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.03.21 um 12:24 schrieb Sasha Levin:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit 5be28c8f85ce99ed2d329d2ad8bdd18ea19473a5 ]
> 
> They don't take signals individually, and even if they share signals with
> the parent task, don't allow them to be delivered through the worker
> thread. Linux does allow this kind of behavior for regular threads, but
> it's really a compatability thing that we need not care about for the IO
> threads.
> 
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/signal.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 5ad8566534e7..55526b941011 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -833,6 +833,9 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
>  
>  	if (!valid_signal(sig))
>  		return -EINVAL;
> +	/* PF_IO_WORKER threads don't take any signals */
> +	if (t->flags & PF_IO_WORKER)
> +		return -ESRCH;

Why is that proposed for 5.11 and 5.10 now?

Are the create_io_thread() patches already backported?

I think we should hold on with the backports until
everything is stable in v5.12 final.

I'm still about to test on top of v5.12-rc4
and have a pending mail why I think this particular change is
wrong even in 5.12.

Jens, did you send these to stable?

metze

