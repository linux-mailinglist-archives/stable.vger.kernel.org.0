Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2D601742
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiJQTUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiJQTUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF17FD30;
        Mon, 17 Oct 2022 12:20:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITJ6I005795;
        Mon, 17 Oct 2022 19:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=brPOhumrB5oqQEjai/DMj1NxCaV7hOCcgnerJu2uuBk=;
 b=Qyss/UodxvPvQTFWD6M36tPec/2nD1vA2vSGF8UmJ9G4TqvkhjiR/7jzD+9uandTHAfn
 PFQExAALGi3F6TrubN00FJ9++D28QkeOZXo6wwtgoGt5N11U4WPzmr4XmWLp++zBCQ/e
 JGnrxYIIDMNz1Hq69cVYc7y8HqgkPmJ3/UMVOCtMcvr6qb3d5qfNayQxNTtX75oAiTzA
 ORHrpTMDRpwzdblgnIByb3goxYlwK7t99EXTQf8XdbRLEoTwhQ0sPiorF2QYGkDpAunV
 mOVdieoyc3OtYvoM+t7ONi+XvyFzmoeHBB4zuSGvTG2yGkIVq1D+BMw0GoVZ979BlBYY 2g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3cgfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HHfDeq036341;
        Mon, 17 Oct 2022 19:20:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4as4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYp007860;
        Mon, 17 Oct 2022 19:20:29 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-2;
        Mon, 17 Oct 2022 19:20:29 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 1/5] fs: clear or set FMODE_LSEEK based on llseek function
Date:   Mon, 17 Oct 2022 12:20:02 -0700
Message-Id: <20221017192006.36398-2-saeed.mirzamohammadi@oracle.com>
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
X-Proofpoint-ORIG-GUID: k3TBF23zYJuaYDMzLR_utHkoDKLSDgOc
X-Proofpoint-GUID: k3TBF23zYJuaYDMzLR_utHkoDKLSDgOc
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

Pipe-like behaviour on llseek(2) (i.e. unconditionally failing with
-ESPIPE) can be expresses in 3 ways:
	1) ->llseek set to NULL in file_operations
	2) ->llseek set to no_llseek in file_operations
	3) FMODE_LSEEK *not* set in ->f_mode.

Enforce (3) in cases (1) and (2); that will allow to simplify the
checks and eventually get rid of no_llseek boilerplate.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit e7478158e1378325907edfdd960eca98a1be405b)
Conflicts:
	fs/open.c
Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 fs/file_table.c | 2 ++
 fs/open.c       | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/fs/file_table.c b/fs/file_table.c
index e8c9016703ad..f675817be4ad 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -198,6 +198,8 @@ static struct file *alloc_file(const struct path *path, int flags,
 	file->f_mapping = path->dentry->d_inode->i_mapping;
 	file->f_wb_err = filemap_sample_wb_err(file->f_mapping);
 	file->f_sb_err = file_sample_sb_err(file);
+	if (fop->llseek && fop->llseek != no_llseek)
+		file->f_mode |= FMODE_LSEEK;
 	if ((file->f_mode & FMODE_READ) &&
 	     likely(fop->read || fop->read_iter))
 		file->f_mode |= FMODE_CAN_READ;
diff --git a/fs/open.c b/fs/open.c
index 1ba1d2ab2ef0..38bf38d41418 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -834,6 +834,10 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_mode & FMODE_WRITE) &&
 	     likely(f->f_op->write || f->f_op->write_iter))
 		f->f_mode |= FMODE_CAN_WRITE;
+	if ((f->f_mode & FMODE_LSEEK) && !f->f_op->llseek)
+		f->f_mode &= ~FMODE_LSEEK;
+	if ((f->f_mode & FMODE_LSEEK) && f->f_op->llseek == no_llseek)
+		f->f_mode &= ~FMODE_LSEEK;
 
 	f->f_write_hint = WRITE_LIFE_NOT_SET;
 	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
-- 
2.31.1

