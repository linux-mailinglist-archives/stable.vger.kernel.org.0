Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48F940CC95
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhIOSdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 14:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhIOSdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 14:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3940F61056;
        Wed, 15 Sep 2021 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631730714;
        bh=etJsOpuF3BYgccM2JR6QoWDyJV6uv1ptSNlp+TJTTKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksT6xv5HwYU0R0jvCRxfn0ymCeQkNi8XiMh1wAdR7WgHG2Sx4Pguo4/rnq/wImllM
         R0rteqLFcA6pKpFoPJWger84W4xC85v5Hu5UKQhtLHxaqkw335BHwnMG2GFtG0LEpN
         LQqR+GjGJEG32butIEwFtB1XbYKsWmcVIQppWwl5ooRt9GyOvb33Fz3uuEwnvy+Pkt
         M3tjV8LtEx0cJauViIHh10Yj3FznSXuMnxgwGhwONEe44I+ooSeQXYNFqz8lRmxAeZ
         c0svlbVDrfTVQK7AJ2LPQ2QdKw/0Hcn+7mtKVmVUdbHQFvv1kbou+u95WKJUHDTE72
         qtAFwqlDLh0/Q==
Date:   Wed, 15 Sep 2021 20:31:52 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
Message-ID: <20210915183152.GA22415@lothringen>
References: <1631693373201133@kroah.com>
 <87ilz1pwaq.fsf@wylie.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilz1pwaq.fsf@wylie.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 06:45:33PM +0100, Alan J. Wylie wrote:
> 564005805aadec9cb7e5dc4e14071b8f87cd6b58 is the first bad commit
> commit 564005805aadec9cb7e5dc4e14071b8f87cd6b58
> Author: Frederic Weisbecker <frederic@kernel.org>
> Date:   Mon Jul 26 14:55:10 2021 +0200
> 
>     posix-cpu-timers: Force next expiration recalc after itimer reset
>     
>     [ Upstream commit 406dd42bd1ba0c01babf9cde169bb319e52f6147 ]
>     
>     When an itimer deactivates a previously armed expiration, it simply doesn't
>     do anything. As a result the process wide cputime counter keeps running and
>     the tick dependency stays set until it reaches the old ghost expiration
>     value.
>     
>     This can be reproduced with the following snippet:
>     
>             void trigger_process_counter(void)
>             {
>                     struct itimerval n = {};
>     
>                     n.it_value.tv_sec = 100;
>                     setitimer(ITIMER_VIRTUAL, &n, NULL);
>                     n.it_value.tv_sec = 0;
>                     setitimer(ITIMER_VIRTUAL, &n, NULL);
>             }
>     
>     Fix this with resetting the relevant base expiration. This is similar to
>     disarming a timer.
>     
>     Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Link: https://lore.kernel.org/r/20210726125513.271824-4-frederic@kernel.org
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>

Right, this should fix the issue: https://lore.kernel.org/lkml/20210913145332.232023-1-frederic@kernel.org/

Thanks!
