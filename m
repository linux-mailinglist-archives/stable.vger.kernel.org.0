Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A2921169B
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgGAXZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:25:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40524 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgGAXZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:25:44 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200701232541epoutp01f5d8f75ddfda04e2ca2e26ebf8207a5c~dxIpl4x921530015300epoutp01c
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:25:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200701232541epoutp01f5d8f75ddfda04e2ca2e26ebf8207a5c~dxIpl4x921530015300epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593645941;
        bh=THn4eSVTr9plFOAx8r1gvbvF7C5JmhoEVpa0VmoLsGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heKTb14IMmmo22Np4MNKFK9RRNlUsESWvkHymPMKfWCjLE9xNsE2Dj8UK/i33B1o6
         9s7uUzz0NjiX6rRDoH4uHYutNGxZvcfhYaDgz9FVkLMkjSenpntnEPUSMldZnPggVS
         M7CFUszgUte0s7tziYeY6N0WJY4SqUBC1rNYNaNk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200701232541epcas1p337adcccf7703c2400c819b3293185f0b~dxIpBk-Pw0380203802epcas1p37;
        Wed,  1 Jul 2020 23:25:41 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.161]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49xy5J2ZmxzMqYkl; Wed,  1 Jul
        2020 23:25:40 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.1B.19033.47B1DFE5; Thu,  2 Jul 2020 08:25:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200701232539epcas1p4b7cb5db391c6974f541b4b8b5263ba65~dxInyFZV60386903869epcas1p4J;
        Wed,  1 Jul 2020 23:25:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200701232539epsmtrp186ff76cf4d429a34f69dddcbfd9e9957~dxInxZ8lb1659116591epsmtrp1A;
        Wed,  1 Jul 2020 23:25:39 +0000 (GMT)
X-AuditID: b6c32a36-159ff70000004a59-79-5efd1b7476b6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.0C.08382.37B1DFE5; Thu,  2 Jul 2020 08:25:39 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200701232539epsmtip239503a0322f10a34faa7978d44008580~dxInnufHF2699026990epsmtip2i;
        Wed,  1 Jul 2020 23:25:39 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 5/5] exfat: flush dirty metadata in fsync
Date:   Thu,  2 Jul 2020 08:20:24 +0900
Message-Id: <20200701232024.2083-6-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701232024.2083-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmrm6J9N84g1uPBS2aF69ns7i8aw6b
        xY/p9Rab1lxjs9jy7wirxYKNjxgd2Dw2repk89g/dw27R9+WVYwenzfJBbBE5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhToFSfmFpfmpesl5+daGRoYGJkCVSbkZPyZfpS94L1Y
        xaZft1kbGJuFuxg5OSQETCS+zJnH2sXIxSEksINR4s3EB2wQzidGiSvrJ0BlvjFKdGxuYIVp
        2dXdDpXYyyhx9vBKJoSWWw+Yuxg5ONgEtCX+bBEFaRARMJS48fkaC0gNs0AHo8TdLx+YQRLC
        AvYSaybtZAOxWQRUJV7uXQUW5xWwllja+5YJYpu8xOoNB8DinAI2EuvO/WcEGSQhsItdYsPU
        +8wQRS4SJ+/8Z4ewhSVeHd8CZUtJvOxvYwc5SEKgWuLjfqhyoCNefLeFsI0lbq7fwApSwiyg
        KbF+lz5EWFFi5++5jCA2swCfxLuvPawQU3glOtqEIEpUJfouHYa6Ulqiq/0D1FIPiWe77jJD
        gqSfUeLEse+MExjlZiFsWMDIuIpRLLWgODc9tdiwwAg5xjYxghOXltkOxklvP+gdYmTiYDzE
        KMHBrCTCe9rgV5wQb0piZVVqUX58UWlOavEhRlNg2E1klhJNzgemzrySeENTI2NjYwsTM3Mz
        U2MlcV41mQtxQgLpiSWp2ampBalFMH1MHJxSDUy25eFmJVsclvSnan9v2yzL7hT12TRKkPXz
        BJ60TIkgMwmJN5P2NLv++Fj0XFz18Nyrt5WeTbwmc5ehLHYmW5PUp70BhdbGL70uc3zVkEi5
        89NsntfTnnqhGwvj7mx5cyzsI7v3zN0i3xU1UvMvnp31Q93Q3+XKwWN36765CxvU14V3PJGP
        TWFqSo6cyZubNzF9L8OF9zWvu4x+Ndy0KDHunLtr+jw39h7HquLVz9i+ZKpO3ZYj4SDenyPk
        /23Ztt9cPhF7P7h2zk0X4/i77d6PDW/+p2RVJzp2Xv1yXOqy6rpephNzdklW7Urp2+dY/6Ne
        6XLmhcjz+7P/vzY8LJ9RP2+RWqJL9ck3Wq5rBJVYijMSDbWYi4oTAQAk1x3lAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42LZdlhJXrdY+m+cwbGzRhbNi9ezWVzeNYfN
        4sf0eotNa66xWWz5d4TVYsHGR4wObB6bVnWyeeyfu4bdo2/LKkaPz5vkAliiuGxSUnMyy1KL
        9O0SuDL+TD/KXvBerGLTr9usDYzNwl2MnBwSAiYSu7rbWbsYuTiEBHYzSnRMWcIGkZCWOHbi
        DHMXIweQLSxx+HAxRM0HRol9l+ewgMTZBLQl/mwRBTFFBIwl2r+WgXQyC/QwSvx8YwdiCwvY
        S6yZtBNsIouAqsTLvauYQWxeAWuJpb1vmSA2yUus3nAALM4pYCOx7tx/RhBbCKhm45WXLBMY
        +RYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOLS3NHYzbV33QO8TIxMF4iFGC
        g1lJhPe0wa84Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3ChfGCQmkJ5akZqemFqQWwWSZODil
        GpjaXRWPWq+dbnVzSkxqkcJzA/bvtddf7U/uZLc//P//tJtnKuKOfhYoMPcz97qouOglc5nF
        k3XWs1pCf6dXGNxbF79zd7Lwyn5nXdWIyK862/LvxH69IJvBwdT3cjfn97az778ZLKj8yGrf
        8dP4zdOAzNuX9xz4cyfo+gSv7jUncrXSL8bYHonUU5Z+3vMu1UhrL+P7uy92LTsdv8Wqxax2
        VrV8qEDs/c98Gb+TIlwqOT9YNa99Jn042deUacn1nbmL/5TFHQi47FkYdm227e2wa4v9V97h
        XKI/MfX+0yWPfjtNrcw2ai5ZP+uTqfC7NK2/HQ4Mvv8EHdUNHhxfqdae12VTJrciVubshbSn
        j0yUWIozEg21mIuKEwHSfoF6nAIAAA==
X-CMS-MailID: 20200701232539epcas1p4b7cb5db391c6974f541b4b8b5263ba65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232539epcas1p4b7cb5db391c6974f541b4b8b5263ba65
References: <20200701232024.2083-1-namjae.jeon@samsung.com>
        <CGME20200701232539epcas1p4b7cb5db391c6974f541b4b8b5263ba65@epcas1p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sungjong Seo <sj1557.seo@samsung.com>

generic_file_fsync() exfat used could not guarantee the consistency of
a file because it has flushed not dirty metadata but only dirty data pages
for a file.

Instead of that, use exfat_file_fsync() for files and directories so that
it guarantees to commit both the metadata and data pages for a file.

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/dir.c      |  2 +-
 fs/exfat/exfat_fs.h |  1 +
 fs/exfat/file.c     | 19 ++++++++++++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 349ca0c282c2..6db302d76d4c 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -314,7 +314,7 @@ const struct file_operations exfat_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate	= exfat_iterate,
-	.fsync		= generic_file_fsync,
+	.fsync		= exfat_file_fsync,
 };
 
 int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index d67fb8a6f770..d865050fa6cd 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -424,6 +424,7 @@ void exfat_truncate(struct inode *inode, loff_t size);
 int exfat_setattr(struct dentry *dentry, struct iattr *attr);
 int exfat_getattr(const struct path *path, struct kstat *stat,
 		unsigned int request_mask, unsigned int query_flags);
+int exfat_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 /* namei.c */
 extern const struct dentry_operations exfat_dentry_ops;
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 5b4ddff18731..b93aa9e6cb16 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/buffer_head.h>
+#include <linux/blkdev.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
@@ -347,12 +348,28 @@ int exfat_setattr(struct dentry *dentry, struct iattr *attr)
 	return error;
 }
 
+int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = filp->f_mapping->host;
+	int err;
+
+	err = __generic_file_fsync(filp, start, end, datasync);
+	if (err)
+		return err;
+
+	err = sync_blockdev(inode->i_sb->s_bdev);
+	if (err)
+		return err;
+
+	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+}
+
 const struct file_operations exfat_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
-	.fsync		= generic_file_fsync,
+	.fsync		= exfat_file_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
-- 
2.17.1

