Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8DC539490
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiEaP5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 11:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345979AbiEaP5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 11:57:12 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9FD7A80B
        for <stable@vger.kernel.org>; Tue, 31 May 2022 08:56:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e11so2109534pfj.5
        for <stable@vger.kernel.org>; Tue, 31 May 2022 08:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ut0kTJB8jFm6gv4A9ig72S34WS8IPzTidh9YVWwEiS8=;
        b=m2x00DcvozUXS5IX50RXFZKSR5JFj4Zn1o+LxFArZe+sDl9UrTLhMeOhNlY6UomxoG
         /bPMkrq+U14Et03V7LKOwtV+Vl00ok2yMZp6iCUCh/f2Gwb2OXQEALsQit4UBi4a7upS
         geCIlSXG2VXvyzaQ2bb4qIcMhAzqMhuLaEE9KTE0TrylQmHbA5puY8y8B++BZSyHQiB5
         qqH1hEpJwjXboeGYg6Mc2bsFn/yqz/QOgbQEx1nJWXdyScH88KGhM0SZiMTACikRj34F
         uePRvH59b1/mSFckp+tpTMWhFQ5/D8VMif1LoVgx1dWM76sVEGWrXO0AWeKWaB1LPVl+
         9MQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ut0kTJB8jFm6gv4A9ig72S34WS8IPzTidh9YVWwEiS8=;
        b=GAAaN4Z4dm4AB4XeKuxJjntGosxA+SjDDHiQHmcV4wXPv5+vZNOkD9zl5yl3hT+jtn
         W6S6j7ODFveB0RRL7NKBkw+qhkeAY2NcF/gp88h6eHiBsi7ffHNSaddBIfanDM3Fy5oV
         mF78pXMdYXCVidZTfE9nCuqTZ/RTBanGmzqwpJQMlFOW48n9YGd0yEDzQt9/sIGkDLfn
         8NULU2YWOwdVyk9mW35bY2ps5dBGIThopcrJSFlpoxAoNchybA6UpoQqKLHJ/v0xGa1j
         1qM5p6+lbvwabPalxBpAPcnK52hayJCLoEt5AWXlTUUnA03m3GU8CusZV5+0cbUBqLyp
         W2VQ==
X-Gm-Message-State: AOAM533OZroUhscXeLX5BN1mT9GYOJ1wFXq5bNWX0KolEsZ2E90KRn++
        0A4F5jGDjNQvpn0HW51akUcgcRGIihP8ug==
X-Google-Smtp-Source: ABdhPJxtl9gR0kHCZ2ksw1iKHAsdHc30hPxh8JH++XeHVk4et8ZY3FRLfngTU0IpHohCSHcTPx9s2A==
X-Received: by 2002:a63:5143:0:b0:3fa:218d:db2 with SMTP id r3-20020a635143000000b003fa218d0db2mr40227106pgl.354.1654012617844;
        Tue, 31 May 2022 08:56:57 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id ca7-20020a17090af30700b001e292e30129sm2141892pjb.22.2022.05.31.08.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:56:57 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v5.10] exfat: check if cluster num is valid
Date:   Tue, 31 May 2022 08:56:47 -0700
Message-Id: <20220531155647.8933-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <b6ca08bb-2275-ab66-1a78-d4ac9e87057c@linaro.org>
References: <b6ca08bb-2275-ab66-1a78-d4ac9e87057c@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: 64ba4b15e5c0 ("exfat: check if cluster num is valid")

Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
This was triggered by reproducer calling truncute with size 0,
which causes the following trace:

BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
Read of size 8 at addr ffff888115aa9508 by task syz-executor251/365

Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack_lvl+0x1e2/0x24b lib/dump_stack.c:118
 print_address_description+0x81/0x3c0 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
 exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
 exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
 __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
 exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
 exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
 notify_change+0xb76/0xe10 fs/attr.c:336
 do_truncate+0x1ea/0x2d0 fs/open.c:65

Move the is_valid_cluster() helper from fatent.c to a common
header to make it reusable in other *.c files. And add is_valid_cluster()
to validate if cluster number is within valid range in exfat_clear_bitmap()
and exfat_set_bitmap().

Link: https://syzkaller.appspot.com/bug?id=50381fc73821ecae743b8cf24b4c9a04776f767c
Reported-by: syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/exfat/balloc.c   | 8 ++++++--
 fs/exfat/exfat_fs.h | 8 ++++++++
 fs/exfat/fatent.c   | 8 --------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 579c10f57c2b..258b6bb5762a 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -148,7 +148,9 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu)
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return -EINVAL;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
@@ -166,7 +168,9 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_mount_options *opts = &sbi->options;
 
-	WARN_ON(clu < EXFAT_FIRST_CLUSTER);
+	if (!is_valid_cluster(sbi, clu))
+		return;
+
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index b8f0e829ecbd..0d139c7d150d 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -380,6 +380,14 @@ static inline int exfat_sector_to_cluster(struct exfat_sb_info *sbi,
 		EXFAT_RESERVED_CLUSTERS;
 }
 
+static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	if (clus < EXFAT_FIRST_CLUSTER || sbi->num_clusters <= clus)
+		return false;
+	return true;
+}
+
 /* super.c */
 int exfat_set_volume_dirty(struct super_block *sb);
 int exfat_clear_volume_dirty(struct super_block *sb);
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index c3c9afee7418..a1481e47a761 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -81,14 +81,6 @@ int exfat_ent_set(struct super_block *sb, unsigned int loc,
 	return 0;
 }
 
-static inline bool is_valid_cluster(struct exfat_sb_info *sbi,
-		unsigned int clus)
-{
-	if (clus < EXFAT_FIRST_CLUSTER || sbi->num_clusters <= clus)
-		return false;
-	return true;
-}
-
 int exfat_ent_get(struct super_block *sb, unsigned int loc,
 		unsigned int *content)
 {
-- 
2.36.1

