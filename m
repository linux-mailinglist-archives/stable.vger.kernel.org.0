Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9649F6A87D9
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 18:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCBR0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 12:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCBR0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 12:26:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5740A144A5;
        Thu,  2 Mar 2023 09:26:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322HMqiV005297;
        Thu, 2 Mar 2023 17:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=duVuGMJ6mjnbG5pUBrj8hfH0ansC8Tke4ABr53RLcFM=;
 b=auAIa72O+zUgIFU2SOKptzCX3+W7hBXUoybp+3UA9Dz/beZKQ7ytHoA+P00/IGTUTubO
 pfZImha8nQTEsQX89Ym3y9Iyu+9nQnmnLJi9cKrpdFIjutHQXL09vy9JDeDR4yNaCjqt
 XEW6Uv4GjbSl19wIH7b7wz5g2kfZ0ULoQ82W76OMUocxd47vOdO4o0VjThFe3P7CzQv/
 6Njdq+mshc6zZLBdQgBzX7XE9caR3jigHUXFoSdo54GKoDx/RhHcSGIAYjPGtDPUyzlW
 znNxAuIksQGqDCF9yaBhIS91eVsWOX0hJExGK6hWPbooFrlhYZtLWWnl0RMVNe4XgAQx QQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7mdme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:25:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 322H6nxj031358;
        Thu, 2 Mar 2023 17:25:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sh65j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:25:42 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 322HPgJx015722;
        Thu, 2 Mar 2023 17:25:42 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ny8sh65gk-1;
        Thu, 02 Mar 2023 17:25:41 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     dmitry.osipenko@collabora.com, stable@vger.kernel.org
Cc:     kraxel@redhat.com, linux-kernel@vger.kernel.org,
        emil.l.velikov@gmail.com, airlied@linux.ie, error27@gmail.com,
        darren.kenny@oracle.com, vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15.y] drm/virtio: Fix error code in virtio_gpu_object_shmem_init()
Date:   Thu,  2 Mar 2023 09:25:38 -0800
Message-Id: <20230302172538.3508747-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_11,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020150
X-Proofpoint-ORIG-GUID: CLhbnaHWjzUHuA0webCqum80LvdwqtQO
X-Proofpoint-GUID: CLhbnaHWjzUHuA0webCqum80LvdwqtQO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In virtio_gpu_object_shmem_init() we are passing NULL to PTR_ERR, which
is returning 0/success.

Fix this by storing error value in 'ret' variable before assigning
shmem->pages to NULL.

Found using static analysis with Smatch.

Fixes: 64b88afbd92f ("drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Only compile tested.

Upstream commit b5c9ed70d1a9 ("drm/virtio: Improve DMA API usage for shmem BOs")
deleted this code, so this patch is not necessary in linux-6.1.y and
linux-6.2.y.
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 7e75fb0fc7bd..25d399b00404 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {
-- 
2.31.1

