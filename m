Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26683CFF20
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhGTPiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235501AbhGTPgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 11:36:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D697960C41;
        Tue, 20 Jul 2021 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626797848;
        bh=Azt+aCxOrhW4mvJZGqsih/lMcmX0ScC4JNUUFxCyA+g=;
        h=From:To:Cc:Subject:Date:From;
        b=Br/WFtKzj1jVBkzSw8/bSorWfXCMilMpjZo76SfJdn4xEi1GZK26Gp2HM5ZAyY56T
         34KMZawN5DsjeSLqQ+26Lo29H8E65kCTF1wGcYGLZyqcy+f92Zr+VQm2mjycLk7gG6
         WsYErgg/4qlccFiB2AIbetBY55NUjndpiiAlLT2eVSEeds0EzNWEjA1y5bsd03b31P
         wBQnJl+5lQ9xukyPcHBiWDPCad/wj+ZjJd8ciqZ/GxX7sm4fYXK9Xj7ngLiuIyMZie
         eX/egmVojhKoWqdhsCryaRb3PFQe+bbA3/+Npzlv9TmG/5noS/dI2URxwj/p/3yV/w
         Zj50SMbWj99MQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4] f2fs: Show casefolding support only when supported
Date:   Tue, 20 Jul 2021 09:17:09 -0700
Message-Id: <20210720161709.1919109-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

commit 39307f8ee3539478c28e71b4909b5b028cce14b1 upstream.
[Please apply to 5.4-stable.]

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
index 029e693e201c..3a5360e045cf 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -499,7 +499,9 @@ F2FS_FEATURE_RO_ATTR(lost_found, FEAT_LOST_FOUND);
 F2FS_FEATURE_RO_ATTR(verity, FEAT_VERITY);
 #endif
 F2FS_FEATURE_RO_ATTR(sb_checksum, FEAT_SB_CHECKSUM);
+#ifdef CONFIG_UNICODE
 F2FS_FEATURE_RO_ATTR(casefold, FEAT_CASEFOLD);
+#endif
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -568,7 +570,9 @@ static struct attribute *f2fs_feat_attrs[] = {
 	ATTR_LIST(verity),
 #endif
 	ATTR_LIST(sb_checksum),
+#ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),
+#endif
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs_feat);
-- 
2.32.0.402.g57bb445576-goog

