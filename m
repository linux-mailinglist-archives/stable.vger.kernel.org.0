Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF555601740
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiJQTUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiJQTUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861277674E;
        Mon, 17 Oct 2022 12:20:36 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITJ4J026745;
        Mon, 17 Oct 2022 19:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=3l6Jm/j5UGLMxQsiYqUPn8xoi5WXHOYfNbpCDtSFPMI=;
 b=1zMdrNYksEDo7ORUz3SeEO3Z/w5pDWTSJUGZ3Qk2m93r7yNI7Ff6x3axRI7Ry9KSb3CP
 Z+YipYNuUS7cbBQWYxvc96JysTYQNV6hbtxhMh50ZjEtRi44lV+JVilbtBUkpjBpTshO
 RPGjkDaWJsm7kGPTsDA0fvsoNAK5NkrX2x3IxlceFkN1LVo/AiLPD56gUYd6y9sEzBjh
 q0/hFJh1I+6XtaL1TzXkL1hn2KqQQJay2O7vXLECGPhhS1FFpCEsntbEDIZNAk7VOL5p
 nthtmutVzAbVDZA/tyPCK6xauW24q23UAgZiNeuFGeySS+ONHtTCpqurU0huTeQ0QHP6 Cw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7sga5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HHae95036317;
        Mon, 17 Oct 2022 19:20:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4avv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:34 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYr007860;
        Mon, 17 Oct 2022 19:20:34 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-3;
        Mon, 17 Oct 2022 19:20:33 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 2/5] fs: do not compare against ->llseek
Date:   Mon, 17 Oct 2022 12:20:03 -0700
Message-Id: <20221017192006.36398-3-saeed.mirzamohammadi@oracle.com>
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
X-Proofpoint-GUID: MHRi98lwiCqt0TgbuOmYkPTCCLszGlZv
X-Proofpoint-ORIG-GUID: MHRi98lwiCqt0TgbuOmYkPTCCLszGlZv
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

Now vfs_llseek() can simply check for FMODE_LSEEK; if it's set,
we know that ->llseek() won't be NULL and if it's not we should
just fail with -ESPIPE.

A couple of other places where we used to check for special
values of ->llseek() (somewhat inconsistently) switched to
checking FMODE_LSEEK.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit 4e3299eaddffd9d7d5b8bae28ad700bb775f02d0)
Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 fs/coredump.c          |  4 ++--
 fs/overlayfs/copy_up.c |  3 +--
 fs/read_write.c        | 11 +++--------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 26eb5a095832..04ce02e30e23 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -886,9 +886,9 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 {
 	static char zeroes[PAGE_SIZE];
 	struct file *file = cprm->file;
-	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+	if (file->f_mode & FMODE_LSEEK) {
 		if (dump_interrupted() ||
-		    file->f_op->llseek(file, nr, SEEK_CUR) < 0)
+		    vfs_llseek(file, nr, SEEK_CUR) < 0)
 			return 0;
 		cprm->pos += nr;
 		return 1;
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e040970408d4..7636ec4d8b1c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -226,8 +226,7 @@ static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
 	/* Couldn't clone, so now we try to copy the data */
 
 	/* Check if lower fs supports seek operation */
-	if (old_file->f_mode & FMODE_LSEEK &&
-	    old_file->f_op->llseek)
+	if (old_file->f_mode & FMODE_LSEEK)
 		skip_hole = true;
 
 	while (len) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 8d3ec975514d..b64527211b32 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -290,14 +290,9 @@ EXPORT_SYMBOL(default_llseek);
 
 loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 {
-	loff_t (*fn)(struct file *, loff_t, int);
-
-	fn = no_llseek;
-	if (file->f_mode & FMODE_LSEEK) {
-		if (file->f_op->llseek)
-			fn = file->f_op->llseek;
-	}
-	return fn(file, offset, whence);
+	if (!(file->f_mode & FMODE_LSEEK))
+		return -ESPIPE;
+	return file->f_op->llseek(file, offset, whence);
 }
 EXPORT_SYMBOL(vfs_llseek);
 
-- 
2.31.1

