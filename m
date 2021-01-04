Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA42E9110
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 08:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhADHbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 02:31:24 -0500
Received: from relay5.mymailcheap.com ([159.100.248.207]:43034 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbhADHbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 02:31:24 -0500
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 127D2260EC;
        Mon,  4 Jan 2021 07:30:31 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id EFBA83F15F;
        Mon,  4 Jan 2021 08:28:55 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id B6B702A7E5;
        Mon,  4 Jan 2021 08:28:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609745335;
        bh=ubj56mHRi69L846UzsE9e5xddidrKAo6HI48wtk8xJs=;
        h=From:To:Cc:Subject:Date:From;
        b=jyaTz//wcctD90WKXit3aBiUODYu96r27d540jeX1HUmpQOTQjCeDgF4k1Av+zhCI
         9k+W3oVB4Lz/x425zj0thC8zWGlXGTQTyE/B/+B8+ikFZP7wLizGQSS+hkIwA3hY/d
         0BOHTQvtQ+aCJNU5qhZ1rGE9w4aiedSpDry/1up0=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sM-Mxk4EuI0s; Mon,  4 Jan 2021 08:28:54 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  4 Jan 2021 08:28:54 +0100 (CET)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 2AA9741F21;
        Mon,  4 Jan 2021 07:28:54 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="ICXe2nhY";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.162.25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 7C4EA41F21;
        Mon,  4 Jan 2021 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609745329; bh=ubj56mHRi69L846UzsE9e5xddidrKAo6HI48wtk8xJs=;
        h=From:To:Cc:Subject:Date:From;
        b=ICXe2nhYYD7zHjKNPlF3IqYCf/MjCDqhw4rN92ix/6FN0uZTr8Ee/ME4uPj3hOS9z
         tURv7cqv9pO/oHtDjUmBF4n2fNXu6rWr2ouNaaqABugQyvMPjLYxmYORzAuujwZ6IY
         WiQJfjMfNSflrWd1f8Oa/BGPbjwu+rbPEUL008/o=
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>, stable@vger.kernel.org
Subject: [PATCH v2] ovl: use a dedicated semaphore for dir upperfile caching
Date:   Mon,  4 Jan 2021 15:28:35 +0800
Message-Id: <20210104072835.147843-1-icenowy@aosc.io>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [4.90 / 20.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.162.25:received];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.00)[~all:c];
         DMARC_NA(0.00)[aosc.io];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_SEVEN(0.00)[7];
         MID_CONTAINS_FROM(1.00)[];
         FREEMAIL_TO(0.00)[szeredi.hu,gmail.com,cn.fujitsu.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
X-Rspamd-Queue-Id: 2AA9741F21
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function ovl_dir_real_file() currently uses the semaphore of the
inode to synchronize write to the upperfile cache field.

However, this function will get called by ovl_ioctl_set_flags(), which
utilizes the inode semaphore too. In this case ovl_dir_real_file() will
try to claim a lock that is owned by a function in its call stack, which
won't get released before ovl_dir_real_file() returns.

Define a dedicated semaphore for the upperfile cache, so that the
deadlock won't happen.

Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 fs/overlayfs/readdir.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 01620ebae1bd..fa1844ff8db4 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -56,6 +56,7 @@ struct ovl_dir_file {
 	struct list_head *cursor;
 	struct file *realfile;
 	struct file *upperfile;
+	struct semaphore upperfile_sem;
 };
 
 static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
@@ -874,8 +875,6 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
 	if (!od->is_upper) {
-		struct inode *inode = file_inode(file);
-
 		realfile = READ_ONCE(od->upperfile);
 		if (!realfile) {
 			struct path upperpath;
@@ -883,10 +882,10 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 			ovl_path_upper(dentry, &upperpath);
 			realfile = ovl_dir_open_realfile(file, &upperpath);
 
-			inode_lock(inode);
+			down(&od->upperfile_sem);
 			if (!od->upperfile) {
 				if (IS_ERR(realfile)) {
-					inode_unlock(inode);
+					up(&od->upperfile_sem);
 					return realfile;
 				}
 				smp_store_release(&od->upperfile, realfile);
@@ -896,7 +895,7 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 					fput(realfile);
 				realfile = od->upperfile;
 			}
-			inode_unlock(inode);
+			up(&od->upperfile_sem);
 		}
 	}
 
@@ -959,6 +958,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	od->realfile = realfile;
 	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
+	sema_init(&od->upperfile_sem, 1);
 	file->private_data = od;
 
 	return 0;
-- 
2.28.0
