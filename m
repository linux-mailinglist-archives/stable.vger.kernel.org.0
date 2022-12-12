Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADF64A06E
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLLNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiLLNYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:24:51 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0615F90;
        Mon, 12 Dec 2022 05:24:49 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCCx1iV002490;
        Mon, 12 Dec 2022 13:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=91cpds4v69UzBBGb1l3cLOexQaCW6Fg6qXLj+1lY1nQ=;
 b=mrkSTDNyN69Vam0+Uc+EwDMRxr341Js4lwPeE4dmDMypicevmXAseEvfDtmrC7RKb8ps
 ltRqeoJxfKRZUJS4FxW1vTS48WVPwHDxetyHwrBWtG1xrOmIikRq1c7XrE7eQqUZGW83
 3+CWVOxziw5wJl7sKhSBC/WPighui6XktoHu59lZKCdq02rmM5oBWAL3YfKs7xF5tUAx
 XAwevaKzmMlo38uuuoxm7XItr4ypDURQANwoR7E9swDhuNBiypaexFyxCGMvh2vczMP/
 0GiPQEJPfvq3y/OG9Ii1klGDAP9ACrlYLuI6DmH9YVOUXYnJi1SC2N6lFKrKjo2b/rz6 Ag== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mchesc7dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 13:24:34 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BCDOX4q004025
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 13:24:33 GMT
Received: from hu-prashk-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 12 Dec 2022 05:24:29 -0800
From:   Prashanth K <quic_prashk@quicinc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        "Dan Carpenter" <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>
CC:     <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>,
        Prashanth K <quic_prashk@quicinc.com>
Subject: usb: f_fs: Fix CFI failure in ki_complete
Date:   Mon, 12 Dec 2022 18:54:24 +0530
Message-ID: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: z2Ie-FTzCK62ZzaEgSBQhZSQ3M8w3Z81
X-Proofpoint-GUID: z2Ie-FTzCK62ZzaEgSBQhZSQ3M8w3Z81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=607 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function pointer ki_complete() expects 'long' as its second
argument, but we pass integer from ffs_user_copy_worker. This
might cause a CFI failure, as ki_complete is an indirect call
with mismatched prototype. Fix this by typecasting the second
argument to long.

Cc: <stable@vger.kernel.org> # 5.15
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>

---
 drivers/usb/gadget/function/f_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 73dc10a7..9c26561 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -835,7 +835,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
 		kthread_unuse_mm(io_data->mm);
 	}
 
-	io_data->kiocb->ki_complete(io_data->kiocb, ret);
+	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);
 
 	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
 		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
-- 
2.7.4

