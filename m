Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2B5FEBF1
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 11:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJNJmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 05:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJNJmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 05:42:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA15C1C5A67
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 02:42:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y191so4441988pfb.2
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 02:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDkttj8KThuD6AIuOhW1sGd5rdkY521Wot2HMKh1FLk=;
        b=HPfKxoBtF70D/ozPLaTRMMKHxqNh2OU95b/t4viGJxemVYJUMk4APXnPuHfjydgxC1
         3Ulc3RHMu52DMmngbS0JRJlc8SA+dAQgiuLKyq+JSAc8kn1MJwHjaB4tqZ2iJkmV0kFk
         OIHos+eBpvPg5nE4K4nvxF8/QEPG4QdI6yK9gl31BuNjrJOOqdRI4hNAVaXvRvU9ltNw
         1Tjd2nckAlLZq28+xhwJP3hzAYoDv/U+zCAksFQbnOcT5tMMDnVirAU8yOp8TGnfzVfP
         exzQxE+JQLsrBy1YeerL/wFVhXEYVLh3ItEvp0WJlr84Kx/BeplTjWoN8n5j2Zj4Dem4
         3JrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zDkttj8KThuD6AIuOhW1sGd5rdkY521Wot2HMKh1FLk=;
        b=KMwXqcw9ebq+Z9+khYBm1lvnbBNU8uCKuYGqzBqQiKFNrft7LeD7F1dMP7mqJ4E6sQ
         pspI+ZzkhicXuhzpH93pVqF/tXz8vQLHHxX7theAJSs24VnEPTdbvEAuH2hhf+6HH6EV
         5r5dpqWXn8TBR0t07DKr6s8vdxkEBaJfbVI3jFVf92UZDwj+Lf5HBJW+x813Pxt50Nph
         Zel0W1QR/gxARYQWiZG3znnnsAwRhF6OZsDLwqGh+MfRq3h6T1ska6W+4POXG0D9lQEI
         llyi6X7xdbxx+V0++Ywo/6qVTZgb3IjPs5v5mG/71+feDynVFB9t6aGIWPupjlc+exBd
         Tqgg==
X-Gm-Message-State: ACrzQf0HUE/McAqWZrHgHcEUfkGtWYXMRDBFKnoyRq98k0byIx6SJNgA
        GwLEvVcQUMIHFzpz9bw49QH2lnBG5Tc=
X-Google-Smtp-Source: AMsMyM7ghvC9fgy2ZALltUNCWnrJfmF9TtjcKQbXm/LHDS5iVeDWYJKlyxZxOHYa8ROh9MmLvR+oJg==
X-Received: by 2002:a63:e218:0:b0:448:5163:478f with SMTP id q24-20020a63e218000000b004485163478fmr3834730pgh.415.1665740554623;
        Fri, 14 Oct 2022 02:42:34 -0700 (PDT)
Received: from carrot.. (i58-94-204-181.s42.a014.ap.plala.or.jp. [58.94.204.181])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b0017534ffd491sm1285482plk.163.2022.10.14.02.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 02:42:33 -0700 (PDT)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        khalid.masum.92@gmail.com
Subject: [PATCH 5.4 4.19 4.14 4.9] nilfs2: fix use-after-free bug of struct nilfs_root
Date:   Fri, 14 Oct 2022 18:42:30 +0900
Message-Id: <20221014094230.21565-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1665607021158151@kroah.com>
References: <1665607021158151@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d325dc6eb763c10f591c239550b8c7e5466a5d09 upstream.

If the beginning of the inode bitmap area is corrupted on disk, an inode
with the same inode number as the root inode can be allocated and fail
soon after.  In this case, the subsequent call to nilfs_clear_inode() on
that bogus root inode will wrongly decrement the reference counter of
struct nilfs_root, and this will erroneously free struct nilfs_root,
causing kernel oopses.

This fixes the problem by changing nilfs_new_inode() to skip reserved
inode numbers while repairing the inode bitmap.

[ ryusuke: tweaked to use nilfs_msg macro instead of nilfs_warn and
  nilfs_info, which are not present in v5.8 and earlier. ]

Link: https://lkml.kernel.org/r/20221003150519.39789-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b8c672b0e22615c80fe0@syzkaller.appspotmail.com
Reported-by: Khalid Masum <khalid.masum.92@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Please apply this patch to the above stable trees instead of the patch
that could not be applied to them last time.  This tweaked patch is
applicable to v4.8~v5.8 and tested with the stable trees.

fs/nilfs2/inode.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index b8ebfb16c8ec..cf01aa55dd44 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -340,6 +340,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -355,11 +356,26 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_msg(sb, KERN_WARNING,
+			  "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_msg(sb, KERN_INFO,
+			  "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = ino;
-- 
2.31.1

