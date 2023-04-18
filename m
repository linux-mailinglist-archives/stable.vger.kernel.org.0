Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5186E6458
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjDRMsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjDRMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972CB14F78
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 332D9632C7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415FFC433D2;
        Tue, 18 Apr 2023 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822090;
        bh=eJv6BuXLFuWEkkXgveBeYOWvZbZ3H89DHG5DQ8649ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9Ur/OqvBU21W3PINjfKoGMFddXBqAlRjFgYpTs1q3k8bNrTyrhP3nxNuDxyWwcwv
         8LHH3DoQf09x5YOjZ0snDze5+1qPw+QJmnB3Z3f+iFW+TylOFs2EdNPJBQRHGsCP5g
         gfC6LnelklJ74bxwFVEYM3RMK5IH6lcwNlFJxqTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 019/139] btrfs: fix fast csum implementation detection
Date:   Tue, 18 Apr 2023 14:21:24 +0200
Message-Id: <20230418120314.373844746@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -2433,6 +2433,20 @@ static int btrfs_init_csum_hash(struct b
 
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
@@ -1515,8 +1515,6 @@ static struct dentry *btrfs_mount_root(s
 		shrinker_debugfs_rename(&s->s_shrink, "sb-%s:%s", fs_type->name,
 					s->s_id);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		if (!strstr(crc32c_impl(), "generic"))
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)


