Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF77E603C92
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiJSIub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJSIsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:48:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6858A7CC;
        Wed, 19 Oct 2022 01:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F88B822E8;
        Wed, 19 Oct 2022 08:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5160EC433D6;
        Wed, 19 Oct 2022 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168984;
        bh=J3hY5Ke9dVOuH+qLSGit5n24qZH/9BcKbPIcxeJC+gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E02MFpItxfWQV/ySY/R0dnXBKrftwD8opc2f+5/PPlLJomyyV0v/SVHCP+ZvNTgTv
         3oD4CjygG3Zye6dzqqZhsHK3mLu8zzHse+GDs3TgY4PIZlzMKgrGKSWvjxlSnF6F+y
         P/I/L4BCrsSrpwOwDssvmIAdFrDbZkH+Ga/Kn8QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 120/862] btrfs: fix race between quota enable and quota rescan ioctl
Date:   Wed, 19 Oct 2022 10:23:27 +0200
Message-Id: <20221019083255.255485433@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1174,6 +1174,21 @@ out_add_root:
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


