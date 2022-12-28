Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59DE657883
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiL1OwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiL1Ovf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:51:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C161209A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6335B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4DBC433EF;
        Wed, 28 Dec 2022 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239069;
        bh=fs/+NnU3y/vBVrhVY/q5FlpIYZsnZQa9v9NKlB9YuM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNoKcqt6fFtFcNOxkjpzd7F368Us4kZ+7cWxO3aPg9/h9JO5DZfgFNuhthKLTQO7J
         DDafZZc2hg3E+NfptZpJ/gD/6vmsmKXPFBwUu1DxbWBFTnzAeGPlBVZH010keEowzt
         M2oxKAYv6FPQA+HwJHc2McAhcqgTvqoZhh+1TnKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akinobu Mita <akinobu.mita@gmail.com>,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Oscar Salvador <osalvador@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/731] debugfs: fix error when writing negative value to atomic_t debugfs file
Date:   Wed, 28 Dec 2022 15:33:36 +0100
Message-Id: <20221228144259.708454419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit d472cf797c4e268613dbce5ec9b95d0bcae19ecb ]

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), so we have to use a 64-bit value to write a
negative value for a debugfs file created by debugfs_create_atomic_t().

This restores the previous behaviour by introducing
DEFINE_DEBUGFS_ATTRIBUTE_SIGNED for a signed value.

Link: https://lkml.kernel.org/r/20220919172418.45257-4-akinobu.mita@gmail.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../fault-injection/fault-injection.rst       | 10 +++----
 fs/debugfs/file.c                             | 28 +++++++++++++++----
 include/linux/debugfs.h                       | 19 +++++++++++--
 3 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 4a25c5eb6f07..8c47847755a6 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -83,9 +83,7 @@ configuration of fault-injection capabilities.
 - /sys/kernel/debug/fail*/times:
 
 	specifies how many times failures may happen at most. A value of -1
-	means "no limit". Note, though, that this file only accepts unsigned
-	values. So, if you want to specify -1, you better use 'printf' instead
-	of 'echo', e.g.: $ printf %#x -1 > times
+	means "no limit".
 
 - /sys/kernel/debug/fail*/space:
 
@@ -277,7 +275,7 @@ Application Examples
     echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -331,7 +329,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo 1 > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -362,7 +360,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 100 > /sys/kernel/debug/$FAILTYPE/probability
     echo 0 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 1 > /sys/kernel/debug/$FAILTYPE/verbose
 
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 950c63fa4d0b..38930d9b0bb7 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -378,8 +378,8 @@ ssize_t debugfs_attr_read(struct file *file, char __user *buf,
 }
 EXPORT_SYMBOL_GPL(debugfs_attr_read);
 
-ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
-			 size_t len, loff_t *ppos)
+static ssize_t debugfs_attr_write_xsigned(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos, bool is_signed)
 {
 	struct dentry *dentry = F_DENTRY(file);
 	ssize_t ret;
@@ -387,12 +387,28 @@ ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
 	ret = debugfs_file_get(dentry);
 	if (unlikely(ret))
 		return ret;
-	ret = simple_attr_write(file, buf, len, ppos);
+	if (is_signed)
+		ret = simple_attr_write_signed(file, buf, len, ppos);
+	else
+		ret = simple_attr_write(file, buf, len, ppos);
 	debugfs_file_put(dentry);
 	return ret;
 }
+
+ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos)
+{
+	return debugfs_attr_write_xsigned(file, buf, len, ppos, false);
+}
 EXPORT_SYMBOL_GPL(debugfs_attr_write);
 
+ssize_t debugfs_attr_write_signed(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos)
+{
+	return debugfs_attr_write_xsigned(file, buf, len, ppos, true);
+}
+EXPORT_SYMBOL_GPL(debugfs_attr_write_signed);
+
 static struct dentry *debugfs_create_mode_unsafe(const char *name, umode_t mode,
 					struct dentry *parent, void *value,
 					const struct file_operations *fops,
@@ -738,11 +754,11 @@ static int debugfs_atomic_t_get(void *data, u64 *val)
 	*val = atomic_read((atomic_t *)data);
 	return 0;
 }
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t, debugfs_atomic_t_get,
 			debugfs_atomic_t_set, "%lld\n");
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t_ro, debugfs_atomic_t_get, NULL,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t_ro, debugfs_atomic_t_get, NULL,
 			"%lld\n");
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t_wo, NULL, debugfs_atomic_t_set,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t_wo, NULL, debugfs_atomic_t_set,
 			"%lld\n");
 
 /**
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index f60674692d36..ea2d919fd9c7 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -45,7 +45,7 @@ struct debugfs_u32_array {
 
 extern struct dentry *arch_debugfs_dir;
 
-#define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, __is_signed)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
@@ -56,10 +56,16 @@ static const struct file_operations __fops = {				\
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = debugfs_attr_read,					\
-	.write	 = debugfs_attr_write,					\
+	.write	 = (__is_signed) ? debugfs_attr_write_signed : debugfs_attr_write,	\
 	.llseek  = no_llseek,						\
 }
 
+#define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, false)
+
+#define DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(__fops, __get, __set, __fmt)	\
+	DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, true)
+
 typedef struct vfsmount *(*debugfs_automount_t)(struct dentry *, void *);
 
 #if defined(CONFIG_DEBUG_FS)
@@ -102,6 +108,8 @@ ssize_t debugfs_attr_read(struct file *file, char __user *buf,
 			size_t len, loff_t *ppos);
 ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
 			size_t len, loff_t *ppos);
+ssize_t debugfs_attr_write_signed(struct file *file, const char __user *buf,
+			size_t len, loff_t *ppos);
 
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, const char *new_name);
@@ -254,6 +262,13 @@ static inline ssize_t debugfs_attr_write(struct file *file,
 	return -ENODEV;
 }
 
+static inline ssize_t debugfs_attr_write_signed(struct file *file,
+					const char __user *buf,
+					size_t len, loff_t *ppos)
+{
+	return -ENODEV;
+}
+
 static inline struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, char *new_name)
 {
-- 
2.35.1



