Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD98D66464F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjAJQlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbjAJQlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:41:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED10825CA;
        Tue, 10 Jan 2023 08:41:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AGDQO3011416;
        Tue, 10 Jan 2023 16:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=f+ZiSxSYIGDsBpu3KVLkv2Tip7lmyPNI8cSaAfTSWQE=;
 b=GHkLlOYQNfTcMFNZLGlzC1V0h7crFLYmnLsBSFYjiZSah6bevtIJ0A4ic8lgwkiEfCfP
 +w7sy+GpPr3EceQ/3ApwqUl2oq5O3Ccldw0eRA/VfFeUcom1d2IcsHB1y42IYx+1SGpj
 8uIHiMX+OPorVJKh9xzNfXfy70HrlHzbyfSBJe4DXslVPJxyYpnVvpRBXBUObVSoBMPl
 D3AIK65dKs8qVdsuigTM1isinQrRbQB1wPBMIwQIwA60s6z+nPuwa4Q3edMT5/a1ww7c
 mGs/l5KRbORaNJ8Q9fbxhTycJJYmGl1J/VeK6TgAUxeKo4zC8eTfFsL6GHDTNPvDKwrh vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1au1g5nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:40:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AG8g0l008188;
        Tue, 10 Jan 2023 16:40:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1a43e3wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:40:54 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AGYWHE011905;
        Tue, 10 Jan 2023 16:40:54 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n1a43e3vy-1;
        Tue, 10 Jan 2023 16:40:54 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, harshit.m.mogalapalli@oracle.com,
        error27@gmail.com, darren.kenny@oracle.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5.10.y] io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()
Date:   Tue, 10 Jan 2023 08:40:43 -0800
Message-Id: <20230110164044.755234-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100105
X-Proofpoint-ORIG-GUID: -QehMCJaFJPhNNGSZSlaHboOl3q9GtTL
X-Proofpoint-GUID: -QehMCJaFJPhNNGSZSlaHboOl3q9GtTL
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

Smatch warning: io_fixup_rw_res() warn:
	unsigned 'res' is never less than zero.

Change type of 'res' from unsigned to long.

Fixes: 788d0824269b ("io_uring: import 5.15-stable io_uring")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Note: The Fixes commit is a 5.15 to 5.10 backport, the commit which
this patch actually Fixes in 5.15 is d6b7efc722a2
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 945faf036ad0..0c4d16afb9ef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2702,7 +2702,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 
-- 
2.38.1

