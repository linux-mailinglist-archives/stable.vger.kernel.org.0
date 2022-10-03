Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BE5F2C9D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 10:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiJCI71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 04:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJCI6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 04:58:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D901659D;
        Mon,  3 Oct 2022 01:44:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2936htLu028079;
        Mon, 3 Oct 2022 08:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=bGy4iW5/qgzKkRo3dXZGgFWRf7tMpTALb06CwLZ/+tI=;
 b=jjB/GtDVTKTLYTrYkHD2ZQYKKsMutBbFx5uQyeieenQBnqNW6EtiCcSwMrWilHe1sE6r
 e/duoKjIkgvkkMNHBBS90lXNT6u4w0cwWAUxLpkNUxBVG/SCcqs1GZ9/2KLA/buAePQl
 kRWYKLupbJL61xlAnXhX6NirCZ6ycEeL9y1FTpVpe3rJyiuyi/yBIu2sWbd0njJkZUwZ
 Tj6j0L/jJlIxq5c4V9eszbA7O9s8RvTeNBAj07NIO2t5k9S7ztQAZLVXtfCUEaaYniCM
 jvoQDLNSDbNbAqjs/o5f+NwACwxjglHIQ5DNGqoxxLNLTwRZt+1TN4W0+Hdix7t5Mm02 ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tjudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 08:44:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29370T9h016451;
        Mon, 3 Oct 2022 08:44:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc02wyw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 08:44:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2938i4Ww013971;
        Mon, 3 Oct 2022 08:44:10 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3jxc02wytx-2;
        Mon, 03 Oct 2022 08:44:10 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com, george.kennedy@oracle.com,
        darren.kenny@oracle.com, vegard.nossum@oracle.com,
        stable@vger.kernel.org, Alexander Popov <alex.popov@linux.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 1/1] i2c: dev: prevent ZERO_SIZE_PTR deref in i2cdev_ioctl_rdwr()
Date:   Mon,  3 Oct 2022 01:43:46 -0700
Message-Id: <20221003084346.4652-2-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221003084346.4652-1-harshit.m.mogalapalli@oracle.com>
References: <20221003084346.4652-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030052
X-Proofpoint-ORIG-GUID: _5Ao6HVwkMCQhxOc4KPnJ6ZfJWTktOB4
X-Proofpoint-GUID: _5Ao6HVwkMCQhxOc4KPnJ6ZfJWTktOB4
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

From: Alexander Popov <alex.popov@linux.com>

commit 23a27722b5292ef0b27403c87a109feea8296a5c upstream.

i2cdev_ioctl_rdwr() allocates i2c_msg.buf using memdup_user(), which
returns ZERO_SIZE_PTR if i2c_msg.len is zero.

Currently i2cdev_ioctl_rdwr() always dereferences the buf pointer in case
of I2C_M_RD | I2C_M_RECV_LEN transfer. That causes a kernel oops in
case of zero len.

Let's check the len against zero before dereferencing buf pointer.

This issue was triggered by syzkaller.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[wsa: use '< 1' instead of '!' for easier readability]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[Harshit: backport to 4.14.y, use rdwr_pa[i].len instead of msgs[i].len
as the 4.14.y  code uses rdwr_pa.]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
 Conflicts:
	drivers/i2c/i2c-dev.c - use rdwr_pa[i].len instead of
	msgs[i].len
Since a NULL pointer dereference happens on 4.14.y this backport patch
will fix the issue.
---
 drivers/i2c/i2c-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index b7f9fb00f695..08aff5ebc99a 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -297,7 +297,7 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		 */
 		if (rdwr_pa[i].flags & I2C_M_RECV_LEN) {
 			if (!(rdwr_pa[i].flags & I2C_M_RD) ||
-			    rdwr_pa[i].buf[0] < 1 ||
+			    rdwr_pa[i].len < 1 || rdwr_pa[i].buf[0] < 1 ||
 			    rdwr_pa[i].len < rdwr_pa[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
 				i++;
-- 
2.37.1

