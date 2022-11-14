Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7676C628095
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbiKNNHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237835AbiKNNHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14AC2AC44
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0D36116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF75C433D7;
        Mon, 14 Nov 2022 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431221;
        bh=a26DtNwVDV57TeVZmSOUDIdgInS4Fl8zhnx6+WuQsBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=041uO7X9db+uzYpRcnEWAEMzTDTClUufXw+ye1kDjZsXSc5WNGf6HB7rPJ7c/7cip
         MJtf2AN5fF9SKujV09NmIchdaQMp8KnEVanuSCSrcJm77AjUSB4kYSOkuPxNGx+fZM
         /hZ5YvrLzg7FlUYjbiqyStp4XU4RTMlcBHUbkKbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+031687116258450f9853@syzkaller.appspotmail.com,
        Nikolay Borisov <nborisov@suse.com>,
        Liu Shixin <liushixin2@huawei.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 146/190] btrfs: fix match incorrectly in dev_args_match_device
Date:   Mon, 14 Nov 2022 13:46:10 +0100
Message-Id: <20221114124505.175789887@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

commit 0fca385d6ebc3cabb20f67bcf8a71f1448bdc001 upstream.

syzkaller found a failed assertion:

  assertion failed: (args->devid != (u64)-1) || args->missing, in fs/btrfs/volumes.c:6921

This can be triggered when we set devid to (u64)-1 by ioctl. In this
case, the match of devid will be skipped and the match of device may
succeed incorrectly.

Patch 562d7b1512f7 introduced this function which is used to match device.
This function contains two matching scenarios, we can distinguish them by
checking the value of args->missing rather than check whether args->devid
and args->uuid is default value.

Reported-by: syzbot+031687116258450f9853@syzkaller.appspotmail.com
Fixes: 562d7b1512f7 ("btrfs: handle device lookup with btrfs_dev_lookup_args")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6805,18 +6805,18 @@ static bool dev_args_match_fs_devices(co
 static bool dev_args_match_device(const struct btrfs_dev_lookup_args *args,
 				  const struct btrfs_device *device)
 {
-	ASSERT((args->devid != (u64)-1) || args->missing);
+	if (args->missing) {
+		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
+		    !device->bdev)
+			return true;
+		return false;
+	}
 
-	if ((args->devid != (u64)-1) && device->devid != args->devid)
+	if (device->devid != args->devid)
 		return false;
 	if (args->uuid && memcmp(device->uuid, args->uuid, BTRFS_UUID_SIZE) != 0)
 		return false;
-	if (!args->missing)
-		return true;
-	if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state) &&
-	    !device->bdev)
-		return true;
-	return false;
+	return true;
 }
 
 /*


