Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5614E6EA3
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 10:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfJ1JCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 05:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730849AbfJ1JCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 05:02:54 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83447208C0;
        Mon, 28 Oct 2019 09:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572253374;
        bh=RLXQEA4hoHi5VQwK5Cn+GxVXP92Cp6td4/gtu+fnLzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vLe4ZWvpf5r6Mcr5E8ZwC9/ZK1NfEpyhcmYYuFH2H0T1xbOe3ChQ+8Pow2nadcQRL
         n5be+t3P4NY54VQooUFdWK8Tim1+5ii1zHIQI/7Eg5x62oX0gZolsOF/Sa1k5kQcJb
         nDDTu2CE5r7sH23JPeAAMjA5wlB84Me5gb9NWI70=
Date:   Mon, 28 Oct 2019 05:02:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chenwandun@huawei.com, akpm@linux-foundation.org, axboe@kernel.dk,
        minchan@kernel.org, sergey.senozhatsky.work@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] zram: fix race between backing_dev_show
 and backing_dev_store" failed to apply to 4.19-stable tree
Message-ID: <20191028090250.GK1560@sasha-vm>
References: <157218396713963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157218396713963@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 02:46:07PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From f7daefe4231e57381d92c2e2ad905a899c28e402 Mon Sep 17 00:00:00 2001
>From: Chenwandun <chenwandun@huawei.com>
>Date: Fri, 18 Oct 2019 20:20:14 -0700
>Subject: [PATCH] zram: fix race between backing_dev_show and backing_dev_store
>
>CPU0:				       CPU1:
>backing_dev_show		       backing_dev_store
>    ......				   ......
>    file = zram->backing_dev;
>    down_read(&zram->init_lock);	   down_read(&zram->init_init_lock)
>    file_path(file, ...);		   zram->backing_dev = backing_dev;
>    up_read(&zram->init_lock);		   up_read(&zram->init_lock);
>
>gets the value of zram->backing_dev too early in backing_dev_show, which
>resultin the value being NULL at the beginning, and not NULL later.
>
>backtrace:
>  d_path+0xcc/0x174
>  file_path+0x10/0x18
>  backing_dev_show+0x40/0xb4
>  dev_attr_show+0x20/0x54
>  sysfs_kf_seq_show+0x9c/0x10c
>  kernfs_seq_show+0x28/0x30
>  seq_read+0x184/0x488
>  kernfs_fop_read+0x5c/0x1a4
>  __vfs_read+0x44/0x128
>  vfs_read+0xa0/0x138
>  SyS_read+0x54/0xb4
>
>Link: http://lkml.kernel.org/r/1571046839-16814-1-git-send-email-chenwandun@huawei.com
>Signed-off-by: Chenwandun <chenwandun@huawei.com>
>Acked-by: Minchan Kim <minchan@kernel.org>
>Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
>Cc: Jens Axboe <axboe@kernel.dk>
>Cc: <stable@vger.kernel.org>	[4.14+]
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This conflict was due to the refactoring done by 7e5292831b346 ("zram:
refactor flags and writeback stuff"). I originally wanted to take it as
well, but there were too many changes in 4.14, so instead I fixed up the
original conflict and queued it up for 4.19 and 4.14.

-- 
Thanks,
Sasha
