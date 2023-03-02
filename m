Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3B6A87E9
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 18:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCBR2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBR2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 12:28:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D36A3A859;
        Thu,  2 Mar 2023 09:28:28 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322HNOAc016779;
        Thu, 2 Mar 2023 17:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=76hz/LoZrb9hKz2kKw8dK3i0sE3tDLtAmUawebTB45g=;
 b=KhkHkaN+qY8ZQ4jEr3Lb4yDk4DpjRxLQKDInF18W39eb1V5LrLAg7s9GNRHWRSqH2dsw
 nmNQA4ibVP7QxFaWNfvvho5SHSBWkqAAY+hJOnIyKf0wEqlg/Zi0GQzLddQzrcMg8uia
 EetbPO4KZXMZCsGbYu6igddJ6lqHwCZ3tKCmy0qZuQO30PCT+KUT+MTD2TfN86gxao6/
 8MIkQRITakFgvpWALwN9dDCrugJeXsmWx2zvAJWXdG4Y/czhKWm5FQg2tLzV6rlSbmrx
 uLoH3Yv5CzFPZfMQW897ad3SeqYCO9MGuOuHDrTOzyrV3SkZCq3DQU9YpaAYBw/Ug065 MQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wvk4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:28:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 322HBVE4004832;
        Thu, 2 Mar 2023 17:28:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sanysx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:28:19 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 322HR3ls035594;
        Thu, 2 Mar 2023 17:28:19 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ny8sanyry-1;
        Thu, 02 Mar 2023 17:28:19 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     dmitry.osipenko@collabora.com, stable@vger.kernel.org
Cc:     kraxel@redhat.com, linux-kernel@vger.kernel.org,
        emil.l.velikov@gmail.com, airlied@linux.ie, error27@gmail.com,
        gregkh@linuxfoundation.org, darren.kenny@oracle.com,
        vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10.y] drm/virtio: Fix error code in virtio_gpu_object_shmem_init()
Date:   Thu,  2 Mar 2023 09:28:16 -0800
Message-Id: <20230302172816.3508816-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_11,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020150
X-Proofpoint-GUID: wF5R1rrLWcL1sa7LcLRQ-IXNUnEz6a0D
X-Proofpoint-ORIG-GUID: wF5R1rrLWcL1sa7LcLRQ-IXNUnEz6a0D
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
index 168148686001..49fa59e09187 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -159,8 +159,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {
-- 
2.31.1

