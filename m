Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9584DA329
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 20:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242427AbiCOTRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 15:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiCOTRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 15:17:30 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F97F31
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:16:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h2so513274pfh.6
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VTb5ul+n4WT1sbDMlrbhLBcR/t69JrkdnmjdEtDHndE=;
        b=gvQ9DlFYZSeKRGsPsrdJv82oAwqEruk9QS7vTAC6OKVJDyy8C1B/9E4dLMuljRdJVa
         4BJkYvXrexW4Am2uV3t90FeD3+fXsA0orYHAD/A9bL6yK7N2JwPl7of52zjOfnme1A4s
         Y3MQ1DAG27vvHYJh/szmyrCBXRtimwCPxG51KD8ADalMLMo1UTaNB9jeRyflX9YsTWRD
         YjSYjVnpKgblC2S0Fj0SIAUOmGjRLXWHGmKyTzG5vGPjiTJ9rIzU5yHb743O7oiUfB1B
         OVPBrvlKWtYlJEubRsGF0McbDRADTEu70XtDVfpH55Zg/Vg8hX6ah1JvKzzGYBGG2AGq
         yeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTb5ul+n4WT1sbDMlrbhLBcR/t69JrkdnmjdEtDHndE=;
        b=eSityLhPQWQBJ7PDyLFkRShXuH3ef9+d1g6Tnq0IZsxh1iZcv/mumDmWdRKB8EuZJ5
         jGUsdX51HW7pr6xebMfM28/M3wQwkgEk9rR7Vmf1SfniK9B2MzpUK4mZz8shAUcVoajl
         n0un6oNA+YboodGJg5mT1QQaryRAZZDVbTJr2yeQi/GiHmIFzeixx9N5ovl21ti5I5c4
         PIU1Os3+SrgeaPeVHhCsBlF50mABbru05Y9qrEDQ7KnJJfAREWMPYTejXfFeHPGX850B
         52zb1gsjorOSD+nhXtULkuNBfdqQjzuUoRqjtDOCJe34dLhhCIsafN6V51Siv+cpA5+H
         gBNw==
X-Gm-Message-State: AOAM531GGpSGqBFFj1whreVjm3OAT1e3bdbgftsRnE2/ZzF7DNa7F/mU
        W7P1MVk329NoY8bLcBbThi5NyQ==
X-Google-Smtp-Source: ABdhPJwnJnRXAHrQV+u5y2rkB0kmtCrYFBeyMiZMqPSrhBWuw59JeBaV01MG2y2G7Ig/Bz5uRxNbmA==
X-Received: by 2002:a05:6a00:1c73:b0:4f7:83a7:25d8 with SMTP id s51-20020a056a001c7300b004f783a725d8mr26389413pfw.85.1647371777985;
        Tue, 15 Mar 2022 12:16:17 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm25975573pfv.22.2022.03.15.12.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 12:16:17 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: [PATCH] ext4: check if offset+length is within a valid range in fallocate
Date:   Tue, 15 Mar 2022 12:15:45 -0700
Message-Id: <20220315191545.187366-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <d153bb2e-5f95-47d0-43db-b95c577e2b91@linaro.org>
References: <d153bb2e-5f95-47d0-43db-b95c577e2b91@linaro.org>
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
According to the comment doc in ext4_ind_remove_space() the 'end'
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
---
 fs/ext4/inode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 01c9e4f743ba..dd9c35113efe 100644
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
+	max_length = sbi->s_bitmap_maxbytes - sbi->s_blocksize;
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

