Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EC22E8580
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbhAAUPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:15:20 -0500
Received: from relay5.mymailcheap.com ([159.100.248.207]:42273 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727155AbhAAUPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:15:20 -0500
X-Greylist: delayed 171075 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jan 2021 15:15:19 EST
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.199.117])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id A5D7F260EB;
        Fri,  1 Jan 2021 20:14:27 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 675303F1CF;
        Fri,  1 Jan 2021 21:12:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 9991D2A3E1;
        Fri,  1 Jan 2021 15:12:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609531971;
        bh=mup4tYDJ06aF1cMf8ZNg00/qBTcpyfhMXsMxbVvsLmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=wATXthZJAkEDH6eFX/XRbbNPAAf/O+3FncTdnZDsMlaEVjxxDuSEcx78U5iuBh2cj
         qRTQF/HOn5Y8iCIMojsFYKgdW83i3WZHQ1ycz6pF5pGLkkood2IrR1N7bIa1esJgBx
         qAnAcGkQMCRrUr+ZU4Y1HaG60HIzjqZ1C5xfM/to=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JGkaTNTsVahz; Fri,  1 Jan 2021 15:12:50 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Fri,  1 Jan 2021 15:12:50 -0500 (EST)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id C3F6B423F0;
        Fri,  1 Jan 2021 20:12:48 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="fb/Qkf8G";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.162.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id CD82E422E7;
        Fri,  1 Jan 2021 20:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609531967; bh=mup4tYDJ06aF1cMf8ZNg00/qBTcpyfhMXsMxbVvsLmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fb/Qkf8GEbxBXwcXuwgZG2SbDyoBMFhlrqxtK2uniTcqeVZ+oXGFWOr4X6Hzbu0jY
         fEgQ2sLAJjdKQtcx8QL4TugQGQ3GLUL3mn7hfOe6dOWanqiaILdh6UgK+lNg9HBtvG
         Y5jNuZysmKgmPIBi6pQMVORDjUfpB81PjFC8pepQ=
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>, stable@vger.kernel.org
Subject: [PATCH] ovl: use a dedicated semaphore for dir upperfile caching
Date:   Sat,  2 Jan 2021 04:12:30 +0800
Message-Id: <20210101201230.768653-1-icenowy@aosc.io>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [4.90 / 20.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.162.48:received];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.00)[~all];
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
X-Rspamd-Queue-Id: C3F6B423F0
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
 fs/overlayfs/readdir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 01620ebae1bd..f10701aabb71 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -56,6 +56,7 @@ struct ovl_dir_file {
 	struct list_head *cursor;
 	struct file *realfile;
 	struct file *upperfile;
+	struct semaphore upperfile_sem;
 };
 
 static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
@@ -883,7 +884,7 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 			ovl_path_upper(dentry, &upperpath);
 			realfile = ovl_dir_open_realfile(file, &upperpath);
 
-			inode_lock(inode);
+			down(&od->upperfile_sem);
 			if (!od->upperfile) {
 				if (IS_ERR(realfile)) {
 					inode_unlock(inode);
@@ -896,7 +897,7 @@ struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 					fput(realfile);
 				realfile = od->upperfile;
 			}
-			inode_unlock(inode);
+			up(&od->upperfile_sem);
 		}
 	}
 
@@ -959,6 +960,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	od->realfile = realfile;
 	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
+	sema_init(&od->upperfile_sem, 1);
 	file->private_data = od;
 
 	return 0;
-- 
2.28.0
