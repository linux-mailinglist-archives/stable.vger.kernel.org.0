Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E28FF257
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfKPQSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfKPPq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:28 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0530D207FA;
        Sat, 16 Nov 2019 15:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919187;
        bh=QvQ27XNzzcAgPS7U8JGTJIggurF2PvKbrINkZNsf99U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoDAhUpTQON7kOHyf1AC47HQmsNg5P1WWQjQrsf1o/wiQEJGxoJQeK+NihQJPka0k
         I11Kiv6G5qQl5REDJurfZ7B6bmkYShIDn8N7V9ew578sOyACFGqg55LGjN3QX83zuP
         8i3FdbOh//0WJcENcLVK7qfsxr5y+vRo0u9D9ls0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Nikolay Borisov <nborisov@suse.com>,
        Changbin Du <changbin.du@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 195/237] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
Date:   Sat, 16 Nov 2019 10:40:30 -0500
Message-Id: <20191116154113.7417-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7e17916b35797396f681a3270245fd29c1e4c250 ]

Note: this patch fixes a problem in a feature outside of btrfs ("kernel
hacking: add a config option to disable compiler auto-inlining") and is
applied ahead of time due to cross-subsystem dependencies.

On 32-bit ARM with gcc-8, I see a link error with the addition of the
CONFIG_NO_AUTO_INLINE option:

fs/btrfs/super.o: In function `btrfs_statfs':
super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to `__aeabi_uldivmod' follow

So far this is the only file that shows the behavior, so I'd propose
to just work around it by marking the functions as 'static inline'
that normally get inlined here.

The reference to __aeabi_uldivmod comes from a div_u64() which has an
optimization for a constant division that uses a straight '/' operator
when the result should be known to the compiler. My interpretation is
that as we turn off inlining, gcc still expects the result to be constant
but fails to use that constant value.

Link: https://lkml.kernel.org/r/20181103153941.1881966-1-arnd@arndb.de
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[ add the note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8888337a95b64..ddbad8d509490 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1919,7 +1919,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 }
 
 /* Used to sort the devices by max_avail(descending sort) */
-static int btrfs_cmp_device_free_bytes(const void *dev_info1,
+static inline int btrfs_cmp_device_free_bytes(const void *dev_info1,
 				       const void *dev_info2)
 {
 	if (((struct btrfs_device_info *)dev_info1)->max_avail >
@@ -1948,8 +1948,8 @@ static inline void btrfs_descending_sort_devices(
  * The helper to calc the free space on the devices that can be used to store
  * file data.
  */
-static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
-				       u64 *free_bytes)
+static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
+					      u64 *free_bytes)
 {
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-- 
2.20.1

