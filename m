Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A3406144
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhIJAmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhIJASF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5326023D;
        Fri, 10 Sep 2021 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233005;
        bh=mjkqf7ArkbOFUwySI7EfX+aayF+23tm7SG5OOM3Vj2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4+57ue7fsV6kwJvGpMfYsc+blZUZ4Sq0FvTM2RFW1DpVL9C1GGrQ7B/bCJ6n2psB
         X7lprQicpbq3LiWc/r4nA6LyNa1HT8h0FyB9fduTCbHWTMfvbtW5JIyNwEMkXGqXQC
         Np8d+b47E9XICtrombeCCsYpd3fI6pMyHlRUtCWdQEMzcsjLgKAqRHB2jW7JJrbQ3K
         z86VeaoIleCgYTWPYWZBQaquXiKHpbU2rVdtKQhP6XZz05SeE0GduPYZLcYiEkD2rq
         hlPXqX559aM5+0H+oCZMqfWiVcbZtFW5Px/a0BqEkLY2Pii+DId2LyjlkC95m8coJx
         Z0oocP7Cg/+ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Yangtao Li <frank.li@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.14 33/99] f2fs: fix to stop filesystem update once CP failed
Date:   Thu,  9 Sep 2021 20:14:52 -0400
Message-Id: <20210910001558.173296-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 91803392c732c43b5cf440e885ea89be7f5fecef ]

During f2fs_write_checkpoint(), once we failed in
f2fs_flush_nat_entries() or do_checkpoint(), metadata of filesystem
such as prefree bitmap, nat/sit version bitmap won't be recovered,
it may cause f2fs image to be inconsistent, let's just set CP error
flag to avoid further updates until we figure out a scheme to rollback
all metadatas in such condition.

Reported-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 12 +++++++++---
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/segment.c    | 15 +++++++++++++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6c208108d69c..7f6745f4630e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1639,8 +1639,11 @@ int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* write cached NAT/SIT entries to NAT/SIT area */
 	err = f2fs_flush_nat_entries(sbi, cpc);
-	if (err)
+	if (err) {
+		f2fs_err(sbi, "f2fs_flush_nat_entries failed err:%d, stop checkpoint", err);
+		f2fs_bug_on(sbi, !f2fs_cp_error(sbi));
 		goto stop;
+	}
 
 	f2fs_flush_sit_entries(sbi, cpc);
 
@@ -1648,10 +1651,13 @@ int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	f2fs_save_inmem_curseg(sbi);
 
 	err = do_checkpoint(sbi, cpc);
-	if (err)
+	if (err) {
+		f2fs_err(sbi, "do_checkpoint failed err:%d, stop checkpoint", err);
+		f2fs_bug_on(sbi, !f2fs_cp_error(sbi));
 		f2fs_release_discard_addrs(sbi);
-	else
+	} else {
 		f2fs_clear_prefree_segments(sbi, cpc);
+	}
 
 	f2fs_restore_inmem_curseg(sbi);
 stop:
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ee8eb33e2c25..6cdcd62ea80c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -542,7 +542,7 @@ enum {
 					 */
 };
 
-#define DEFAULT_RETRY_IO_COUNT	8	/* maximum retry read IO count */
+#define DEFAULT_RETRY_IO_COUNT	8	/* maximum retry read IO or flush count */
 
 /* congestion wait timeout value, default: 20ms */
 #define	DEFAULT_IO_TIMEOUT	(msecs_to_jiffies(20))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2e543c7c1bc3..93d4a49eed69 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -776,11 +776,22 @@ int f2fs_flush_device_cache(struct f2fs_sb_info *sbi)
 		return 0;
 
 	for (i = 1; i < sbi->s_ndevs; i++) {
+		int count = DEFAULT_RETRY_IO_COUNT;
+
 		if (!f2fs_test_bit(i, (char *)&sbi->dirty_device))
 			continue;
-		ret = __submit_flush_wait(sbi, FDEV(i).bdev);
-		if (ret)
+
+		do {
+			ret = __submit_flush_wait(sbi, FDEV(i).bdev);
+			if (ret)
+				congestion_wait(BLK_RW_ASYNC,
+						DEFAULT_IO_TIMEOUT);
+		} while (ret && --count);
+
+		if (ret) {
+			f2fs_stop_checkpoint(sbi, false);
 			break;
+		}
 
 		spin_lock(&sbi->dev_lock);
 		f2fs_clear_bit(i, (char *)&sbi->dirty_device);
-- 
2.30.2

