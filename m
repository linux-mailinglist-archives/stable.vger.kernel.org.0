Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AA5A05B0
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiHYBeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiHYBeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F74F8A1E5;
        Wed, 24 Aug 2022 18:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CECF261ACE;
        Thu, 25 Aug 2022 01:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93160C433C1;
        Thu, 25 Aug 2022 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391244;
        bh=nJQztERCJ6fOtBuXGVaIChdP66y0wPJhC1YXN7Y43yE=;
        h=From:To:Cc:Subject:Date:From;
        b=CkdkRV9tHyXuaSwWo18+lnctEyecwmYbcNyvqxOFN1EsswhXRtu7veACj5dF3ta9M
         kYHAtwnS345w6TygRa2WDFC5z6W2AfyRE6eWUJ0TczlLUJhl5rQZywBv+HOzwvZDgU
         4wo/IiicwwAk0YKTOXD/gXEEeImEz7QITt7S48MRccWM2RFlWc8BKLILeLbxHhLW2w
         UvP5Hau566mdFqWvx4H2ZNJ/sYhZv5TXn12LYxpu0tGdhTzIdNFUk4s/+T8EtJjHwX
         8hE26dtYDmHgR2OYne/gOiPBTe+TALxPSlMAOSa6Sl0g0ppYOIDFdUOtGCwDYnSzWI
         uIcK+N5VrEe1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 01/38] fs/ntfs3: Fix work with fragmented xattr
Date:   Wed, 24 Aug 2022 21:33:24 -0400
Message-Id: <20220825013401.22096-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 42f86b1226a42bfc79a7125af435432ad4680a32 ]

In some cases xattr is too fragmented,
so we need to load it before writing.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 5e0e0280e70d..d2337ee0b7d6 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -118,7 +118,7 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 
 		run_init(&run);
 
-		err = attr_load_runs(attr_ea, ni, &run, NULL);
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &run, 0, size);
 		if (!err)
 			err = ntfs_read_run_nb(sbi, &run, 0, ea_p, size, NULL);
 		run_close(&run);
@@ -444,6 +444,11 @@ static noinline int ntfs_set_ea(struct inode *inode, const char *name,
 		/* Delete xattr, ATTR_EA */
 		ni_remove_attr_le(ni, attr, mi, le);
 	} else if (attr->non_res) {
+		err = attr_load_runs_range(ni, ATTR_EA, NULL, 0, &ea_run, 0,
+					   size);
+		if (err)
+			goto out;
+
 		err = ntfs_sb_write_run(sbi, &ea_run, 0, ea_all, size, 0);
 		if (err)
 			goto out;
-- 
2.35.1

