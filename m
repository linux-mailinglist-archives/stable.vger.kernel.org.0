Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876968AEF5
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 10:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjBEJKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 04:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBEJKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 04:10:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744871F5C5
        for <stable@vger.kernel.org>; Sun,  5 Feb 2023 01:09:59 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3152aKZQ009959;
        Sun, 5 Feb 2023 09:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=Yu6OyVSki/HxPIsjC42Q2P5KumLjXQThfXqInybNxl4=;
 b=kK0lm6pMoajCo7PGGr6okr4N36GsiedsnLEcrvA0loEUGUIJvKhclab7Xhs3RE6G9Gz5
 rN+4ps7kD2HwfUNZM877UvQKSCN9O5aJ+DguPRDPwKrGvry+GE1JLU5Wg+jLOH6113CU
 uzsYdLKZfwfY1B+i4dUg1aM30DXE4sLYOHZmQOfk/fo3IUHvpynkZ51SK/YjpVKiInAH
 vpK3sYhMo24xOHydrVi3I/nU56UmO3bpN4vE2cRh2GmsQhdxfuddri3Bw145G4OxENy3
 6fW2CXHYZWPRq387pMfwtRbomrsQgHXwVuN4rRwZnicGceSj0e0b9QxNgyIj74TOGwoO Pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8a149k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Feb 2023 09:09:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3154SXgH037008;
        Sun, 5 Feb 2023 09:09:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt97h6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 05 Feb 2023 09:09:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31599Y1F035762;
        Sun, 5 Feb 2023 09:09:34 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3nhdt97h6d-1;
        Sun, 05 Feb 2023 09:09:33 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     stable@vger.kernel.org
Cc:     zhangxiaoxu5@huawei.com, anna.schumaker@netapp.com,
        trond.myklebust@hammerspace.com, chuck.lever@oracle.com,
        vegard.nossum@oracle.com, error27@gmail.com,
        darren.kenny@oracle.com, gregkh@linuxfoundation.org,
        sashal@kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4.y] xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
Date:   Sun,  5 Feb 2023 01:09:13 -0800
Message-Id: <20230205090913.1629173-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-05_03,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302050081
X-Proofpoint-ORIG-GUID: 0U0Bk7VyDV5BuUP2mW1mQiKnvjT7GQEQ
X-Proofpoint-GUID: 0U0Bk7VyDV5BuUP2mW1mQiKnvjT7GQEQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 upstream.

If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
to free the send buffer, otherwise, the buffer data will be leaked.

Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[Harshit: Backport to 5.4.y]
Also make the same change for 'req->rl_rdmabuf' at the same time as
this will also have the same memory leak problem as 'req->rl_sendbuf'
(This is because commit b78de1dca00376aaba7a58bb5fe21c1606524abe is not
in 5.4.y)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Conflict resolution: Replace kfree(req->rl_sendbuf) with the correct free
function rpcrdma_regbuf_free(req->rl_sendbuf) in out4 label.

Testing: Only compile and boot tested.
Thanks to Vegard for pointing out the similar problem with
'req->rl_rdmabuf'

Previously the backport had some problems and was reverted [1]
[1] https://lore.kernel.org/all/20230203101029.850099165@linuxfoundation.org/
---
 net/sunrpc/xprtrdma/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 0f4d39fdb48f..cfae1a871578 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1034,9 +1034,9 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
 	return req;
 
 out4:
-	kfree(req->rl_sendbuf);
+	rpcrdma_regbuf_free(req->rl_sendbuf);
 out3:
-	kfree(req->rl_rdmabuf);
+	rpcrdma_regbuf_free(req->rl_rdmabuf);
 out2:
 	kfree(req);
 out1:
-- 
2.31.1

