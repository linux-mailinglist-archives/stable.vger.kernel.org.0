Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9234EE250
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 22:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241208AbiCaUH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 16:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiCaUH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 16:07:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4D71905AB
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 13:05:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id jx9so434934pjb.5
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 13:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p9t6Pq/1FxCVVbqJtOJthgB43FJ45dwItTm1qqJ1hpI=;
        b=k+DZFzBF4OXV/isOqu1fX+iYt/dbsfQpHxFsvVwXaosR6G0JGbByOJaOHyc5vCKVQr
         ltQm1edsWc4pHVXEoUwjDXuAleaSO3swIpZWeZ9/kFXxLJd9Slgm5PN1ON71WDsudY5I
         zT0QBDf0T6vMRkOCin7JC9IAXWiGIMksc68srEOT0k4+GxMULM4NpDia06MvLmpeZsCK
         R8d+M/t8ojbNFDdL0jJ9RYldFJ0LRimtfwfvC0KEQUlAvFn8nJ3S+NenOxBg4YxJC7vh
         mF7fOrFNOoEumhyEiaOoQ7q1yOj4Rx/ltc57kDtrRkfd6BpGEEGMCSJoUvpIGcN2QQml
         5TnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p9t6Pq/1FxCVVbqJtOJthgB43FJ45dwItTm1qqJ1hpI=;
        b=g9j/1ASlKv6+CMxhHoLpqv+6ZcKmXT8MstFr6kWZlklWnhasKBY8TNihnZvV+9Xb57
         gl3j2Fm1v5WU0CtXAyLIxrKpQOMM9S8IcbBtks8sMqTyxyLgGwyskQ9Jvo1Dy9qz7NQX
         XK53pJwEk08ay24gPcZxYYTbPIKwunf7hVIJLq4hbGlJDw9YVhJHmsPxFGwucQKl651/
         A2OAYniFdTji8h1rKG1GGLR4QrI2lkyBGG1KquVYFb6lOWp5P1g22Q6piR/vHQPLwQlG
         yfo7/6icAJHpMfiG8HpZtq0MIanVamxQfWy/TGa8EENJJVKZo5+1ngtoAo5m2vp3mYi5
         8Jgw==
X-Gm-Message-State: AOAM530GV6pXYo7iOMcuBq3Ho6pd0U8IFBdM+K9mgxrMIGUZ1PTX1SPB
        qsod4QYZdEtlbjjAFvfGN/Y/kw==
X-Google-Smtp-Source: ABdhPJx+odBnk0xoMo0XR3TevKAR/mX56Y1ppZhg4q4Gj2inIRQlWGCUsTvVGClo1qK2sdWjNiDnuQ==
X-Received: by 2002:a17:90a:488c:b0:1c7:b62e:8e8c with SMTP id b12-20020a17090a488c00b001c7b62e8e8cmr7869098pjh.157.1648757140327;
        Thu, 31 Mar 2022 13:05:40 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id v24-20020a634818000000b0036407db4728sm179053pga.26.2022.03.31.13.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 13:05:39 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     linux-ext4@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: [PATCH v3] ext4: limit length to bitmap_maxbytes - blocksize in punch_hole
Date:   Thu, 31 Mar 2022 13:05:15 -0700
Message-Id: <20220331200515.153214-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
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

Syzbot found an issue [1] in ext4_fallocate().
The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
and offset 0x1000000ul, which, when added together exceed the
bitmap_maxbytes for the inode. This triggers a BUG in
ext4_ind_remove_space(). According to the comments in this function
the 'end' parameter needs to be one block after the last block to be
removed. In the case when the BUG is triggered it points to the last
block. Modify the ext4_punch_hole() function and add constraint that
caps the length to satisfy the one before laster block requirement.

LINK: [1] https://syzkaller.appspot.com/bug?id=b80bd9cf348aac724a4f4dff251800106d721331
LINK: [2] https://syzkaller.appspot.com/text?tag=ReproC&x=14ba0238700000

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Fixes: a4bb6b64e39a ("ext4: enable "punch hole" functionality")
Reported-by: syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
--
v3: Modify the length instead of returning an error.
v2: Change sbi->s_blocksize to inode->i_sb->s_blocksize in maxlength
 computation.
---
 fs/ext4/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ce13f69fbec..60bf31765d07 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3958,7 +3958,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset;
+	loff_t first_block_offset, last_block_offset, max_length;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0, ret2 = 0;
@@ -4001,6 +4002,14 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		   offset;
 	}
 
+	/*
+	 * For punch hole the length + offset needs to be within one block
+	 * before last range. Adjust the length if it goes beyond that limit.
+	 */
+	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
+	if (offset + length > max_length)
+		length = max_length - offset;
+
 	if (offset & (sb->s_blocksize - 1) ||
 	    (offset + length) & (sb->s_blocksize - 1)) {
 		/*
-- 
2.35.1

