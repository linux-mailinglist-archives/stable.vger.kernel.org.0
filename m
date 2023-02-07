Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7430768D7AB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjBGNCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjBGNBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637993A853
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 889DFB8198D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD39EC433EF;
        Tue,  7 Feb 2023 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774896;
        bh=ZSom5SCFjac+cpVAyFFXTMAZXa+FLDKPY6nUW5eZMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K478evvUXClnyYmk6eMnnj1IR/o2MQ+q9YdVpp+Dg5Gio5iR3p3qzcbgZwbuYUQnD
         u9ADxgcSAm419Kzr/QgvbUTs7oJ3GEnFsUFfvdSILf2ITH5NyLOjt/hHKbdn2BWzG1
         IlY/uZgxI8aeFSWM0dsINWHyPWi4zjaAfslkQvdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Hou Tao <houtao1@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/208] fscache: Use wait_on_bit() to wait for the freeing of relinquished volume
Date:   Tue,  7 Feb 2023 13:55:06 +0100
Message-Id: <20230207125636.637486035@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 8226e37d82f43657da34dd770e2b38f20242ada7 ]

The freeing of relinquished volume will wake up the pending volume
acquisition by using wake_up_bit(), however it is mismatched with
wait_var_event() used in fscache_wait_on_volume_collision() and it will
never wake up the waiter in the wait-queue because these two functions
operate on different wait-queues.

According to the implementation in fscache_wait_on_volume_collision(),
if the wake-up of pending acquisition is delayed longer than 20 seconds
(e.g., due to the delay of on-demand fd closing), the first
wait_var_event_timeout() will timeout and the following wait_var_event()
will hang forever as shown below:

 FS-Cache: Potential volume collision new=00000024 old=00000022
 ......
 INFO: task mount:1148 blocked for more than 122 seconds.
       Not tainted 6.1.0-rc6+ #1
 task:mount           state:D stack:0     pid:1148  ppid:1
 Call Trace:
  <TASK>
  __schedule+0x2f6/0xb80
  schedule+0x67/0xe0
  fscache_wait_on_volume_collision.cold+0x80/0x82
  __fscache_acquire_volume+0x40d/0x4e0
  erofs_fscache_register_volume+0x51/0xe0 [erofs]
  erofs_fscache_register_fs+0x19c/0x240 [erofs]
  erofs_fc_fill_super+0x746/0xaf0 [erofs]
  vfs_get_super+0x7d/0x100
  get_tree_nodev+0x16/0x20
  erofs_fc_get_tree+0x20/0x30 [erofs]
  vfs_get_tree+0x24/0xb0
  path_mount+0x2fa/0xa90
  do_mount+0x7c/0xa0
  __x64_sys_mount+0x8b/0xe0
  do_syscall_64+0x30/0x60
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Considering that wake_up_bit() is more selective, so fix it by using
wait_on_bit() instead of wait_var_event() to wait for the freeing of
relinquished volume. In addition because waitqueue_active() is used in
wake_up_bit() and clear_bit() doesn't imply any memory barrier, use
clear_and_wake_up_bit() to add the missing memory barrier between
cursor->flags and waitqueue_active().

Fixes: 62ab63352350 ("fscache: Implement volume registration")
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20230113115211.2895845-2-houtao@huaweicloud.com/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/volume.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index ab8ceddf9efa..903af9d85f8b 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -141,13 +141,14 @@ static bool fscache_is_acquire_pending(struct fscache_volume *volume)
 static void fscache_wait_on_volume_collision(struct fscache_volume *candidate,
 					     unsigned int collidee_debug_id)
 {
-	wait_var_event_timeout(&candidate->flags,
-			       !fscache_is_acquire_pending(candidate), 20 * HZ);
+	wait_on_bit_timeout(&candidate->flags, FSCACHE_VOLUME_ACQUIRE_PENDING,
+			    TASK_UNINTERRUPTIBLE, 20 * HZ);
 	if (fscache_is_acquire_pending(candidate)) {
 		pr_notice("Potential volume collision new=%08x old=%08x",
 			  candidate->debug_id, collidee_debug_id);
 		fscache_stat(&fscache_n_volumes_collision);
-		wait_var_event(&candidate->flags, !fscache_is_acquire_pending(candidate));
+		wait_on_bit(&candidate->flags, FSCACHE_VOLUME_ACQUIRE_PENDING,
+			    TASK_UNINTERRUPTIBLE);
 	}
 }
 
@@ -347,8 +348,8 @@ static void fscache_wake_pending_volume(struct fscache_volume *volume,
 	hlist_bl_for_each_entry(cursor, p, h, hash_link) {
 		if (fscache_volume_same(cursor, volume)) {
 			fscache_see_volume(cursor, fscache_volume_see_hash_wake);
-			clear_bit(FSCACHE_VOLUME_ACQUIRE_PENDING, &cursor->flags);
-			wake_up_bit(&cursor->flags, FSCACHE_VOLUME_ACQUIRE_PENDING);
+			clear_and_wake_up_bit(FSCACHE_VOLUME_ACQUIRE_PENDING,
+					      &cursor->flags);
 			return;
 		}
 	}
-- 
2.39.0



