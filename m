Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B8C22B42E
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgGWRJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 13:09:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:46352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgGWRJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 13:09:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BF90DAF34;
        Thu, 23 Jul 2020 17:09:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3D6D9DA794; Thu, 23 Jul 2020 19:08:58 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix messages after changing compression level by remount
Date:   Thu, 23 Jul 2020 19:08:55 +0200
Message-Id: <20200723170855.30976-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reported by Forza on IRC that remounting with compression options does
not reflect the change in level, or at least it does not appear to do so
according to the messages:

  mount -o compress=zstd:1 /dev/sda /mnt
  mount -o remount,compress=zstd:15 /mnt

does not print the change to the level to syslog:

  [   41.366060] BTRFS info (device vda): use zstd compression, level 1
  [   41.368254] BTRFS info (device vda): disk space caching is enabled
  [   41.390429] BTRFS info (device vda): disk space caching is enabled

What really happens is that the message is lost but the level is actualy
changed.

There's another weird output, if compression is reset to 'no':

  [   45.413776] BTRFS info (device vda): use no compression, level 4

To fix that, save the previous compression level and print the message
in that case too and use separate message for 'no' compression.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5a9dc31d95c9..aa73422b0678 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -517,6 +517,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	char *compress_type;
 	bool compress_force = false;
 	enum btrfs_compression_type saved_compress_type;
+	int saved_compress_level;
 	bool saved_compress_force;
 	int no_compress = 0;
 
@@ -598,6 +599,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				info->compress_type : BTRFS_COMPRESS_NONE;
 			saved_compress_force =
 				btrfs_test_opt(info, FORCE_COMPRESS);
+			saved_compress_level = info->compress_level;
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strncmp(args[0].from, "zlib", 4) == 0) {
@@ -642,6 +644,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				no_compress = 0;
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
+				info->compress_level = 0;
+				info->compress_type = 0;
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 				compress_force = false;
@@ -662,11 +666,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				 */
 				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 			}
-			if ((btrfs_test_opt(info, COMPRESS) &&
-			     (info->compress_type != saved_compress_type ||
-			      compress_force != saved_compress_force)) ||
-			    (!btrfs_test_opt(info, COMPRESS) &&
-			     no_compress == 1)) {
+			if (no_compress == 1) {
+				btrfs_info(info, "use no compression");
+			} else if ((info->compress_type != saved_compress_type) ||
+				   (compress_force != saved_compress_force) ||
+				   (info->compress_level != saved_compress_level)) {
 				btrfs_info(info, "%s %s compression, level %d",
 					   (compress_force) ? "force" : "use",
 					   compress_type, info->compress_level);
-- 
2.25.0

