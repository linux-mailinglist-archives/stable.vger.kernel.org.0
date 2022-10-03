Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4332A5F2A40
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiJCHdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiJCHcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B4C25298;
        Mon,  3 Oct 2022 00:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97426B80E94;
        Mon,  3 Oct 2022 07:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0074DC433D6;
        Mon,  3 Oct 2022 07:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781567;
        bh=tfBx23GHH+xKpCPewZ/4fGyE9B3qjYdkoAWuEz5Cfwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3g9NWyRNgifvFYKztx7L9v0llVDkbXoHIG79wLwzRfsxWbOgYbglrJVgB8hsrkYB
         BlgfBEqEgQG+8y7Njwth7LrIcTS6DLAO7j4vmIMr9WpMtgwO7Y3h4Bw+XEyAVSYkqH
         FHLMVgwsarpzs5mESp3HYCx7827AcgTTgtmiJvNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 67/83] dont use __kernel_write() on kmap_local_page()
Date:   Mon,  3 Oct 2022 09:11:32 +0200
Message-Id: <20221003070723.675440372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 06bbaa6dc53cb72040db952053432541acb9adc7 ]

passing kmap_local_page() result to __kernel_write() is unsafe -
random ->write_iter() might (and 9p one does) get unhappy when
passed ITER_KVEC with pointer that came from kmap_local_page().

Fix by providing a variant of __kernel_write() that takes an iov_iter
from caller (__kernel_write() becomes a trivial wrapper) and adding
dump_emit_page() that parallels dump_emit(), except that instead of
__kernel_write() it uses __kernel_write_iter() with ITER_BVEC source.

Fixes: 3159ed57792b "fs/coredump: use kmap_local_page()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c   | 38 +++++++++++++++++++++++++++++++++-----
 fs/internal.h   |  3 +++
 fs/read_write.c | 22 ++++++++++++++--------
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 26eb5a095832..43fdd82f82ab 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -902,6 +902,38 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 	}
 }
 
+static int dump_emit_page(struct coredump_params *cprm, struct page *page)
+{
+	struct bio_vec bvec = {
+		.bv_page	= page,
+		.bv_offset	= 0,
+		.bv_len		= PAGE_SIZE,
+	};
+	struct iov_iter iter;
+	struct file *file = cprm->file;
+	loff_t pos = file->f_pos;
+	ssize_t n;
+
+	if (cprm->to_skip) {
+		if (!__dump_skip(cprm, cprm->to_skip))
+			return 0;
+		cprm->to_skip = 0;
+	}
+	if (cprm->written + PAGE_SIZE > cprm->limit)
+		return 0;
+	if (dump_interrupted())
+		return 0;
+	iov_iter_bvec(&iter, WRITE, &bvec, 1, PAGE_SIZE);
+	n = __kernel_write_iter(cprm->file, &iter, &pos);
+	if (n != PAGE_SIZE)
+		return 0;
+	file->f_pos = pos;
+	cprm->written += PAGE_SIZE;
+	cprm->pos += PAGE_SIZE;
+
+	return 1;
+}
+
 int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 {
 	if (cprm->to_skip) {
@@ -933,7 +965,6 @@ int dump_user_range(struct coredump_params *cprm, unsigned long start,
 
 	for (addr = start; addr < start + len; addr += PAGE_SIZE) {
 		struct page *page;
-		int stop;
 
 		/*
 		 * To avoid having to allocate page tables for virtual address
@@ -944,10 +975,7 @@ int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		 */
 		page = get_dump_page(addr);
 		if (page) {
-			void *kaddr = kmap_local_page(page);
-
-			stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-			kunmap_local(kaddr);
+			int stop = !dump_emit_page(cprm, page);
 			put_page(page);
 			if (stop)
 				return 0;
diff --git a/fs/internal.h b/fs/internal.h
index 4f1fe6d08866..69b64136ae4c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -16,6 +16,7 @@ struct shrink_control;
 struct fs_context;
 struct user_namespace;
 struct pipe_inode_info;
+struct iov_iter;
 
 /*
  * block/bdev.c
@@ -219,3 +220,5 @@ struct xattr_ctx {
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
+
+ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *pos);
diff --git a/fs/read_write.c b/fs/read_write.c
index 8d3ec975514d..08299a8f3e05 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -512,14 +512,9 @@ static ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t
 }
 
 /* caller is responsible for file_start_write/file_end_write */
-ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t *pos)
+ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *pos)
 {
-	struct kvec iov = {
-		.iov_base	= (void *)buf,
-		.iov_len	= min_t(size_t, count, MAX_RW_COUNT),
-	};
 	struct kiocb kiocb;
-	struct iov_iter iter;
 	ssize_t ret;
 
 	if (WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE)))
@@ -535,8 +530,7 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 
 	init_sync_kiocb(&kiocb, file);
 	kiocb.ki_pos = pos ? *pos : 0;
-	iov_iter_kvec(&iter, WRITE, &iov, 1, iov.iov_len);
-	ret = file->f_op->write_iter(&kiocb, &iter);
+	ret = file->f_op->write_iter(&kiocb, from);
 	if (ret > 0) {
 		if (pos)
 			*pos = kiocb.ki_pos;
@@ -546,6 +540,18 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
 	inc_syscw(current);
 	return ret;
 }
+
+/* caller is responsible for file_start_write/file_end_write */
+ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t *pos)
+{
+	struct kvec iov = {
+		.iov_base	= (void *)buf,
+		.iov_len	= min_t(size_t, count, MAX_RW_COUNT),
+	};
+	struct iov_iter iter;
+	iov_iter_kvec(&iter, WRITE, &iov, 1, iov.iov_len);
+	return __kernel_write_iter(file, &iter, pos);
+}
 /*
  * This "EXPORT_SYMBOL_GPL()" is more of a "EXPORT_SYMBOL_DONTUSE()",
  * but autofs is one of the few internal kernel users that actually
-- 
2.35.1



