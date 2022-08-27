Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B25A341D
	for <lists+stable@lfdr.de>; Sat, 27 Aug 2022 05:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiH0DPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 23:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiH0DPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 23:15:47 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D972026547;
        Fri, 26 Aug 2022 20:15:41 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27R31i2F003736;
        Sat, 27 Aug 2022 03:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=DkYKDBl6yZONQWm6+yJ7qa93tm2iuOH4EPhdHyuyziQ=;
 b=oz9zRB0gzsbjru2k5R35iSm3JnE3TDX+W9/xOEcIWl06wH40kkv2CmgK7dQX8rGHCOu1
 UKSDZTTAGoFD/ptQI6sNyTrLbsoPGrQRY4fECLH9Az15tf+F//KCr6NVA5EVD1yOYkde
 x9zFEgfinKyaCiKEtag0Ih/AY6XQIiMrPna1YnKmsNg10FIN7F+WR64S6n/PxTA3n1Da
 HPjFdLJCcMqTUtCN72V5xsJztJPb6PNOyMOC3SlLg3uK0qU02hf37QodIPyto9Li2MlP
 Njyat6iiWWsUlZejB2ZlyeiHsCv6Fv2R4ELz87iO2GLC4rNDbW/F9GWTi7Yoh68hgTrG 5w== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3j78murkhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Aug 2022 03:15:28 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 27R3FQVE027633
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 27 Aug 2022 03:15:26 GMT
Received: from hu-kriskura-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 26 Aug 2022 20:15:23 -0700
From:   Krishna Kurapati <quic_kriskura@quicinc.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Maxim Devaev <mdevaev@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_jackp@quicinc.com>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS
Date:   Sat, 27 Aug 2022 08:45:10 +0530
Message-ID: <1661570110-19127-1-git-send-email-quic_kriskura@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: NEoMPlLzwx-h7FH-L-N8pIUAsxiX6RLc
X-Proofpoint-ORIG-GUID: NEoMPlLzwx-h7FH-L-N8pIUAsxiX6RLc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_14,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=320 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208270012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During cdrom emulation, the response to read_toc command must contain
the cdrom address as the number of sectors (2048 byte sized blocks)
represented either as an absolute value (when MSF bit is '0') or in
terms of PMin/PSec/PFrame (when MSF bit is set to '1'). Incase of
cdrom, the fsg_lun_open call sets the sector size to 2048 bytes.

When MAC OS sends a read_toc request with MSF set to '1', the
store_cdrom_address assumes that the address being provided is the
LUN size represented in 512 byte sized blocks instead of 2048. It
tries to modify the address further to convert it to 2048 byte sized
blocks and store it in MSF format. This results in data transfer
failures as the cdrom address being provided in the read_toc response
is incorrect.

Fixes: 3f565a363cee ("usb: gadget: storage: adapt logic block size to bound block devices")
Cc: stable@vger.kernel.org
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/function/storage_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index 03035db..208c6a9 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -294,8 +294,10 @@ EXPORT_SYMBOL_GPL(fsg_lun_fsync_sub);
 void store_cdrom_address(u8 *dest, int msf, u32 addr)
 {
 	if (msf) {
-		/* Convert to Minutes-Seconds-Frames */
-		addr >>= 2;		/* Convert to 2048-byte frames */
+		/*
+		 * Convert to Minutes-Seconds-Frames.
+		 * Sector size is already set to 2048 bytes.
+		 */
 		addr += 2*75;		/* Lead-in occupies 2 seconds */
 		dest[3] = addr % 75;	/* Frames */
 		addr /= 75;
-- 
2.7.4

