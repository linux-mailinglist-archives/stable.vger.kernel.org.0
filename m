Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CCA6BF965
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCRKQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCRKP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:57 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5353CE1E;
        Sat, 18 Mar 2023 03:15:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso4731490wmo.0;
        Sat, 18 Mar 2023 03:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iF1mN6zvABPJFTbU5QEGrkBoU8KKs2uGJMLFx2CtOkE=;
        b=heAivPpDbsDpsG3pYYLVPIP3jNFjWdOgWWUPJGZTaugqG3XvhxV1H2RO4iZR9y7EOD
         gdqnFcUC0qluSkvfNP1oGY7GkFEKAxrhDzidFZENmq48zQ2rY5lC8ZwhuOk2E03RwYKp
         ADPOB9ZBqpZmAvXLMjomfb1Hs5ut+Oxnx4j10BOO/CgAzBz42sOvhBUrt+DMfvmfkUiK
         d7nRR8rxFeoj7fmobR/uxgdctnW9ZAVetAubOKuWCRfQcHDBAIaKBTrk89iE+bdjibtg
         YVrcO+TuzabSgk+yU/q9+pu1KyscLa5CQE9yvNUbR07FFa2hFO+BqvBg2v6ay/zJyRWO
         maxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iF1mN6zvABPJFTbU5QEGrkBoU8KKs2uGJMLFx2CtOkE=;
        b=NB0ubepkuHDXKgJxkwi2y31obZ8aCBpJIM4RSrgyXtej/NWwcILjRI01Ku/iCFg0JT
         WeGHVbmfWlAkq4nwjOf9KOD6Uz9n1sYc3oFaQIeW4QWu+d0wUGa1Dps88lNTdfRNOF7z
         6iCa5JBU7s5UC6U2N3RNMk0RG3Dpfx6CA1kHnLxAEgiPWddRw1cgRRO7x2qOKpjBFQKR
         1eTYlalBoRlDPMTT5dPVJz7TEX1Cfw9NuFaw0MebrR3qDrpqLemNklJxn+dRSP2UoBdG
         RL6Qh3z/V3gd4/tGiyQ5pKe6mXBcTu6i2AbTonsJ7ion+2q/uVU1v7sjlt/Hiv65V1Wc
         r4oA==
X-Gm-Message-State: AO0yUKVh2ahNhc6XFEFqY1pH4aq3HoQcG6VY+Es1b8HOGGrHpL733Q8D
        4y7HnphDkSt6Z8bHf/o8c7s=
X-Google-Smtp-Source: AK7set/L2wQAz3z1r+j/ukF8WJ3qi+NCSFrwZhS1ouaaZJTRQieKNOFbI0mH/A6XJ+4NWCAzPYbf/A==
X-Received: by 2002:a05:600c:28c:b0:3ed:5d41:f964 with SMTP id 12-20020a05600c028c00b003ed5d41f964mr4159853wmk.1.1679134548955;
        Sat, 18 Mar 2023 03:15:48 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Yang Xu <xuyang2018.jy@fujitsu.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.10 08/15] fs: add mode_strip_sgid() helper
Date:   Sat, 18 Mar 2023 12:15:22 +0200
Message-Id: <20230318101529.1361673-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
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

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 2b3416ceff5e6bd4922f6d1c61fb68113dd82302 upstream.

[remove userns argument of helper for 5.10.y backport]

Add a dedicated helper to handle the setgid bit when creating a new file
in a setgid directory. This is a preparatory patch for moving setgid
stripping into the vfs. The patch contains no functional changes.

Currently the setgid stripping logic is open-coded directly in
inode_init_owner() and the individual filesystems are responsible for
handling setgid inheritance. Since this has proven to be brittle as
evidenced by old issues we uncovered over the last months (see [1] to
[3] below) we will try to move this logic into the vfs.

Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [1]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [2]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [3]
Link: https://lore.kernel.org/r/1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 34 ++++++++++++++++++++++++++++++----
 include/linux/fs.h |  1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9f49e0bdc2f7..23d03abcb0ff 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2147,10 +2147,8 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(inode->i_gid) &&
-			 !capable_wrt_inode_uidgid(dir, CAP_FSETID))
-			mode &= ~S_ISGID;
+		else
+			mode = mode_strip_sgid(dir, mode);
 	} else
 		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
@@ -2382,3 +2380,31 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_p(dir->i_gid))
+		return mode;
+	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
+		return mode;
+
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 74e19bccbf73..527791e4860b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1768,6 +1768,7 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 extern void inode_init_owner(struct inode *inode, const struct inode *dir,
 			umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
-- 
2.34.1

