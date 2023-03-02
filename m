Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653606A8559
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCBPgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 10:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCBPga (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 10:36:30 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094D237559
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 07:36:29 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id r27so22624196lfe.10
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 07:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677771387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tU1uRAhzsVoBdXD+RtSgjM2zLnzd5LFyExq7JwMSefY=;
        b=QkQLjOi8GvNhoAnYX+Jj2O5035sBaO3DVCqKuI/pUDUkZDES2L5FtLuLMh63HkVxYj
         NRKMWgDUQev3birx1DTgJU6DwmBeWl5eyayh6RyPZg8xsATSQeb4W8WT4WPSMFEb0kQM
         U5a4eC0ESRI7ep0FMYTBjb5gPus4COkoUh55yeysdynHfyXkO88XDa+PKUdipr9XneI4
         scqMRSTfUD++K/CWy23E58hyegWlTDXm6I0yXr7cv9FeNaalKE4RlCZTpUfyWxYELWql
         A6FhaLyZYrfz2m/5clI4iUqtdDITEU23VX4aNZ1xA/j/a+x2UOJLFObjk7np3Tt8A+Ap
         jnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677771387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tU1uRAhzsVoBdXD+RtSgjM2zLnzd5LFyExq7JwMSefY=;
        b=0qZvx1Dhcy/wg9HZSTNOsafGCFL2gxfWbPk1emoL8JfIc8ZG3slHSY+O3FuMyvJGDj
         4oNCkw1GOK8xzLPlu/XDkT69rPl2UptLbHHN7rf7RR8VzypyigL9NuXgCxF/gsp9sYk8
         iSEN6FrjWnxWHWXNfyaxq6LrTVfINjAnzVgBR3ZVGCx0InOPv+y+fD8V7+okHmhF6X7C
         nozoxHL8rGCxRNlseMtkW8+e9ZW0W/dF8moWc6UzhXR6hzXVdTeMFG71Pv+nz1iJKpU5
         HBKK7gzOv97Zt12fPj0EjR3DmGiYhDr7kRtxreEjrzTtLnSVXvgbyeXcdFiFJeAByVSW
         +mOg==
X-Gm-Message-State: AO0yUKW/AIQmZH2U3OBuFenq7d1SoTmJiBwGAFivx0IBbTKWZpDjMZlW
        gXurz8BJYjO6JDwHN+mGy76Ld4kXxLBD7MNn
X-Google-Smtp-Source: AK7set8sJTLO9CCSsJJRosOnAY+i38CiUycGIL2zq/K7T87fr0OtVM/49TCqf1Lz0ZaxySlQA4biaA==
X-Received: by 2002:ac2:46f6:0:b0:4dd:cbf3:e981 with SMTP id q22-20020ac246f6000000b004ddcbf3e981mr2764196lfo.28.1677771387030;
        Thu, 02 Mar 2023 07:36:27 -0800 (PST)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id p17-20020a05651238d100b004db2978e330sm2170509lft.258.2023.03.02.07.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:36:26 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable 5.{15, 10} 3/4] ext4: add strict range checks while freeing blocks
Date:   Thu,  2 Mar 2023 15:36:09 +0000
Message-Id: <20230302153610.1204653-4-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
References: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit a00b482b82fb098956a5bed22bd7873e56f152f1 ]

Currently ext4_mb_clear_bb() & ext4_group_add_blocks() only checks
whether the given block ranges (which is to be freed) belongs to any FS
metadata blocks or not, of the block's respective block group.
But to detect any FS error early, it is better to add more strict
checkings in those functions which checks whether the given blocks
belongs to any critical FS metadata or not within system-zone.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/ddd9143d064774e32d6364a99667817c6e8bfdc0.1644992610.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/mballoc.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4418d011a654..7b4359862a60 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5946,13 +5946,7 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, gdp), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, gdp), block, count) ||
-	    in_range(block, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, gdp),
-		     sbi->s_itb_per_group)) {
-
+	if (!ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -6023,7 +6017,7 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 						 NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
-					 " group:%d block:%d count:%lu failed"
+					 " group:%u block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
 		} else
@@ -6236,11 +6230,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 		goto error_return;
 	}
 
-	if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
-	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
-	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
-	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group)) {
+	if (!ext4_sb_block_valid(sb, NULL, block, count)) {
 		ext4_error(sb, "Adding blocks in system zones - "
 			   "Block = %llu, count = %lu",
 			   block, count);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

