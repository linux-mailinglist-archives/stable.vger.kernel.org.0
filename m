Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B6246C6F
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 00:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfFNWlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 18:41:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbfFNWlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 18:41:23 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EMaWeR009939
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 15:41:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=j9l2szB8PVia9QS4br7TnaD/wYxzdCJv6qk5pgkVD5Q=;
 b=C1Qy/sLkEc7BHhDNWSG+twne/YUr3vqIhWzGpcRcolYwreTf+1x/q9V05Bmd/xB0uO58
 6L1ChACinPnKk/ereVoqUolnxlZzXUafAnfsLYQ0UpPnSHr4iRUldNjgGq3SV89e2c3O
 62qPjs2gHxWP1c/m3OKjbfQxsBIhKtc+SMY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2t4kf2g6uv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 15:41:21 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Jun 2019 15:41:21 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 90C0E62E307F; Fri, 14 Jun 2019 15:41:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-raid@vger.kernel.org>
CC:     <axboe@kernel.dk>, <kernel-team@fb.com>, Xiao Ni <xni@redhat.com>,
        <stable@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 2/8] raid5-cache: Need to do start() part job after adding journal device
Date:   Fri, 14 Jun 2019 15:41:05 -0700
Message-ID: <20190614224111.3485077-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190614224111.3485077-1-songliubraving@fb.com>
References: <20190614224111.3485077-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=669 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140178
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit d5d885fd514f ("md: introduce new personality funciton start()")
splits the init job to two parts. The first part run() does the jobs that
do not require the md threads. The second part start() does the jobs that
require the md threads.

Now it just does run() in adding new journal device. It needs to do the
second part start() too.

Fixes: d5d885fd514f ("md: introduce new personality funciton start()")
Cc: stable@vger.kernel.org #v4.9+
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b83bce2beb66..da94cbaa1a9e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7672,7 +7672,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	int err = -EEXIST;
+	int ret, err = -EEXIST;
 	int disk;
 	struct disk_info *p;
 	int first = 0;
@@ -7687,7 +7687,14 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		log_init(conf, rdev, false);
+		ret = log_init(conf, rdev, false);
+		if (ret)
+			return ret;
+
+		ret = r5l_start(conf->log);
+		if (ret)
+			return ret;
+
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
-- 
2.17.1

