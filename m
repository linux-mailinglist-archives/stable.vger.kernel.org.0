Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F26AF74FE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKNcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:32:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKNcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:32:07 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1801520659;
        Mon, 11 Nov 2019 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573479126;
        bh=aiTXrfxdjKeyfdf6H3nyeLSDzkbYqQe7JCj2U8ij2EM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DMtwNeB8Bt1JI0ikk8t7tKx+7xv7AEYGT11LkS1+AK0myUN+CrMzIqZGrcgmP2ZFp
         GLDjnZq2kbmYSAmfQjZPL9bMXNBxcCdrZiZij5hqVNgyUZSOxlllqGs1Z3SFO2LTVc
         F/jaY4qBad3EOqW940z8Z/Dc95arjdB0F7qr9uKk=
Date:   Mon, 11 Nov 2019 08:32:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sunny.s.zhang@oracle.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com,
        piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] ocfs2: protect extent tree in
 ocfs2_prepare_inode_for_write()" failed to apply to 5.3-stable tree
Message-ID: <20191111133204.GS4787@sasha-vm>
References: <15734523452030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15734523452030@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:05:45AM +0100, gregkh@linuxfoundation.org wrote:
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
>From e74540b285569d2b1e14fe7aee92297078f235ce Mon Sep 17 00:00:00 2001
>From: Shuning Zhang <sunny.s.zhang@oracle.com>
>Date: Tue, 5 Nov 2019 21:16:34 -0800
>Subject: [PATCH] ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()
>
>When the extent tree is modified, it should be protected by inode
>cluster lock and ip_alloc_sem.
>
>The extent tree is accessed and modified in the
>ocfs2_prepare_inode_for_write, but isn't protected by ip_alloc_sem.
>
>The following is a case.  The function ocfs2_fiemap is accessing the
>extent tree, which is modified at the same time.
>
>  kernel BUG at fs/ocfs2/extent_map.c:475!
>  invalid opcode: 0000 [#1] SMP
>  Modules linked in: tun ocfs2 ocfs2_nodemanager configfs ocfs2_stackglue [...]
>  CPU: 16 PID: 14047 Comm: o2info Not tainted 4.1.12-124.23.1.el6uek.x86_64 #2
>  Hardware name: Oracle Corporation ORACLE SERVER X7-2L/ASM, MB MECH, X7-2L, BIOS 42040600 10/19/2018
>  task: ffff88019487e200 ti: ffff88003daa4000 task.ti: ffff88003daa4000
>  RIP: ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
>  Call Trace:
>    ocfs2_fiemap+0x1e3/0x430 [ocfs2]
>    do_vfs_ioctl+0x155/0x510
>    SyS_ioctl+0x81/0xa0
>    system_call_fastpath+0x18/0xd8
>  Code: 18 48 c7 c6 60 7f 65 a0 31 c0 bb e2 ff ff ff 48 8b 4a 40 48 8b 7a 28 48 c7 c2 78 2d 66 a0 e8 38 4f 05 00 e9 28 fe ff ff 0f 1f 00 <0f> 0b 66 0f 1f 44 00 00 bb 86 ff ff ff e9 13 fe ff ff 66 0f 1f
>  RIP  ocfs2_get_clusters_nocache.isra.11+0x390/0x550 [ocfs2]
>  ---[ end trace c8aa0c8180e869dc ]---
>  Kernel panic - not syncing: Fatal exception
>  Kernel Offset: disabled
>
>This issue can be reproduced every week in a production environment.
>
>This issue is related to the usage mode.  If others use ocfs2 in this
>mode, the kernel will panic frequently.
>
>[akpm@linux-foundation.org: coding style fixes]
>[Fix new warning due to unused function by removing said function - Linus ]
>Link: http://lkml.kernel.org/r/1568772175-2906-2-git-send-email-sunny.s.zhang@oracle.com
>Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
>Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
>Reviewed-by: Gang He <ghe@suse.com>
>Cc: Mark Fasheh <mark@fasheh.com>
>Cc: Joel Becker <jlbec@evilplan.org>
>Cc: Joseph Qi <jiangqi903@gmail.com>
>Cc: Changwei Ge <gechangwei@live.cn>
>Cc: Jun Piao <piaojun@huawei.com>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I've cleaned up minor context conflicts and queued it for 5.3 and 4.19.
For older kernels it needs a more complex backport which I have not
attempted.

-- 
Thanks,
Sasha
