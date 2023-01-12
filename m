Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6524E667432
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjALOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjALODm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:03:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBC95328A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:03:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5681862026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319FDC433EF;
        Thu, 12 Jan 2023 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532216;
        bh=2ONSy7Qz/S4ya/YPlKdd00Np+Ynz3y981BINXLYkj2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aABM7OVwP0L1WK/qh428i17TE9IAahaw4gYKscA96A0XjtWy33J1jMmpgYSTbe+8
         40+Bfi0pKmSRbloc/Bi9t/U1S4MMNDyqMWOEYJIPAIY3xba02HgJ4dBFCjZn+4r9qt
         sv1/Re9YiHY07YIcASADX72eJxBNDyAq646FuvAc=
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
Subject: [PATCH 5.10 071/783] libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
Date:   Thu, 12 Jan 2023 14:46:27 +0100
Message-Id: <20230112135527.446060191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 2e41f274f9aa71cdcc69dc1f26a3f9304a651804 ]

Patch series "fix error when writing negative value to simple attribute
files".

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), but some attribute files want to accept a negative
value.

This patch (of 3):

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), so we have to use a 64-bit value to write a
negative value.

This adds DEFINE_SIMPLE_ATTRIBUTE_SIGNED for a signed value.

Link: https://lkml.kernel.org/r/20220919172418.45257-1-akinobu.mita@gmail.com
Link: https://lkml.kernel.org/r/20220919172418.45257-2-akinobu.mita@gmail.com
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
 fs/libfs.c         | 22 +++++++++++++++++++---
 include/linux/fs.h | 12 ++++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 7124c2e8df2f..aa0fbd720409 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -955,8 +955,8 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 EXPORT_SYMBOL_GPL(simple_attr_read);
 
 /* interpret the buffer as a number to call the set function with */
-ssize_t simple_attr_write(struct file *file, const char __user *buf,
-			  size_t len, loff_t *ppos)
+static ssize_t simple_attr_write_xsigned(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos, bool is_signed)
 {
 	struct simple_attr *attr;
 	unsigned long long val;
@@ -977,7 +977,10 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	ret = kstrtoull(attr->set_buf, 0, &val);
+	if (is_signed)
+		ret = kstrtoll(attr->set_buf, 0, &val);
+	else
+		ret = kstrtoull(attr->set_buf, 0, &val);
 	if (ret)
 		goto out;
 	ret = attr->set(attr->data, val);
@@ -987,8 +990,21 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
+
+ssize_t simple_attr_write(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, false);
+}
 EXPORT_SYMBOL_GPL(simple_attr_write);
 
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, true);
+}
+EXPORT_SYMBOL_GPL(simple_attr_write_signed);
+
 /**
  * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
  * @sb:		filesystem to do the file handle conversion on
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ebfc0b2b4969..9a477e537361 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3345,7 +3345,7 @@ void simple_transaction_set(struct file *file, size_t n);
  * All attributes contain a text representation of a numeric value
  * that are accessed with the get() and set() functions.
  */
-#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, __is_signed)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
@@ -3356,10 +3356,16 @@ static const struct file_operations __fops = {				\
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
-	.write	 = simple_attr_write,					\
+	.write	 = (__is_signed) ? simple_attr_write_signed : simple_attr_write,	\
 	.llseek	 = generic_file_llseek,					\
 }
 
+#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, false)
+
+#define DEFINE_SIMPLE_ATTRIBUTE_SIGNED(__fops, __get, __set, __fmt)	\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, true)
+
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
 {
@@ -3374,6 +3380,8 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 			 size_t len, loff_t *ppos);
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+				 size_t len, loff_t *ppos);
 
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write,
-- 
2.35.1



