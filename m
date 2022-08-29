Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29565A4A13
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiH2Lc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiH2Lb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AAC6D9FA;
        Mon, 29 Aug 2022 04:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48597B80EFD;
        Mon, 29 Aug 2022 11:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3A1C433C1;
        Mon, 29 Aug 2022 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771792;
        bh=aZhd3YmQLna6BBuKxhJ9tgx7jmB9mjF0yLmDcIg1nOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMQ6ehiPLhwWTwAZ3pkRjOLp4NkyGnpw+otcLastxWwZxU6ZqpOQhuIZpHFxlqfFa
         oJci/LxaamI5oQQvE5lp3XNO6fKpuHrqvZSQj+hNV3BEKXlWkuC2qLcGjwNUnVRgk4
         MWSh2u2qbBlrbg5nqWt70liRPW25exM0rtmvA5B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Boris Burkov <boris@bur.io>, Zixuan Fu <r33s3n6@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 099/158] btrfs: fix possible memory leak in btrfs_get_dev_args_from_path()
Date:   Mon, 29 Aug 2022 12:59:09 +0200
Message-Id: <20220829105813.238164604@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
@@ -2344,8 +2344,11 @@ int btrfs_get_dev_args_from_path(struct
 
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


