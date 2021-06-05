Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE639C470
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 02:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFEAeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 20:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhFEAeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 20:34:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B6A960E0B;
        Sat,  5 Jun 2021 00:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622853136;
        bh=QQjCmgNhjYN8qIse5O8UtgzjzvjCWJU6m8oNOld1b0o=;
        h=From:To:Cc:Subject:Date:From;
        b=ItiBj6oY3FQHUzpt3l47u8FOok3N6dwfaN72iBuFJ7Y7m6ForZPTcG2xiY8YUmfie
         ajqY9PmE7MBKIqs0z9Bli7mpPBSopNsLERbMwMJHywfutgHAGWmAHB3wx+k4wiTReF
         45kTACVs5ahw6I+h3ch04ayCRwS7g9Ij8Iz+spbZ3CFaZKz96EM/a9umz/B/SQXeS2
         WXRMuVQvztZRzKxWkuCQcAyCnYkJmY4ap+xFJeZHqZvZ719PcyqGKISskGpm238z8B
         OIm1U8hz7Ua/aXTHs1d4DI4U4HSsoJ8DG1T9j/8oFZYJFsVIk0y1qZOdMnxU/nv40e
         JZA6IEC80MjaA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: Advertise encrypted casefolding in sysfs
Date:   Fri,  4 Jun 2021 17:32:08 -0700
Message-Id: <20210605003210.856458-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

Older kernels don't support encryption with casefolding. This adds
the sysfs entry encrypted_casefold to show support for those combined
features. Support for this feature was originally added by
commit 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 62fbe4f20dd6..4daa6aeb200b 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -583,6 +583,7 @@ enum feat_id {
 	FEAT_COMPRESSION,
 	FEAT_RO,
 	FEAT_TEST_DUMMY_ENCRYPTION_V2,
+	FEAT_ENCRYPTED_CASEFOLD,
 };
 
 static ssize_t f2fs_feature_show(struct f2fs_attr *a,
@@ -605,6 +606,7 @@ static ssize_t f2fs_feature_show(struct f2fs_attr *a,
 	case FEAT_COMPRESSION:
 	case FEAT_RO:
 	case FEAT_TEST_DUMMY_ENCRYPTION_V2:
+	case FEAT_ENCRYPTED_CASEFOLD:
 		return sprintf(buf, "supported\n");
 	}
 	return 0;
@@ -709,7 +711,10 @@ F2FS_GENERAL_RO_ATTR(avg_vblocks);
 #ifdef CONFIG_FS_ENCRYPTION
 F2FS_FEATURE_RO_ATTR(encryption, FEAT_CRYPTO);
 F2FS_FEATURE_RO_ATTR(test_dummy_encryption_v2, FEAT_TEST_DUMMY_ENCRYPTION_V2);
+#ifdef CONFIG_UNICODE
+F2FS_FEATURE_RO_ATTR(encrypted_casefold, FEAT_ENCRYPTED_CASEFOLD);
 #endif
+#endif /* CONFIG_FS_ENCRYPTION */
 #ifdef CONFIG_BLK_DEV_ZONED
 F2FS_FEATURE_RO_ATTR(block_zoned, FEAT_BLKZONED);
 #endif
@@ -822,7 +827,10 @@ static struct attribute *f2fs_feat_attrs[] = {
 #ifdef CONFIG_FS_ENCRYPTION
 	ATTR_LIST(encryption),
 	ATTR_LIST(test_dummy_encryption_v2),
+#ifdef CONFIG_UNICODE
+	ATTR_LIST(encrypted_casefold),
 #endif
+#endif /* CONFIG_FS_ENCRYPTION */
 #ifdef CONFIG_BLK_DEV_ZONED
 	ATTR_LIST(block_zoned),
 #endif
-- 
2.32.0.rc1.229.g3e70b5a671-goog

