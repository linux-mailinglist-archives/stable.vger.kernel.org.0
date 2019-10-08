Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CBFD03E8
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJHXP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJHXP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:15:56 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374FC2054F;
        Tue,  8 Oct 2019 23:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570576555;
        bh=dZ5gVzi5XXnL00GtXDesYDBUtZE300cSO6lhMZ+2SnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wyST2L+8Zn4tlBwFhlxgGTKO/Y2CnkdXcGwpFLcFfx6hG6MK1lMowtYS38qkKi9uK
         oUtfVlh/Un/KNPKUU0FOzIgxEe4a7GzO2qk+DrmqHHIsf5vbAqfYdHxvJf7CmuLft9
         7IvLJ8zb7aSRzxjpTbPdymQTbM7y3/ZI02IUdNl0=
Date:   Tue, 8 Oct 2019 19:15:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     balasubramani_vivekanandan@mentor.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tick: broadcast-hrtimer: Fix a race in
 bc_set_next" failed to apply to 5.3-stable tree
Message-ID: <20191008231554.GK1396@sasha-vm>
References: <1570520554227151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570520554227151@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:42:34AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From b9023b91dd020ad7e093baa5122b6968c48cc9e0 Mon Sep 17 00:00:00 2001
>From: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
>Date: Thu, 26 Sep 2019 15:51:01 +0200
>Subject: [PATCH] tick: broadcast-hrtimer: Fix a race in bc_set_next
>
>When a cpu requests broadcasting, before starting the tick broadcast
>hrtimer, bc_set_next() checks if the timer callback (bc_handler) is active
>using hrtimer_try_to_cancel(). But hrtimer_try_to_cancel() does not provide
>the required synchronization when the callback is active on other core.
>
>The callback could have already executed tick_handle_oneshot_broadcast()
>and could have also returned. But still there is a small time window where
>the hrtimer_try_to_cancel() returns -1. In that case bc_set_next() returns
>without doing anything, but the next_event of the tick broadcast clock
>device is already set to a timeout value.
>
>In the race condition diagram below, CPU #1 is running the timer callback
>and CPU #2 is entering idle state and so calls bc_set_next().
>
>In the worst case, the next_event will contain an expiry time, but the
>hrtimer will not be started which happens when the racing callback returns
>HRTIMER_NORESTART. The hrtimer might never recover if all further requests
>from the CPUs to subscribe to tick broadcast have timeout greater than the
>next_event of tick broadcast clock device. This leads to cascading of
>failures and finally noticed as rcu stall warnings
>
>Here is a depiction of the race condition
>
>CPU #1 (Running timer callback)                   CPU #2 (Enter idle
>                                                  and subscribe to
>                                                  tick broadcast)
>---------------------                             ---------------------
>
>__run_hrtimer()                                   tick_broadcast_enter()
>
>  bc_handler()                                      __tick_broadcast_oneshot_control()
>
>    tick_handle_oneshot_broadcast()
>
>      raw_spin_lock(&tick_broadcast_lock);
>
>      dev->next_event = KTIME_MAX;                  //wait for tick_broadcast_lock
>      //next_event for tick broadcast clock
>      set to KTIME_MAX since no other cores
>      subscribed to tick broadcasting
>
>      raw_spin_unlock(&tick_broadcast_lock);
>
>    if (dev->next_event == KTIME_MAX)
>      return HRTIMER_NORESTART
>    // callback function exits without
>       restarting the hrtimer                      //tick_broadcast_lock acquired
>                                                   raw_spin_lock(&tick_broadcast_lock);
>
>                                                   tick_broadcast_set_event()
>
>                                                     clockevents_program_event()
>
>                                                       dev->next_event = expires;
>
>                                                       bc_set_next()
>
>                                                         hrtimer_try_to_cancel()
>                                                         //returns -1 since the timer
>                                                         callback is active. Exits without
>                                                         restarting the timer
>  cpu_base->running = NULL;
>
>The comment that hrtimer cannot be armed from within the callback is
>wrong. It is fine to start the hrtimer from within the callback. Also it is
>safe to start the hrtimer from the enter/exit idle code while the broadcast
>handler is active. The enter/exit idle code and the broadcast handler are
>synchronized using tick_broadcast_lock. So there is no need for the
>existing try to cancel logic. All this can be removed which will eliminate
>the race condition as well.
>
>Fixes: 5d1638acb9f6 ("tick: Introduce hrtimer based broadcast")
>Originally-by: Thomas Gleixner <tglx@linutronix.de>
>Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: stable@vger.kernel.org
>Link: https://lkml.kernel.org/r/20190926135101.12102-2-balasubramani_vivekanandan@mentor.com

I've fixed up a conflict due to 902a9f9c50905 ("tick: Mark tick related
hrtimers to expiry in hard interrupt context") and queued it for
5.3-4.14. It needs something more complex for older kernels.

-- 
Thanks,
Sasha
