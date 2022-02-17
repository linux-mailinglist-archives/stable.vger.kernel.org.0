Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4024BACF7
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 23:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiBQW7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 17:59:43 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBQW7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 17:59:42 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B34280EC0
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b8so6991665pjb.4
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 14:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/DVMObMjmD6wXFomexqplB2m04bAd/hK8+CVdJFqa7k=;
        b=BWdF/aWMLu21RtyHY+81QCGyGZlk6J+3oXLeCjrSaABhTtFrV9/9bpP4zyVJb7wHfP
         h5bdk9Kp4VwyMl2xwHW4ikMKUAy3VNlXlL/xGhngriubvRT7ZGKNX0X7hd+EXyOaAUME
         Iy8RfL5S8cJ4PPGbMJqmRomEHIxLqU71r9TUNqd0u+CHbZF6DVMZA5cGqWNdVFCLh2mG
         s/buTmXehq39JHJwjJwp15xps9syJ56VSZXOuLfmwZ8cAIUSlA+a4Bu5g7iCuQX3KLSg
         zU01pPA46J4+XgGFRPfScF6yRayD5re3Nfjv4r3ClnzWvlgZaEZWaujun/LVP0zUMOuz
         5boQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/DVMObMjmD6wXFomexqplB2m04bAd/hK8+CVdJFqa7k=;
        b=i8nXpMce+Z52Sa9mMSd8e7hxk+ha6sshSgSTKILc2sk3CRPH1hsBYU5uvr3Gg8C34P
         4TyESwOag0egPHCs6/JgMjFa77w57Fis0L7ZvDIZ/o+MjCJT85znzRMXp2dCln3hLPiG
         1GcNj7Izxfq0m8MVfJqqGJbnifY+5xtITs30YE/m7AYXb48fjoM9eYPLa8ULSHb0lRme
         faZxe99mcA83Ngo04yaroUK5o7aT8lNLesALxYeGsH7SLTkRokujmK28WGMPAuS65B5W
         d3DBFFeRsuRQrGyYLyNmGAVD6NT/eRbLOEP96fy2dG+1PiGdCMink0rAuCPzbrD+meLV
         P+DA==
X-Gm-Message-State: AOAM530LwNnLwzaUiXV36IObgkIkel6V9b6Vfz8b3FMlLGxhPY2m/j08
        XAiSrk7KSxyRDAxqB4pVg1yduA4ClB81yg==
X-Google-Smtp-Source: ABdhPJwQpreEA1THSjFQAId8DKq8R6uBBawM1kiUQB/Iy0jyq2kmTHI3dLFBFhgoIyzKCSE0fLc46Q==
X-Received: by 2002:a17:90a:1789:b0:1b9:1154:65ee with SMTP id q9-20020a17090a178900b001b9115465eemr5376086pja.115.1645138765910;
        Thu, 17 Feb 2022 14:59:25 -0800 (PST)
Received: from lrumancik-glaptop2.roam.corp.google.com ([2601:647:4701:18d0:9e69:6ca2:e1cf:4ed2])
        by smtp.gmail.com with ESMTPSA id b16sm593260pfv.192.2022.02.17.14.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 14:59:25 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH for 5.4 1/3] ext4: check for out-of-order index extents in ext4_valid_extent_entries()
Date:   Thu, 17 Feb 2022 14:59:12 -0800
Message-Id: <20220217225914.40363-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 8dd27fecede55e8a4e67eef2878040ecad0f0d33 upstream.

After commit 5946d089379a ("ext4: check for overlapping extents in
ext4_valid_extent_entries()"), we can check out the overlapping extent
entry in leaf extent blocks. But the out-of-order extent entry in index
extent blocks could also trigger bad things if the filesystem is
inconsistent. So this patch add a check to figure out the out-of-order
index extents and return error.

[Added pblk argument to ext4_valid_extent_entries because pblk is
updated in the case of overlapping extents. This argument was added
in commit 54d3adbc29f0c7c53890da1683e629cd220d7201.]

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/ext4/extents.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae73e6793683..4f8736b7e497 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -390,9 +390,12 @@ static int ext4_valid_extent_idx(struct inode *inode,
 
 static int ext4_valid_extent_entries(struct inode *inode,
 				struct ext4_extent_header *eh,
-				int depth)
+				ext4_fsblk_t *pblk, int depth)
 {
 	unsigned short entries;
+	ext4_lblk_t lblock = 0;
+	ext4_lblk_t prev = 0;
+
 	if (eh->eh_entries == 0)
 		return 1;
 
@@ -403,32 +406,36 @@ static int ext4_valid_extent_entries(struct inode *inode,
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
 		struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 		ext4_fsblk_t pblock = 0;
-		ext4_lblk_t lblock = 0;
-		ext4_lblk_t prev = 0;
-		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			len = ext4_ext_get_actual_len(ext);
 			if ((lblock <= prev) && prev) {
 				pblock = ext4_ext_pblock(ext);
 				es->s_last_error_block = cpu_to_le64(pblock);
 				return 0;
 			}
+			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
 			ext++;
 			entries--;
-			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
+
+			/* Check for overlapping index extents */
+			lblock = le32_to_cpu(ext_idx->ei_block);
+			if ((lblock <= prev) && prev) {
+				*pblk = ext4_idx_pblock(ext_idx);
+				return 0;
+			}
 			ext_idx++;
 			entries--;
+			prev = lblock;
 		}
 	}
 	return 1;
@@ -462,7 +469,7 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
-	if (!ext4_valid_extent_entries(inode, eh, depth)) {
+	if (!ext4_valid_extent_entries(inode, eh, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
-- 
2.35.1.473.g83b2b277ed-goog

