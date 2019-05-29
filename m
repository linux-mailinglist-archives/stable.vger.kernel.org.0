Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927FC2E3DC
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfE2RrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 13:47:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2RrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 13:47:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4THi3Wt008386;
        Wed, 29 May 2019 17:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=Zam+qVjQTWRHmUJHtBokDhritM7Hf2LCpkT8BRjUWlI=;
 b=aGgc1y/6cpXOb7ElM1CPp16puy5zIgJHxftn5eoE/CSvLdrMXAufSeNx6mVcogaIhJxC
 7ngr7CLg9INkIPKFP4M1HRvfB/Nz6KJAZrSoJ9Yfsd7s6w8t5AyerHrZ7CHMBQf2Fljm
 bMkrsIOX8zXzhxXbjO/cWmBg0qbvOjDLNSfldqJ+l2S3n1yvqmMKeMklIx7vnznnpcRk
 m74f7i3VJIvMppGj9UQSPr6UE8RcFrtYwiziDJrbYzu1WGvZXKc4MkhbAhk0Apa6Uq7R
 wKMq91MiV9B/no3xnVk66BuFkMYN1xan6ds9Ff6vudwCeCBP10SML3VIBl/nwkZksLag Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2spw4tkhs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 17:46:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4THjMLZ047007;
        Wed, 29 May 2019 17:46:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2ss1fnkyq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 May 2019 17:46:49 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4THkm5c051007;
        Wed, 29 May 2019 17:46:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ss1fnkypx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 17:46:48 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4THklOV031724;
        Wed, 29 May 2019 17:46:47 GMT
Received: from oracle.com (/10.211.52.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 10:46:47 -0700
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     ocfs2-devel@oss.oracle.com
Cc:     wen.gang.wang@oracle.com, gechangwei@live.cn, daniel.sobe@nxp.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        jiangqi903@gmail.com
Subject: [PATCH v4] fs/ocfs2: fix race in ocfs2_dentry_attach_lock
Date:   Wed, 29 May 2019 10:46:36 -0700
Message-Id: <20190529174636.22364-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.13.6
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=62 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ocfs2_dentry_attach_lock() can be executed in parallel threads against the
same dentry. Make that race safe.
The race is like this:

            thread A                               thread B

(A1) enter ocfs2_dentry_attach_lock,
seeing dentry->d_fsdata is NULL,
and no alias found by
ocfs2_find_local_alias, so kmalloc
a new ocfs2_dentry_lock structure
to local variable "dl", dl1

               .....

                                    (B1) enter ocfs2_dentry_attach_lock,
                                    seeing dentry->d_fsdata is NULL,
                                    and no alias found by
                                    ocfs2_find_local_alias so kmalloc
                                    a new ocfs2_dentry_lock structure
                                    to local variable "dl", dl2.

                                                   ......

(A2) set dentry->d_fsdata with dl1,
call ocfs2_dentry_lock() and increase
dl1->dl_lockres.l_ro_holders to 1 on
success.
              ......

                                    (B2) set dentry->d_fsdata with dl2
                                    call ocfs2_dentry_lock() and increase
				    dl2->dl_lockres.l_ro_holders to 1 on
				    success.

                                                  ......

(A3) call ocfs2_dentry_unlock()
and decrease
dl2->dl_lockres.l_ro_holders to 0
on success.
             ....

                                    (B3) call ocfs2_dentry_unlock(),
                                    decreasing
				    dl2->dl_lockres.l_ro_holders, but
				    see it's zero now, panic

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
Reviewed-by: Changwei Ge <gechangwei@live.cn>
---
v4: return in place on race detection.

v3: add Reviewed-by, Reported-by and Tested-by only

v2: 1) removed lock on dentry_attach_lock at the first access of
       dentry->d_fsdata since it helps very little.
    2) do cleanups before freeing the duplicated dl
    3) return after freeing the duplicated dl found.
---

 fs/ocfs2/dcache.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 290373024d9d..e8ace3b54e9c 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -310,6 +310,18 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
 
 out_attach:
 	spin_lock(&dentry_attach_lock);
+	if (unlikely(dentry->d_fsdata && !alias)) {
+		/* d_fsdata is set by a racing thread which is doing
+		 * the same thing as this thread is doing. Leave the racing
+		 * thread going ahead and we return here.
+		 */
+		spin_unlock(&dentry_attach_lock);
+		iput(dl->dl_inode);
+		ocfs2_lock_res_free(&dl->dl_lockres);
+		kfree(dl);
+		return 0;
+	}
+
 	dentry->d_fsdata = dl;
 	dl->dl_count++;
 	spin_unlock(&dentry_attach_lock);
-- 
2.13.6

