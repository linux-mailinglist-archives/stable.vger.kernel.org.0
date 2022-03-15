Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A874DA4EF
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 22:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiCOV4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 17:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiCOV4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 17:56:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79185C34D
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 14:55:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d19so1068396pfv.7
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 14:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXiGTEuakDi6scceVyLYH4uzypVcynDgxtyK6s5vtKA=;
        b=DLhQQ6kz7m8e1jlTZl8iiSJ7LPZV44T0yCSSWzrH1yGRBUQ2hs7Jl3Qld9pgyhk6wz
         arsPox3wYcniQcIHbh87PROF+EnB+2e3J/1nx5nJXRaBrguCpWi0zM0ksO0f4xyEcGtz
         0fcfHyCBxBiwKVQlTC5rVAU0XDoe8QXExtZggSb72VWjtJ4q+PtYwnbx/MFIenXVkRK5
         XnaMJBqOfbFg/4Q4q86H4VWmCDrq64S9uPeiIKrRsBNskqcJNQjTRl2G/oyuwnuMHpUd
         2H94h2xFpXG+eQXcISlxQVErgnL1WAUnNYtfO5i4RMR2kzaP9F2hWWITqxzWUkK2XNDW
         e1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXiGTEuakDi6scceVyLYH4uzypVcynDgxtyK6s5vtKA=;
        b=vdrOuIPqa/AiTGr/R4Xgqa/h3mNI3RDp3k1dL2yrS165h13uWLKn2gZEvzRKkhp36t
         orSEYtyXqJbbFhuG2pjGVGb05Ggx0QbpDnAHHEMnAiDvHWZbDF0DUJWEGj3+aRYBc7gy
         by9bbsJEqzHyOusqULf3C4ki/GyFFs2D9SNiZOHLyidGhMCOIDbpbBEfoii/3OyNUXXb
         QQdzDuDtlWx3wYxBqHsQdG6BjmfsYZ0fRlDNOAmHiv0MUynp36R3Pjcm9zidH1jRrAjs
         Ow9bv+Jb/lPUhQwDWu6WUgDrs+VNdzXkzxPldMZuulpeG4VOjT7Tz1jh8slZIsNpOAnQ
         vCnA==
X-Gm-Message-State: AOAM53210/0d+P5k4xZTlF3zbBnbA9+5B5Qyoe3OGASdyhbNxPNsrDRp
        mSi630uDnM9fAJjMUbWPX9X83Q==
X-Google-Smtp-Source: ABdhPJwro/vpzubWkVZcJnMDYIdf7YnWMqIo5RLALOtqUrccJBPKoDhHL61E3KesdUUsn9sTC4Htcw==
X-Received: by 2002:a05:6a00:a23:b0:4f6:72a8:20c7 with SMTP id p35-20020a056a000a2300b004f672a820c7mr30540640pfh.12.1647381335253;
        Tue, 15 Mar 2022 14:55:35 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b0038108d69e8fsm187880pgd.53.2022.03.15.14.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 14:55:34 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     tytso@mit.edu
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: check if offset+length is valid in fallocate
Date:   Tue, 15 Mar 2022 14:54:39 -0700
Message-Id: <20220315215439.269122-1-tadeusz.struk@linaro.org>
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
and offset 0x1000000ul, which, when added together exceed the disk size,
and trigger a BUG in ext4_ind_remove_space() [3].
According to the comment doc in ext4_ind_remove_space() the 'end' block
parameter needs to be one block after the last block to remove.
In the case when the BUG is triggered it points to the last block on
a 4GB virtual disk image. This is calculated in
ext4_ind_remove_space() in [4].
This patch adds a check that ensure the length + offest to be
within the valid range and returns -ENOSPC error code in case
it is invalid.

LINK: [1] https://syzkaller.appspot.com/bug?id=b80bd9cf348aac724a4f4dff251800106d721331
LINK: [2] https://syzkaller.appspot.com/text?tag=ReproC&x=14ba0238700000
LINK: [3] https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/ext4/indirect.c#L1244
LINK: [4] https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/ext4/indirect.c#L1234

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
v2: Change sbi->s_blocksize to inode->i_sb->s_blocksize in maxlength
 computation.
---
 fs/ext4/inode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 01c9e4f743ba..355384007d11 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3924,7 +3924,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset;
+	loff_t first_block_offset, last_block_offset, max_length;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0, ret2 = 0;
@@ -3967,6 +3968,16 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		   offset;
 	}
 
+	/*
+	 * For punch hole the length + offset needs to be at least within
+	 * one block before last
+	 */
+	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
+	if (offset + length >= max_length) {
+		ret = -ENOSPC;
+		goto out_mutex;
+	}
+
 	if (offset & (sb->s_blocksize - 1) ||
 	    (offset + length) & (sb->s_blocksize - 1)) {
 		/*
-- 
2.35.1

