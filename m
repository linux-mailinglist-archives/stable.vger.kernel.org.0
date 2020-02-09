Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A68156BE5
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBIR41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgBIR41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 12:56:27 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8233E2081E;
        Sun,  9 Feb 2020 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581270986;
        bh=ZARf5E6DiGBloePNinRniYvsVPxTalxgl2uYyEETDng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mmXZXZwrF8pizIpjyRqTdAL0OwxKVuYlgUexUyqi0Z+nKRE7kSF2Jla9NVyTHMxO/
         fFYJPhgovU2FWKGWGv8FTaLjDWbwC80hlFmzflvqP5da5d4WfU2UQAXRCd58dYEJXs
         af1y+emuLmDuhbai2DA9A2dX5E+A+rr7Yl9Q55wg=
Date:   Sun, 9 Feb 2020 12:56:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lsun@mellanox.com, andriy.shevchenko@linux.intel.com,
        dwoods@mellanox.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] platform/mellanox: fix potential deadlock
 in the tmfifo" failed to apply to 5.5-stable tree
Message-ID: <20200209175625.GI3584@sasha-vm>
References: <1581248351144103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581248351144103@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:39:11PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From 3454eeeebd115891f34aa2e76eccf08c9b0882bb Mon Sep 17 00:00:00 2001
>From: Liming Sun <lsun@mellanox.com>
>Date: Fri, 20 Dec 2019 12:04:33 -0500
>Subject: [PATCH] platform/mellanox: fix potential deadlock in the tmfifo
> driver
>
>This commit fixes the potential deadlock caused by the console Rx
>and Tx processing at the same time. Rx and Tx both take the console
>and tmfifo spinlock but in different order which causes potential
>deadlock. The fix is to use different tmfifo spinlock for Rx and
>Tx since they protect different resources and it's safe to split
>the lock.
>
>Below is the reported call trace when copying/pasting large string
>in the console.
>
>Rx:
>    _raw_spin_lock_irqsave (hvc lock)
>    __hvc_poll
>    hvc_poll
>    in_intr
>    vring_interrupt
>    mlxbf_tmfifo_rxtx_one_desc (tmfifo lock)
>    mlxbf_tmfifo_rxtx
>    mlxbf_tmfifo_work_rxtx
>Tx:
>    _raw_spin_lock_irqsave (tmfifo lock)
>    mlxbf_tmfifo_virtio_notify
>    virtqueue_notify
>    virtqueue_kick
>    put_chars
>    hvc_push
>    hvc_write (hvc lock)
>    ...
>    do_tty_write
>    tty_write
>
>Fixes: 1357dfd7261f ("platform/mellanox: Add TmFifo driver for Mellanox BlueField Soc")
>Cc: <stable@vger.kernel.org> # 5.4+
>Reviewed-by: David Woods <dwoods@mellanox.com>
>Signed-off-by: Liming Sun <lsun@mellanox.com>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

It looks to me like this commit went in through two different trees:

638bc4ca3d28 ("platform/mellanox: fix potential deadlock in the tmfifo driver")
3454eeeebd11 ("platform/mellanox: fix potential deadlock in the tmfifo driver")

They are identical, so one probably got cleaned up in a merge commit.

Anyway, 3454eeeebd11 is in both 5.4 and 5.5, so nothing to do here.

-- 
Thanks,
Sasha
