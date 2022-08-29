Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110E95A4B6D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiH2MTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiH2MSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D308FA2630;
        Mon, 29 Aug 2022 05:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E93611D4;
        Mon, 29 Aug 2022 11:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01E3C433C1;
        Mon, 29 Aug 2022 11:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771398;
        bh=CcvhuDNw5qbcHmwy2zshWRqK1xATh0A24rhR35OQhk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH5AvRmm/iUSOvg8F+o0BWhcqUhNpP98VhvX2yPQgP/L5bnK4naXoeTC3Oe15VIww
         8cK2kYAr3vv0BEQ5RN/+qPgCkRUDVCGPtZe3q/WrLJjkg5XZbBhMiyl8KxjLn+9ff2
         vxcX9G1C6SUP81KqUhRdFBO6W31IOsZj7QCfR0Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Boris Burkov <boris@bur.io>, Zixuan Fu <r33s3n6@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 099/136] btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()
Date:   Mon, 29 Aug 2022 12:59:26 +0200
Message-Id: <20220829105808.735329576@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zixuan Fu <r33s3n6@gmail.com>

commit 9ea0106a7a3d8116860712e3f17cd52ce99f6707 upstream.

In btrfs_get_dev_args_from_path(), btrfs_get_bdev_and_sb() can fail if
the path is invalid. In this case, btrfs_get_dev_args_from_path()
returns directly without freeing args->uuid and args->fsid allocated
before, which causes memory leak.

To fix these possible leaks, when btrfs_get_bdev_and_sb() fails,
btrfs_put_dev_args_from_path() is called to clean up the memory.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Fixes: faa775c41d655 ("btrfs: add a btrfs_get_dev_args_from_path helper")
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2392,8 +2392,11 @@ int btrfs_get_dev_args_from_path(struct
 
 	ret = btrfs_get_bdev_and_sb(path, FMODE_READ, fs_info->bdev_holder, 0,
 				    &bdev, &disk_super);
-	if (ret)
+	if (ret) {
+		btrfs_put_dev_args_from_path(args);
 		return ret;
+	}
+
 	args->devid = btrfs_stack_device_id(&disk_super->dev_item);
 	memcpy(args->uuid, disk_super->dev_item.uuid, BTRFS_UUID_SIZE);
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))


