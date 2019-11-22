Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CCB106BFA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfKVKsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbfKVKsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:48:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8566920748;
        Fri, 22 Nov 2019 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419727;
        bh=73kGtPxbG7AHS1m7uIan7hnFziG77Y1VjpxICPqueis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6DrYKXI2wBKq/btln8G8lIw2YYayxwgZy+CcF9+yLHHMtqR/3dGDVDH5M8+UzEif
         bObJ2DKedJ2vcZCPBrIBXHZOFF2FfGM2KjlZbuT+77EwLVXRGsl/eU7wVB8yZZD76e
         0OuoOQe6vkdUb48bsbALdqvXWhBbUgnY+wOZJAZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Smith <tim.smith@citrix.com>,
        Mark Syms <mark.syms@citrix.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 209/222] GFS2: Flush the GFS2 delete workqueue before stopping the kernel threads
Date:   Fri, 22 Nov 2019 11:29:09 +0100
Message-Id: <20191122100917.437609501@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Smith <tim.smith@citrix.com>

[ Upstream commit 1eb8d7387908022951792a46fa040ad3942b3b08 ]

Flushing the workqueue can cause operations to happen which might
call gfs2_log_reserve(), or get stuck waiting for locks taken by such
operations.  gfs2_log_reserve() can io_schedule(). If this happens, it
will never wake because the only thing which can wake it is gfs2_logd()
which was already stopped.

This causes umount of a gfs2 filesystem to wedge permanently if, for
example, the umount immediately follows a large delete operation.

When this occured, the following stack trace was obtained from the
umount command

[<ffffffff81087968>] flush_workqueue+0x1c8/0x520
[<ffffffffa0666e29>] gfs2_make_fs_ro+0x69/0x160 [gfs2]
[<ffffffffa0667279>] gfs2_put_super+0xa9/0x1c0 [gfs2]
[<ffffffff811b7edf>] generic_shutdown_super+0x6f/0x100
[<ffffffff811b7ff7>] kill_block_super+0x27/0x70
[<ffffffffa0656a71>] gfs2_kill_sb+0x71/0x80 [gfs2]
[<ffffffff811b792b>] deactivate_locked_super+0x3b/0x70
[<ffffffff811b79b9>] deactivate_super+0x59/0x60
[<ffffffff811d2998>] cleanup_mnt+0x58/0x80
[<ffffffff811d2a12>] __cleanup_mnt+0x12/0x20
[<ffffffff8108c87d>] task_work_run+0x7d/0xa0
[<ffffffff8106d7d9>] exit_to_usermode_loop+0x73/0x98
[<ffffffff81003961>] syscall_return_slowpath+0x41/0x50
[<ffffffff815a594c>] int_ret_from_sys_call+0x25/0x8f
[<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Tim Smith <tim.smith@citrix.com>
Signed-off-by: Mark Syms <mark.syms@citrix.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e3ee387a6dfeb..37496d83661a7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -844,10 +844,10 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	if (error && !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
 		return error;
 
+	flush_workqueue(gfs2_delete_workqueue);
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
 
-	flush_workqueue(gfs2_delete_workqueue);
 	gfs2_quota_sync(sdp->sd_vfs, 0);
 	gfs2_statfs_sync(sdp->sd_vfs, 0);
 
-- 
2.20.1



