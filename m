Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA372045A9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 02:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgFWAfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 20:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgFWAfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 20:35:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63E6420738;
        Tue, 23 Jun 2020 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592872551;
        bh=7yOHDT461vSpj/jjDIn5QVlwkRxfAR4LpisV9Vkla1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tET74z3Zm5RNpwVfGkuL3THeJ3AHt0usdqsxkj28rH3B2YiQYdbuc4ElCIYTFT/QR
         ANo1FZOa5BKJb/CwjpfFD0wDadgt+PZU+Jr72b+UPCQkzf0puQxDD9tSoDM3/VixkM
         AY/e7odW72qOobG/jXzGsjKYAjsdFtouGcU+VNKQ=
Date:   Mon, 22 Jun 2020 20:35:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     a.darwish@linutronix.de, axboe@kernel.dk, bigeasy@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] block: nr_sects_write(): Disable
 preemption on seqcount write" failed to apply to 5.4-stable tree
Message-ID: <20200623003550.GP1931@sasha-vm>
References: <1592574219220115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592574219220115@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 03:43:39PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 15b81ce5abdc4b502aa31dff2d415b79d2349d2f Mon Sep 17 00:00:00 2001
>From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>Date: Wed, 3 Jun 2020 16:49:48 +0200
>Subject: [PATCH] block: nr_sects_write(): Disable preemption on seqcount write
>
>For optimized block readers not holding a mutex, the "number of sectors"
>64-bit value is protected from tearing on 32-bit architectures by a
>sequence counter.
>
>Disable preemption before entering that sequence counter's write side
>critical section. Otherwise, the read side can preempt the write side
>section and spin for the entire scheduler tick. If the reader belongs to
>a real-time scheduling class, it can spin forever and the kernel will
>livelock.
>
>Fixes: c83f6bf98dc1 ("block: add partition resize function to blkpg ioctl")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

part_nr_sects_write() was in include/linux/genhd.h before 581e26004a09
("block: move block layer internals out of include/linux/genhd.h").
Fixed and queued for all branched.

-- 
Thanks,
Sasha
