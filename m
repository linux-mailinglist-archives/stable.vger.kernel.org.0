Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23260174B
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJQTUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJQTUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8763226120;
        Mon, 17 Oct 2022 12:20:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITP1R022722;
        Mon, 17 Oct 2022 19:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=eNm2INiTaoShknyJ5OevDiDEJxGt8eereztJzFcRVwg=;
 b=Vto6vkVzTkpIvV1QahWukLv66Kk+KAlUAGTzC2eFCKRP+8rcuwHRbVFe1EVm8yi5LwF1
 aElRg3PcWEwcEXlXUOQCxi6YmO7nMfAmFbqIOHZMLQnnATQfAxu2HtZTFzxygeABqgYm
 zS/dDgtLbR2z+xR1Ri7x28Ct1P09z19xpa7orxDckng8XkzQIY3atdyWjWtnRBKSpeAB
 Rte0yzrAM0WrgWeN4orDaNHVy/eaJ0MmaA+9D/HnwgxX14KhXc+vDR+bw61Vw2kO9dTi
 qjqYtV7i5leeCdU9jH7spbpl0+Ciw5yAizwi8Db9GHPA4AgsvwTo4a1tpuVUm2n4Sscp Vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mtyvqvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HIGwlT036362;
        Mon, 17 Oct 2022 19:20:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4b26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:41 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYx007860;
        Mon, 17 Oct 2022 19:20:40 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-6;
        Mon, 17 Oct 2022 19:20:40 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 5/5] fs: remove no_llseek
Date:   Mon, 17 Oct 2022 12:20:06 -0700
Message-Id: <20221017192006.36398-6-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
References: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170111
X-Proofpoint-ORIG-GUID: jh-JerGZq8d70Q-YXCdtol2dKiOuTSMY
X-Proofpoint-GUID: jh-JerGZq8d70Q-YXCdtol2dKiOuTSMY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

Now that all callers of ->llseek are going through vfs_llseek(), we
don't gain anything by keeping no_llseek around. Nothing actually calls
it and setting ->llseek to no_lseek is completely equivalent to
leaving it NULL.

Longer term (== by the end of merge window) we want to remove all such
intializations.  To simplify the merge window this commit does *not*
touch initializers - it only defines no_llseek as NULL (and simplifies
the tests on file opening).

At -rc1 we'll need do a mechanical removal of no_llseek -

git grep -l -w no_llseek | grep -v porting.rst | while read i; do
	sed -i '/\<no_llseek\>/d' $i
done
would do it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit 868941b14441282ba08761b770fc6cad69d5bdb7)
Conflicts:
	fs/open.c
Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 Documentation/filesystems/porting.rst | 8 ++++++++
 drivers/gpu/drm/drm_file.c            | 3 +--
 fs/file_table.c                       | 2 +-
 fs/read_write.c                       | 6 ------
 include/linux/fs.h                    | 2 +-
 kernel/bpf/bpf_iter.c                 | 3 +--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index bf19fd6b86e7..9d362f80a644 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -908,3 +908,11 @@ Calling conventions for file_open_root() changed; now it takes struct path *
 instead of passing mount and dentry separately.  For callers that used to
 pass <mnt, mnt->mnt_root> pair (i.e. the root of given mount), a new helper
 is provided - file_open_root_mnt().  In-tree users adjusted.
+
+---
+
+**mandatory**
+
+no_llseek is gone; don't set .llseek to that - just leave it NULL instead.
+Checks for "does that file have llseek(2), or should it fail with ESPIPE"
+should be done by looking at FMODE_LSEEK in file->f_mode.
diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index ed25168619fc..dc7d2e5b16c8 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -552,8 +552,7 @@ EXPORT_SYMBOL(drm_release_noglobal);
  * Since events are used by the KMS API for vblank and page flip completion this
  * means all modern display drivers must use it.
  *
- * @offset is ignored, DRM events are read like a pipe. Therefore drivers also
- * must set the &file_operation.llseek to no_llseek(). Polling support is
+ * @offset is ignored, DRM events are read like a pipe. Polling support is
  * provided by drm_poll().
  *
  * This function will only ever read a full event. Therefore userspace must
diff --git a/fs/file_table.c b/fs/file_table.c
index f675817be4ad..652b70841df6 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -198,7 +198,7 @@ static struct file *alloc_file(const struct path *path, int flags,
 	file->f_mapping = path->dentry->d_inode->i_mapping;
 	file->f_wb_err = filemap_sample_wb_err(file->f_mapping);
 	file->f_sb_err = file_sample_sb_err(file);
-	if (fop->llseek && fop->llseek != no_llseek)
+	if (fop->llseek)
 		file->f_mode |= FMODE_LSEEK;
 	if ((file->f_mode & FMODE_READ) &&
 	     likely(fop->read || fop->read_iter))
diff --git a/fs/read_write.c b/fs/read_write.c
index b64527211b32..582beb67e48e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -227,12 +227,6 @@ loff_t noop_llseek(struct file *file, loff_t offset, int whence)
 }
 EXPORT_SYMBOL(noop_llseek);
 
-loff_t no_llseek(struct file *file, loff_t offset, int whence)
-{
-	return -ESPIPE;
-}
-EXPORT_SYMBOL(no_llseek);
-
 loff_t default_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file_inode(file);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76162f046670..f5eac9d76e9d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3174,7 +3174,7 @@ extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t noop_llseek(struct file *file, loff_t offset, int whence);
-extern loff_t no_llseek(struct file *file, loff_t offset, int whence);
+#define no_llseek NULL
 extern loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
 extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index b2ee45064e06..60e8f611954e 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -80,10 +80,9 @@ static bool bpf_iter_support_resched(struct seq_file *seq)
 #define MAX_ITER_OBJECTS	1000000
 
 /* bpf_seq_read, a customized and simpler version for bpf iterator.
- * no_llseek is assumed for this file.
  * The following are differences from seq_read():
  *  . fixed buffer size (PAGE_SIZE)
- *  . assuming no_llseek
+ *  . assuming NULL ->llseek()
  *  . stop() may call bpf program, handling potential overflow there
  */
 static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
-- 
2.31.1

