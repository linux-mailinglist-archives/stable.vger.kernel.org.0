Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D78F60B081
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiJXQGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiJXQEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F262013F6C;
        Mon, 24 Oct 2022 07:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D99FBB81630;
        Mon, 24 Oct 2022 12:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D139C433D6;
        Mon, 24 Oct 2022 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613926;
        bh=Q39EAbnq4NOHgHPvPqteBhV/UhoTJX8hhLH9VJiuayQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMLYSoU5j5rc/9ZJmCPKR53VLoi9qWCHlamM24FEXi3QR45Vgk1ARKuvye2OxxUUB
         Ppt6MEa7zTwijqxfUE8p5zd7TML8xJ5YTnyAeFM56FFOXxwlJ4svJhVsaGCJp65Pjr
         WyObJzo0z7y8+y8Hu88VWXDw7Gj3kt1dtqYzawRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 049/390] btrfs: fix race between quota enable and quota rescan ioctl
Date:   Mon, 24 Oct 2022 13:27:26 +0200
Message-Id: <20221024113024.720487503@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 331cd9461412e103d07595a10289de90004ac890 upstream.

When enabling quotas, at btrfs_quota_enable(), after committing the
transaction, we change fs_info->quota_root to point to the quota root we
created and set BTRFS_FS_QUOTA_ENABLED at fs_info->flags. Then we try
to start the qgroup rescan worker, first by initializing it with a call
to qgroup_rescan_init() - however if that fails we end up freeing the
quota root but we leave fs_info->quota_root still pointing to it, this
can later result in a use-after-free somewhere else.

We have previously set the flags BTRFS_FS_QUOTA_ENABLED and
BTRFS_QGROUP_STATUS_FLAG_ON, so we can only fail with -EINPROGRESS at
btrfs_quota_enable(), which is possible if someone already called the
quota rescan ioctl, and therefore started the rescan worker.

So fix this by ignoring an -EINPROGRESS and asserting we can't get any
other error.

Reported-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/linux-btrfs/20220823015931.421355-1-yebin10@huawei.com/
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1158,6 +1158,21 @@ out_add_root:
 		fs_info->qgroup_rescan_running = true;
 	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
 	                         &fs_info->qgroup_rescan_work);
+	} else {
+		/*
+		 * We have set both BTRFS_FS_QUOTA_ENABLED and
+		 * BTRFS_QGROUP_STATUS_FLAG_ON, so we can only fail with
+		 * -EINPROGRESS. That can happen because someone started the
+		 * rescan worker by calling quota rescan ioctl before we
+		 * attempted to initialize the rescan worker. Failure due to
+		 * quotas disabled in the meanwhile is not possible, because
+		 * we are holding a write lock on fs_info->subvol_sem, which
+		 * is also acquired when disabling quotas.
+		 * Ignore such error, and any other error would need to undo
+		 * everything we did in the transaction we just committed.
+		 */
+		ASSERT(ret == -EINPROGRESS);
+		ret = 0;
 	}
 
 out_free_path:


