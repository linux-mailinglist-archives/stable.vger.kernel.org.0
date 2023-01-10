Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EBC664680
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbjAJQsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbjAJQsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:48:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85600307;
        Tue, 10 Jan 2023 08:46:55 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30AFd6fV016227;
        Tue, 10 Jan 2023 16:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=QJUF0EYLzMOUTI62ymv5S3l0n9U5Ef29yIQZvUvPEj0=;
 b=D7YzUyUo77xU9B66U7UjywNhNOMJAuDpVVffvJ+emeZ0ndDCh6DXAzag2Ler6epuWQ9V
 m6fKIPOHh3dUN3rAMFAc8ni7dSLK5IXsDq3WB2z/d9oXvCsqp4XVjtRMtzlgRSjAISa+
 KzXMzWZhm22nz873MacXa9n+q/TRxstKiVd+eBr8+oIrNoAtcP5XEXLQFfkYcxwdhi06
 X4H1I6T/DmZWG1981eWMeCnuxIUatQI76DZ+hflYNvKojAltg9gpVGrKSzG1l2jZzkH9
 ESs+PA98/X5hiJG6UYe2l8LBhcGGvyYopw5T+Q3km1CqB/ffMYuoARjTWxv9XYR3TIjS CQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btnr7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:46:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30AFmr81004243;
        Tue, 10 Jan 2023 16:46:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1b07ud5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 16:46:53 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30AGkqbe024140;
        Tue, 10 Jan 2023 16:46:52 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n1b07ud3y-1;
        Tue, 10 Jan 2023 16:46:52 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, harshit.m.mogalapalli@oracle.com,
        error27@gmail.com, darren.kenny@oracle.com,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] io_uring: Fix unsigned 'res' comparison with zero in io_fixup_rw_res()
Date:   Tue, 10 Jan 2023 08:46:47 -0800
Message-Id: <20230110164647.755556-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_06,2023-01-10_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100106
X-Proofpoint-GUID: qSilBPErbdW4hvZCtUcok_-SR5N9NO1l
X-Proofpoint-ORIG-GUID: qSilBPErbdW4hvZCtUcok_-SR5N9NO1l
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

Fixes: d6b7efc722a2 ("io_uring/rw: fix error'ed retry return values")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eebbe8a6da0c..fd30c99be07a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 
-- 
2.38.1

