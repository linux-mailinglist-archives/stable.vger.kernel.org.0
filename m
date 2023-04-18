Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF606E6223
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDRMaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDRMad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123CEB767
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6949B631E6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741FFC433D2;
        Tue, 18 Apr 2023 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821000;
        bh=9APf11+Ggi6YTTwaMcRKPqyRTF2eQj5R67YJj6vy0Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxrlMTdMJUZjEy7qeitsVD9Q6bAaSr3w90MmK3bl5AFVZLPFz7kiwKgtQXONWVhLr
         oHZzoiS51/xCqR2xtRIvsZZF7vNQxULPpbDa+VjTZ/I752SjDStEBKyil3DLnZqxaN
         T4bLrLPdAYR3JOrzROTWHI/oJL/KtD0nwSykfpRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 53/92] btrfs: fix fast csum implementation detection
Date:   Tue, 18 Apr 2023 14:21:28 +0200
Message-Id: <20230418120306.710133391@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 68d99ab0e9221ef54506f827576c5a914680eeaf upstream.

The BTRFS_FS_CSUM_IMPL_FAST flag is currently set whenever a non-generic
crc32c is detected, which is the incorrect check if the file system uses
a different checksumming algorithm.  Refactor the code to only check
this if crc32c is actually used.  Note that in an ideal world the
information if an algorithm is hardware accelerated or not should be
provided by the crypto API instead, but that's left for another day.

CC: stable@vger.kernel.org # 5.4.x: c8a5f8ca9a9c: btrfs: print checksum type and implementation at mount time
CC: stable@vger.kernel.org # 5.4.x
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   14 ++++++++++++++
 fs/btrfs/super.c   |    2 --
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2239,6 +2239,20 @@ static int btrfs_init_csum_hash(struct b
 
 	fs_info->csum_shash = csum_shash;
 
+	/*
+	 * Check if the checksum implementation is a fast accelerated one.
+	 * As-is this is a bit of a hack and should be replaced once the csum
+	 * implementations provide that information themselves.
+	 */
+	switch (csum_type) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		if (!strstr(crypto_shash_driver_name(csum_shash), "generic"))
+			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
+		break;
+	default:
+		break;
+	}
+
 	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
 			btrfs_super_csum_name(csum_type),
 			crypto_shash_driver_name(csum_shash));
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1567,8 +1567,6 @@ static struct dentry *btrfs_mount_root(s
 	} else {
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		if (!strstr(crc32c_impl(), "generic"))
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)


