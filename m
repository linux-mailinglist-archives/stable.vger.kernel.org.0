Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22273601745
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiJQTUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiJQTUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F8D5C943;
        Mon, 17 Oct 2022 12:20:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITPOY022718;
        Mon, 17 Oct 2022 19:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=MCMejsWJItNd+KolSCgm5ldOdyDz/Mq994rgjl062DQ=;
 b=mJaqFXIJGmhCUdCxtYWne6DZUJ5bom5SIds5qObVpogQefuoe9LS0X6a1ZwjhGDaK/u5
 ky4h6xt8yalsvoSvvvGVCntURrRf1c21QFZx8o9SJrBEwIWGG4F0TvwIGGthn61MzQ6/
 kWqNVcflDLFJv1QxX89sVIFDRqpurMDxS2vr94Jfdl6wDR9fibyudWm9MNnpoPrAF4gU
 NbNIX0JdejOF2mymfL1uWMLQOX8NtvInzPKMLNj1C6slRCZcp/JJabSJif2pYcLWfdfZ
 z3RPHmo1Bo02Z3qJjdwZSzsE5UzHCQsDXxyOJp2QQSxdbgFM968jjvxEkliyzgioPcIm rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mtyvqvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HHfDf0036341;
        Mon, 17 Oct 2022 19:20:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4b0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYv007860;
        Mon, 17 Oct 2022 19:20:38 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-5;
        Mon, 17 Oct 2022 19:20:38 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH stable 4/5] vfio: do not set FMODE_LSEEK flag
Date:   Mon, 17 Oct 2022 12:20:05 -0700
Message-Id: <20221017192006.36398-5-saeed.mirzamohammadi@oracle.com>
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
X-Proofpoint-ORIG-GUID: c2l-luNZpKMZjPvCjlcpybMw--ZxWf9M
X-Proofpoint-GUID: c2l-luNZpKMZjPvCjlcpybMw--ZxWf9M
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

This file does not support llseek, so don't set the flag advertising it.

Acked-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit 54ef7a47f67de9e87022a5310d1e8332af3e2696)
Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 818e47fc0896..93346a76aa7b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1490,7 +1490,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 * Appears to be missing by lack of need rather than
 	 * explicitly prevented.  Now there's need.
 	 */
-	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
+	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
 
 	atomic_inc(&group->container_users);
 
-- 
2.31.1

