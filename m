Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123696467E6
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 04:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLHDg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 22:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLHDgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 22:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D144207;
        Wed,  7 Dec 2022 19:35:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D63B2B821FF;
        Thu,  8 Dec 2022 03:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E955C433C1;
        Thu,  8 Dec 2022 03:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670470541;
        bh=3b5O7KzxVK5v6Enic7QwsmTYpgriCPuNr5Ncf/UzA1o=;
        h=From:To:Cc:Subject:Date:From;
        b=XoOO2i7k4RlhGjMK+25Qipm85wYb5Nt2nMYBaI742so57TB4+HJfQy3F1+ZHMX2aQ
         yC4iZ6LjqH04uZOh99NpALbH2ZCJ/J+t96CEjX7WzV4hPkur5QCNsq+T3rUIoJoy1n
         uD6sNcrSBKfIh2CaxSGLey5b5CVT1AY8KANXREyPvkWSOTm93FeUQUZs9aLAgq/89E
         W9ptvHu2sMFUlSjhPcpmKr2ddo7R9meyKnDG1oywJNjFpaOAG5k0xaqRyFkFqVc6Wv
         J37oGR4xUZNpUbTvGhx7Qz8tPb1l6Z0mm9JzZJbMyXk7zYMk1Bx9MFC2fZMsttNIM3
         9utjFcMXzdbHg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Luca Boccassi <bluca@debian.org>,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>, stable@vger.kernel.org
Subject: [PATCH] fsverity: don't check builtin signatures when require_signatures=0
Date:   Wed,  7 Dec 2022 19:35:23 -0800
Message-Id: <20221208033523.122642-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

An issue that arises when migrating from builtin signatures to userspace
signatures is that existing files that have builtin signatures cannot be
opened unless either CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled or
the signing certificate is left in the .fs-verity keyring.

Since builtin signatures provide no security benefit when
fs.verity.require_signatures=0 anyway, let's just skip the signature
verification in this case.

Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/signature.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a80088..dc6935701abda 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -13,8 +13,8 @@
 #include <linux/verification.h>
 
 /*
- * /proc/sys/fs/verity/require_signatures
- * If 1, all verity files must have a valid builtin signature.
+ * /proc/sys/fs/verity/require_signatures.  If 1, then builtin signatures are
+ * verified and all verity files must have a valid builtin signature.
  */
 static int fsverity_require_signatures;
 
@@ -54,6 +54,20 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return 0;
 	}
 
+	/*
+	 * If require_signatures=0, don't verify builtin signatures.
+	 * Originally, builtin signatures were verified opportunistically in
+	 * this case.  However, no security property is possible when
+	 * require_signatures=0 anyway.  Skipping the builtin signature
+	 * verification makes it easier to migrate existing files from builtin
+	 * signature verification to userspace signature verification.
+	 */
+	if (!fsverity_require_signatures) {
+		fsverity_warn(inode,
+			      "Not checking builtin signature due to require_signatures=0");
+		return 0;
+	}
+
 	d = kzalloc(sizeof(*d) + hash_alg->digest_size, GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;

base-commit: 479174d402bcf60789106eedc4def3957c060bad
-- 
2.38.1

