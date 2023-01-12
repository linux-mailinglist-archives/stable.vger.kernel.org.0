Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF586677D0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjALOtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbjALOsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C5E6261
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BE53B81E7C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A16C433D2;
        Thu, 12 Jan 2023 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534148;
        bh=zDOmjKIjOfdrbubPtCvnAHiUkv7sAa88RkMpfolHnfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI7VaMttXZJqmmhpLf1pbuABGexXQjCD4U+nr1Y4T4hg3KyQIwp/3wrfBhCklTvfJ
         80LhiygkzeyGB5emk0V7lcOqQsh8zf57vSLbCTh+ONHuaUzMool1zx3/X12PUOt1Tr
         prbrihhDc1HVUXrxIkU1FPomtUmwtCLtDjjdWCVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 712/783] ext4: move functions in super.c
Date:   Thu, 12 Jan 2023 14:57:08 +0100
Message-Id: <20230112135557.383421177@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 4067662388f97d0f360e568820d9d5bac6a3c9fa ]

Just move error info related functions in super.c close to
ext4_handle_error(). We'll want to combine save_error_info() with
ext4_handle_error() and this makes change more obvious and saves a
forward declaration as well. No functional change.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20201127113405.26867-6-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 196 ++++++++++++++++++++++++------------------------
 1 file changed, 98 insertions(+), 98 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f06a71d612..982341939a27 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -417,104 +417,6 @@ static time64_t __ext4_get_tstamp(__le32 *lo, __u8 *hi)
 #define ext4_get_tstamp(es, tstamp) \
 	__ext4_get_tstamp(&(es)->tstamp, &(es)->tstamp ## _hi)
 
-static void __save_error_info(struct super_block *sb, int error,
-			      __u32 ino, __u64 block,
-			      const char *func, unsigned int line)
-{
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	int err;
-
-	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-	if (bdev_read_only(sb->s_bdev))
-		return;
-	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-	ext4_update_tstamp(es, s_last_error_time);
-	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
-	es->s_last_error_line = cpu_to_le32(line);
-	es->s_last_error_ino = cpu_to_le32(ino);
-	es->s_last_error_block = cpu_to_le64(block);
-	switch (error) {
-	case EIO:
-		err = EXT4_ERR_EIO;
-		break;
-	case ENOMEM:
-		err = EXT4_ERR_ENOMEM;
-		break;
-	case EFSBADCRC:
-		err = EXT4_ERR_EFSBADCRC;
-		break;
-	case 0:
-	case EFSCORRUPTED:
-		err = EXT4_ERR_EFSCORRUPTED;
-		break;
-	case ENOSPC:
-		err = EXT4_ERR_ENOSPC;
-		break;
-	case ENOKEY:
-		err = EXT4_ERR_ENOKEY;
-		break;
-	case EROFS:
-		err = EXT4_ERR_EROFS;
-		break;
-	case EFBIG:
-		err = EXT4_ERR_EFBIG;
-		break;
-	case EEXIST:
-		err = EXT4_ERR_EEXIST;
-		break;
-	case ERANGE:
-		err = EXT4_ERR_ERANGE;
-		break;
-	case EOVERFLOW:
-		err = EXT4_ERR_EOVERFLOW;
-		break;
-	case EBUSY:
-		err = EXT4_ERR_EBUSY;
-		break;
-	case ENOTDIR:
-		err = EXT4_ERR_ENOTDIR;
-		break;
-	case ENOTEMPTY:
-		err = EXT4_ERR_ENOTEMPTY;
-		break;
-	case ESHUTDOWN:
-		err = EXT4_ERR_ESHUTDOWN;
-		break;
-	case EFAULT:
-		err = EXT4_ERR_EFAULT;
-		break;
-	default:
-		err = EXT4_ERR_UNKNOWN;
-	}
-	es->s_last_error_errcode = err;
-	if (!es->s_first_error_time) {
-		es->s_first_error_time = es->s_last_error_time;
-		es->s_first_error_time_hi = es->s_last_error_time_hi;
-		strncpy(es->s_first_error_func, func,
-			sizeof(es->s_first_error_func));
-		es->s_first_error_line = cpu_to_le32(line);
-		es->s_first_error_ino = es->s_last_error_ino;
-		es->s_first_error_block = es->s_last_error_block;
-		es->s_first_error_errcode = es->s_last_error_errcode;
-	}
-	/*
-	 * Start the daily error reporting function if it hasn't been
-	 * started already
-	 */
-	if (!es->s_error_count)
-		mod_timer(&EXT4_SB(sb)->s_err_report, jiffies + 24*60*60*HZ);
-	le32_add_cpu(&es->s_error_count, 1);
-}
-
-static void save_error_info(struct super_block *sb, int error,
-			    __u32 ino, __u64 block,
-			    const char *func, unsigned int line)
-{
-	__save_error_info(sb, error, ino, block, func, line);
-	if (!bdev_read_only(sb->s_bdev))
-		ext4_commit_super(sb, 1);
-}
-
 /*
  * The del_gendisk() function uninitializes the disk-specific data
  * structures, including the bdi structure, without telling anyone
@@ -643,6 +545,104 @@ static bool system_going_down(void)
 		|| system_state == SYSTEM_RESTART;
 }
 
+static void __save_error_info(struct super_block *sb, int error,
+			      __u32 ino, __u64 block,
+			      const char *func, unsigned int line)
+{
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	int err;
+
+	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
+	if (bdev_read_only(sb->s_bdev))
+		return;
+	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
+	ext4_update_tstamp(es, s_last_error_time);
+	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
+	es->s_last_error_line = cpu_to_le32(line);
+	es->s_last_error_ino = cpu_to_le32(ino);
+	es->s_last_error_block = cpu_to_le64(block);
+	switch (error) {
+	case EIO:
+		err = EXT4_ERR_EIO;
+		break;
+	case ENOMEM:
+		err = EXT4_ERR_ENOMEM;
+		break;
+	case EFSBADCRC:
+		err = EXT4_ERR_EFSBADCRC;
+		break;
+	case 0:
+	case EFSCORRUPTED:
+		err = EXT4_ERR_EFSCORRUPTED;
+		break;
+	case ENOSPC:
+		err = EXT4_ERR_ENOSPC;
+		break;
+	case ENOKEY:
+		err = EXT4_ERR_ENOKEY;
+		break;
+	case EROFS:
+		err = EXT4_ERR_EROFS;
+		break;
+	case EFBIG:
+		err = EXT4_ERR_EFBIG;
+		break;
+	case EEXIST:
+		err = EXT4_ERR_EEXIST;
+		break;
+	case ERANGE:
+		err = EXT4_ERR_ERANGE;
+		break;
+	case EOVERFLOW:
+		err = EXT4_ERR_EOVERFLOW;
+		break;
+	case EBUSY:
+		err = EXT4_ERR_EBUSY;
+		break;
+	case ENOTDIR:
+		err = EXT4_ERR_ENOTDIR;
+		break;
+	case ENOTEMPTY:
+		err = EXT4_ERR_ENOTEMPTY;
+		break;
+	case ESHUTDOWN:
+		err = EXT4_ERR_ESHUTDOWN;
+		break;
+	case EFAULT:
+		err = EXT4_ERR_EFAULT;
+		break;
+	default:
+		err = EXT4_ERR_UNKNOWN;
+	}
+	es->s_last_error_errcode = err;
+	if (!es->s_first_error_time) {
+		es->s_first_error_time = es->s_last_error_time;
+		es->s_first_error_time_hi = es->s_last_error_time_hi;
+		strncpy(es->s_first_error_func, func,
+			sizeof(es->s_first_error_func));
+		es->s_first_error_line = cpu_to_le32(line);
+		es->s_first_error_ino = es->s_last_error_ino;
+		es->s_first_error_block = es->s_last_error_block;
+		es->s_first_error_errcode = es->s_last_error_errcode;
+	}
+	/*
+	 * Start the daily error reporting function if it hasn't been
+	 * started already
+	 */
+	if (!es->s_error_count)
+		mod_timer(&EXT4_SB(sb)->s_err_report, jiffies + 24*60*60*HZ);
+	le32_add_cpu(&es->s_error_count, 1);
+}
+
+static void save_error_info(struct super_block *sb, int error,
+			    __u32 ino, __u64 block,
+			    const char *func, unsigned int line)
+{
+	__save_error_info(sb, error, ino, block, func, line);
+	if (!bdev_read_only(sb->s_bdev))
+		ext4_commit_super(sb, 1);
+}
+
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
  *
-- 
2.35.1



