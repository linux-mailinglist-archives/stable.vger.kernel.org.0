Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F324CFAE3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiCGKWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbiCGKRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:17:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C18CF3;
        Mon,  7 Mar 2022 01:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C682B60A27;
        Mon,  7 Mar 2022 09:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B89C340F5;
        Mon,  7 Mar 2022 09:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647054;
        bh=z60zXuYXptNBGJ0tBVZp3+fhv8bqkROWAvgb8COEoY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxJ4k1EoZvp2e+4OO2QMaD8Z0ABaftIyAW6abX+gqd2wsKNmKJJZGpsPjDWNt7Uu/
         5xPOWeVuPgpGpocFI88yeogLhUusOMFWxCYQuP/L76LGzLU0oX+icpT3KriCVDhI9V
         ywmcHuOKxu8tYSk4DMaJCq8eE1+/SmV4bXreUEsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Sidong Yang <realwakka@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 177/186] btrfs: qgroup: fix deadlock between rescan worker and remove qgroup
Date:   Mon,  7 Mar 2022 10:20:15 +0100
Message-Id: <20220307091659.027279680@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sidong Yang <realwakka@gmail.com>

commit d4aef1e122d8bbdc15ce3bd0bc813d6b44a7d63a upstream.

The commit e804861bd4e6 ("btrfs: fix deadlock between quota disable and
qgroup rescan worker") by Kawasaki resolves deadlock between quota
disable and qgroup rescan worker. But also there is a deadlock case like
it. It's about enabling or disabling quota and creating or removing
qgroup. It can be reproduced in simple script below.

for i in {1..100}
do
    btrfs quota enable /mnt &
    btrfs qgroup create 1/0 /mnt &
    btrfs qgroup destroy 1/0 /mnt &
    btrfs quota disable /mnt &
done

Here's why the deadlock happens:

1) The quota rescan task is running.

2) Task A calls btrfs_quota_disable(), locks the qgroup_ioctl_lock
   mutex, and then calls btrfs_qgroup_wait_for_completion(), to wait for
   the quota rescan task to complete.

3) Task B calls btrfs_remove_qgroup() and it blocks when trying to lock
   the qgroup_ioctl_lock mutex, because it's being held by task A. At that
   point task B is holding a transaction handle for the current transaction.

4) The quota rescan task calls btrfs_commit_transaction(). This results
   in it waiting for all other tasks to release their handles on the
   transaction, but task B is blocked on the qgroup_ioctl_lock mutex
   while holding a handle on the transaction, and that mutex is being held
   by task A, which is waiting for the quota rescan task to complete,
   resulting in a deadlock between these 3 tasks.

To resolve this issue, the thread disabling quota should unlock
qgroup_ioctl_lock before waiting rescan completion. Move
btrfs_qgroup_wait_for_completion() after unlock of qgroup_ioctl_lock.

Fixes: e804861bd4e6 ("btrfs: fix deadlock between quota disable and qgroup rescan worker")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Sidong Yang <realwakka@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1197,13 +1197,20 @@ int btrfs_quota_disable(struct btrfs_fs_
 		goto out;
 
 	/*
+	 * Unlock the qgroup_ioctl_lock mutex before waiting for the rescan worker to
+	 * complete. Otherwise we can deadlock because btrfs_remove_qgroup() needs
+	 * to lock that mutex while holding a transaction handle and the rescan
+	 * worker needs to commit a transaction.
+	 */
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
+	/*
 	 * Request qgroup rescan worker to complete and wait for it. This wait
 	 * must be done before transaction start for quota disable since it may
 	 * deadlock with transaction by the qgroup rescan worker.
 	 */
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
-	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	/*
 	 * 1 For the root item


