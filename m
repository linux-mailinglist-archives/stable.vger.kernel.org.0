Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E18601747
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiJQTUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiJQTUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:20:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAC076765;
        Mon, 17 Oct 2022 12:20:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HITLld026790;
        Mon, 17 Oct 2022 19:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=lsHbolG0UmSy55V8F7V+ni/Cjto00pDK8F+j9k18zVo=;
 b=giOy2bBj1mWTtkcC2aWQQyGfv6ikhSOxglqWMlnplrj35A3NkEgly7tYgMTKO3FMfUJL
 tDU0/yVU9EMT/rlRJdpEXo2uuIwqDAgT7wsftlMFITdHCmsDQGWpOkumoFfYbF0JVWSK
 ThLsfV6ZZgX0hqKfkjGZIakjhdzuHGrHke+4PeKXc61b5pk708XkpQfXKpdkYVn/JoAl
 tL6ixJKcnhde/0PkrkZjqTAeZSgx3G1nRHZAx+ydDeVQVn+V/w/8DL8JzWq2op9NXqrQ
 kwk+Y4WrM6AfqOlykYeboa+lPB9kEMBu+4xhlkQ83CXrpvKH10S1bjKb5XBSCnMGcfBe cA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7sga5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HHaCIQ036466;
        Mon, 17 Oct 2022 19:20:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htf4axt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 19:20:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29HJKCYt007860;
        Mon, 17 Oct 2022 19:20:36 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htf4abs-4;
        Mon, 17 Oct 2022 19:20:36 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH stable 3/5] dma-buf: remove useless FMODE_LSEEK flag
Date:   Mon, 17 Oct 2022 12:20:04 -0700
Message-Id: <20221017192006.36398-4-saeed.mirzamohammadi@oracle.com>
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
X-Proofpoint-GUID: IfQwHx-IBwVlW4UHk92EIGqK_UGIMkmr
X-Proofpoint-ORIG-GUID: IfQwHx-IBwVlW4UHk92EIGqK_UGIMkmr
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

This is already set by anon_inode_getfile(), since dma_buf_fops has
non-NULL ->llseek, so we don't need to set it here too.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit c9eb2d427c1c428e4f4e29f1e635b9a83236c015)
Cc: stable@vger.kernel.org
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 drivers/dma-buf/dma-buf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 968c3df2810e..3c3d0e2258b4 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -584,7 +584,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		goto err_dmabuf;
 	}
 
-	file->f_mode |= FMODE_LSEEK;
 	dmabuf->file = file;
 
 	mutex_init(&dmabuf->lock);
-- 
2.31.1

