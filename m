Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1885B6677CC
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbjALOtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbjALOsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7BCC7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3984D62031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431B5C433EF;
        Thu, 12 Jan 2023 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534151;
        bh=zzvr/BphzOUvFO61OWtmqVALTnhTAK8pp/c+0ZLL/wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO31mi1iCpC+04iR5vX0D+uMKWCzo9lFCL0/Vvo3/+9tKXmwWCDxYYVtr+hZTqyzN
         AI8IU2Nc5VKFYsQvM6zcBoPPX+ZXEYQ7Llcu61GE+zjlj5W70xdff3tSzZ5TiH8kIm
         924YFUozj6CpuiFkIITfWwV5NgYotYvdfE+R6Lio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 713/783] ext4: simplify ext4 error translation
Date:   Thu, 12 Jan 2023 14:57:09 +0100
Message-Id: <20230112135557.421234424@linuxfoundation.org>
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

[ Upstream commit 02a7780e4d2fcf438ac6773bc469e7ada2af56be ]

We convert errno's to ext4 on-disk format error codes in
save_error_info(). Add a function and a bit of macro magic to make this
simpler.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20201127113405.26867-7-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 95 +++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 982341939a27..ced84ed4e592 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -545,76 +545,61 @@ static bool system_going_down(void)
 		|| system_state == SYSTEM_RESTART;
 }
 
+struct ext4_err_translation {
+	int code;
+	int errno;
+};
+
+#define EXT4_ERR_TRANSLATE(err) { .code = EXT4_ERR_##err, .errno = err }
+
+static struct ext4_err_translation err_translation[] = {
+	EXT4_ERR_TRANSLATE(EIO),
+	EXT4_ERR_TRANSLATE(ENOMEM),
+	EXT4_ERR_TRANSLATE(EFSBADCRC),
+	EXT4_ERR_TRANSLATE(EFSCORRUPTED),
+	EXT4_ERR_TRANSLATE(ENOSPC),
+	EXT4_ERR_TRANSLATE(ENOKEY),
+	EXT4_ERR_TRANSLATE(EROFS),
+	EXT4_ERR_TRANSLATE(EFBIG),
+	EXT4_ERR_TRANSLATE(EEXIST),
+	EXT4_ERR_TRANSLATE(ERANGE),
+	EXT4_ERR_TRANSLATE(EOVERFLOW),
+	EXT4_ERR_TRANSLATE(EBUSY),
+	EXT4_ERR_TRANSLATE(ENOTDIR),
+	EXT4_ERR_TRANSLATE(ENOTEMPTY),
+	EXT4_ERR_TRANSLATE(ESHUTDOWN),
+	EXT4_ERR_TRANSLATE(EFAULT),
+};
+
+static int ext4_errno_to_code(int errno)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(err_translation); i++)
+		if (err_translation[i].errno == errno)
+			return err_translation[i].code;
+	return EXT4_ERR_UNKNOWN;
+}
+
 static void __save_error_info(struct super_block *sb, int error,
 			      __u32 ino, __u64 block,
 			      const char *func, unsigned int line)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	int err;
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	if (bdev_read_only(sb->s_bdev))
 		return;
+	/* We default to EFSCORRUPTED error... */
+	if (error == 0)
+		error = EFSCORRUPTED;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
 	ext4_update_tstamp(es, s_last_error_time);
 	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
 	es->s_last_error_line = cpu_to_le32(line);
 	es->s_last_error_ino = cpu_to_le32(ino);
 	es->s_last_error_block = cpu_to_le64(block);
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
+	es->s_last_error_errcode = ext4_errno_to_code(error);
 	if (!es->s_first_error_time) {
 		es->s_first_error_time = es->s_last_error_time;
 		es->s_first_error_time_hi = es->s_last_error_time_hi;
-- 
2.35.1



