Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9076E6648CE
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbjAJSPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbjAJSOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FC3F5B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5483461866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F8C433EF;
        Tue, 10 Jan 2023 18:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374370;
        bh=5qBgZrEU9QTReooa3VV96A8GGKnPsNfmShLSGQ3rlAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF4OirmvRkffXp688RkuTFj2aNlGo9bcKUWgMcZlztbruxtJzmonea1Msb2DR64HV
         /TuKIPxGCkCVRNLcdpnUU5h0yOWRd1dxR2qp6sgye/1nBtcm8A8ufhC0jgtr+Qu0qg
         iu7HJin0KQBNcAcDaVm37PRdz6RUO29ikMa4PRLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 146/148] btrfs: make thaw time super block check to also verify checksum
Date:   Tue, 10 Jan 2023 19:04:10 +0100
Message-Id: <20230110180021.815272890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 3d17adea74a56a4965f7a603d8ed8c66bb9356d9 upstream.

Previous commit a05d3c915314 ("btrfs: check superblock to ensure the fs
was not modified at thaw time") only checks the content of the super
block, but it doesn't really check if the on-disk super block has a
matching checksum.

This patch will add the checksum verification to thaw time superblock
verification.

This involves the following extra changes:

- Export btrfs_check_super_csum()
  As we need to call it in super.c.

- Change the argument list of btrfs_check_super_csum()
  Instead of passing a char *, directly pass struct btrfs_super_block *
  pointer.

- Verify that our checksum type didn't change before checking the
  checksum value, like it's done at mount time

Fixes: a05d3c915314 ("btrfs: check superblock to ensure the fs was not modified at thaw time")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   10 ++++------
 fs/btrfs/disk-io.h |    2 ++
 fs/btrfs/super.c   |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -167,11 +167,9 @@ static bool btrfs_supported_super_csum(u
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   const struct btrfs_super_block *disk_sb)
 {
-	struct btrfs_super_block *disk_sb =
-		(struct btrfs_super_block *)raw_disk_sb;
 	char result[BTRFS_CSUM_SIZE];
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 
@@ -182,7 +180,7 @@ static int btrfs_check_super_csum(struct
 	 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space is
 	 * filled with zeros and is included in the checksum.
 	 */
-	crypto_shash_digest(shash, raw_disk_sb + BTRFS_CSUM_SIZE,
+	crypto_shash_digest(shash, (const u8 *)disk_sb + BTRFS_CSUM_SIZE,
 			    BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE, result);
 
 	if (memcmp(disk_sb->csum, result, fs_info->csum_size))
@@ -3471,7 +3469,7 @@ int __cold open_ctree(struct super_block
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(fs_info, (u8 *)disk_super)) {
+	if (btrfs_check_super_csum(fs_info, disk_super)) {
 		btrfs_err(fs_info, "superblock checksum mismatch");
 		err = -EINVAL;
 		btrfs_release_disk_super(disk_super);
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -42,6 +42,8 @@ struct extent_buffer *btrfs_find_create_
 void btrfs_clean_tree_block(struct extent_buffer *buf);
 void btrfs_clear_oneshot_options(struct btrfs_fs_info *fs_info);
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info);
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   const struct btrfs_super_block *disk_sb);
 int __cold open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2553,6 +2553,7 @@ static int check_dev_super(struct btrfs_
 {
 	struct btrfs_fs_info *fs_info = dev->fs_info;
 	struct btrfs_super_block *sb;
+	u16 csum_type;
 	int ret = 0;
 
 	/* This should be called with fs still frozen. */
@@ -2567,6 +2568,21 @@ static int check_dev_super(struct btrfs_
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
+	/* Verify the checksum. */
+	csum_type = btrfs_super_csum_type(sb);
+	if (csum_type != btrfs_super_csum_type(fs_info->super_copy)) {
+		btrfs_err(fs_info, "csum type changed, has %u expect %u",
+			  csum_type, btrfs_super_csum_type(fs_info->super_copy));
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	if (btrfs_check_super_csum(fs_info, sb)) {
+		btrfs_err(fs_info, "csum for on-disk super block no longer matches");
+		ret = -EUCLEAN;
+		goto out;
+	}
+
 	/* Btrfs_validate_super() includes fsid check against super->fsid. */
 	ret = btrfs_validate_super(fs_info, sb, 0);
 	if (ret < 0)


