Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B472EA18B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 01:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAEAi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:38:56 -0500
Received: from relay5.mymailcheap.com ([159.100.241.64]:51967 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhAEAi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 19:38:56 -0500
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 31FFD2008F;
        Tue,  5 Jan 2021 00:38:03 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id 621733F201;
        Tue,  5 Jan 2021 00:36:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id A76F92A510;
        Tue,  5 Jan 2021 01:36:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609806988;
        bh=u52Z7siiARKrKV8QGDSAzgaEB7zsH3+a2x9YcbH+lVc=;
        h=From:To:Cc:Subject:Date:From;
        b=YAwE1tifxliaSfNtovv26jEmpZM7l52WAIjNCLY75kVk/+0J6xDl/VOMXgsFzjmXB
         ++ixX9pWPJZ6YhsfVKb3wvNICpiihEY0ZRmysqfIrtGXSAtsz4bjK1EgtSMIARkux/
         V2fH8j0Qpo484+Oh9m62J23RW0YE0mHkjoE9Vwtk=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5dMdp0JIuI-9; Tue,  5 Jan 2021 01:36:27 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Tue,  5 Jan 2021 01:36:27 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 33DA541E9B;
        Tue,  5 Jan 2021 00:36:26 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="j1xJ6SMM";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.162.91])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id E4F1941E9B;
        Tue,  5 Jan 2021 00:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609806983; bh=u52Z7siiARKrKV8QGDSAzgaEB7zsH3+a2x9YcbH+lVc=;
        h=From:To:Cc:Subject:Date:From;
        b=j1xJ6SMMut4ehrM1NlUnzBSF2ASNiuItNDaJqD6FwONK1CMzu7RLjXg9VqluKJKbV
         Rv1GHdHjEveaenZhq3mlhpUNP2hZ1B9JqXUY69kp5oSd7W9xCv4SChuIdFPaacuFHF
         5i4mk026UKvfBQWSkSuu46+t459WVWHKB5V96dOU=
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>, stable@vger.kernel.org
Subject: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile caching
Date:   Tue,  5 Jan 2021 08:36:11 +0800
Message-Id: <20210105003611.194511-1-icenowy@aosc.io>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: mail20.mymailcheap.com
X-Spamd-Result: default: False [4.90 / 20.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.162.91:received];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.00)[~all];
         DMARC_NA(0.00)[aosc.io];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_SEVEN(0.00)[7];
         MID_CONTAINS_FROM(1.00)[];
         FREEMAIL_TO(0.00)[szeredi.hu,gmail.com,cn.fujitsu.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Queue-Id: 33DA541E9B
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
Changes in v2:
- Fixed missing replacement in error handling path.
Changes in v3:
- Use mutex instead of semaphore.

 fs/overlayfs/readdir.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 01620ebae1bd..3980f9982f34 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -56,6 +56,7 @@ struct ovl_dir_file {
 	struct list_head *cursor;
 	struct file *realfile;
 	struct file *upperfile;
+	struct mutex upperfile_mutex;
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
+			mutex_lock(&od->upperfile_mutex);
 			if (!od->upperfile) {
 				if (IS_ERR(realfile)) {
-					inode_unlock(inode);
+					mutex_unlock(&od->upperfile_mutex);
 					return realfile;
 				}
 				smp_store_release(&od->upperfile, realfile);
@@ -896,7 +895,7 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 					fput(realfile);
 				realfile = od->upperfile;
 			}
-			inode_unlock(inode);
+			mutex_unlock(&od->upperfile_mutex);
 		}
 	}
 
@@ -959,6 +958,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	od->realfile = realfile;
 	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
+	mutex_init(&od->upperfile_mutex);
 	file->private_data = od;
 
 	return 0;
-- 
2.28.0
