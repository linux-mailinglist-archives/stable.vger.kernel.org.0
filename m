Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D923CFF1E
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhGTPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234394AbhGTPgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5999610FB;
        Tue, 20 Jul 2021 16:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626797804;
        bh=p+Pe0YiOpWyC2St9IqP+fKtMb6eDyQpswKhY6pEHx1g=;
        h=From:To:Cc:Subject:Date:From;
        b=KH4VhwDMkCbzh3AgsCYCA7T9cBDBSeEn6NieSH2a7+9UiQqNBRsjv7oMb9kR1Dwi9
         jnZxop7G3GxGodwBGCrOjXz8rF837J0epj6m1IOZn+T+W6JaDXE3kGWENO79I4AyLm
         MfWAOpncSRL8Jrujj0UbXC62EnQvjekoi7D6lmj6KOFhwr84QXI1ZQlpWwB1Ea5UU1
         K6tE/LvG2bqYfipShuaHq5zK69dxV7DgfKRo7LZozLu7bN12gQEWaZl9klpZu6F5V8
         vdMvNpU9Zu9qiqIYuA5qo8hlsTdd+RFRS7VRwFLqP91N3Dm3xwZUtbO9ouCv9VOJrd
         BjATpRJbkLSBQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10,5.12,5.13] f2fs: Show casefolding support only when supported
Date:   Tue, 20 Jul 2021 09:16:29 -0700
Message-Id: <20210720161629.1918963-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

commit 39307f8ee3539478c28e71b4909b5b028cce14b1 upstream.
[Please apply to 5.10-stable, 5.12-stable, and 5.13-stable.]

The casefolding feature is only supported when CONFIG_UNICODE is set.
This modifies the feature list f2fs presents under sysfs accordingly.

Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index ec77ccfea923..b8850c81068a 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -612,7 +612,9 @@ F2FS_FEATURE_RO_ATTR(lost_found, FEAT_LOST_FOUND);
 F2FS_FEATURE_RO_ATTR(verity, FEAT_VERITY);
 #endif
 F2FS_FEATURE_RO_ATTR(sb_checksum, FEAT_SB_CHECKSUM);
+#ifdef CONFIG_UNICODE
 F2FS_FEATURE_RO_ATTR(casefold, FEAT_CASEFOLD);
+#endif
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 F2FS_FEATURE_RO_ATTR(compression, FEAT_COMPRESSION);
 #endif
@@ -700,7 +702,9 @@ static struct attribute *f2fs_feat_attrs[] = {
 	ATTR_LIST(verity),
 #endif
 	ATTR_LIST(sb_checksum),
+#ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),
+#endif
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	ATTR_LIST(compression),
 #endif
-- 
2.32.0.402.g57bb445576-goog

