Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4974062A9
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhIJAqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhIJAWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F8261101;
        Fri, 10 Sep 2021 00:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233251;
        bh=RwRUn0MgCcUH+GWikW74gmoXov/6AZBQly1Ppzu2lHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jgk70RNt0jc4ugEnQVZmlLNjgZSCC8cynSEfJ+pJKeNztCWlzskoeeMt+TaUU802S
         RbsEjKvcBjBN+WeX3DbDIXNaeEMlml8gPXkGkv727qIaRX93kGGGDKp2A8VVNM0IKk
         AhCm24JFByPa+zLhWiYMoQ+ulNsR4uM8+ROea+KBbfN6Sk5JFITC3Pj3kwUUzgkR5+
         sSYJhris3FzkMw9yQMVF8n7FLoGqk0jW8uqzqQobsN+6TnmX2guITcTL8SvXMj5UT0
         DmkHtscMq8OzBw5DaOOg5OHrvB9tkJs41QkdXiDxgJ20Xo05Byf8p5VcaSuS3k380h
         5yvTMLoXl3RAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Yangtao Li <frank.li@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 16/53] f2fs: fix to stop filesystem update once CP failed
Date:   Thu,  9 Sep 2021 20:19:51 -0400
Message-Id: <20210910002028.175174-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index b39bf416d511..4e1f6860ee95 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1620,8 +1620,11 @@ int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* write cached NAT/SIT entries to NAT/SIT area */
 	err = f2fs_flush_nat_entries(sbi, cpc);
-	if (err)
+	if (err) {
+		f2fs_err(sbi, "f2fs_flush_nat_entries failed err:%d, stop checkpoint", err);
+		f2fs_bug_on(sbi, !f2fs_cp_error(sbi));
 		goto stop;
+	}
 
 	f2fs_flush_sit_entries(sbi, cpc);
 
@@ -1629,10 +1632,13 @@ int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
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
index 2d7799bd30b1..95eef965bbce 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -514,7 +514,7 @@ enum {
 					 */
 };
 
-#define DEFAULT_RETRY_IO_COUNT	8	/* maximum retry read IO count */
+#define DEFAULT_RETRY_IO_COUNT	8	/* maximum retry read IO or flush count */
 
 /* congestion wait timeout value, default: 20ms */
 #define	DEFAULT_IO_TIMEOUT	(msecs_to_jiffies(20))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 730f028e8f49..0b2013709f8e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -767,11 +767,22 @@ int f2fs_flush_device_cache(struct f2fs_sb_info *sbi)
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

