Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204076894D1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjBCKLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjBCKLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:11:20 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F57F8F276;
        Fri,  3 Feb 2023 02:11:17 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31384jmn031810;
        Fri, 3 Feb 2023 10:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=Bi8WJKE5y537khIPPrNVdQZFE2iyZCYf2LUJHrDVH8A=;
 b=D1DQsTUKf0pNJOLSP3YB0MmuQ0YGR+3SwKeyh92IahnS9n5zUkMtac+YJ4/zmDsfrqL4
 ZF3RAiefur4izxJRYhyLazV3PrJ9Xo5kcj54S5AQc9cljiDdcUDG69t+TxfDIrFXsEc4
 apuKKIX/QYlqNuei9u7UcQSrDJ6vXakhzX0ArBYBOiC+5Im0NeChQgbOQewcsWQ/P2WY
 PhSp4oWAqRX4OvBo3oIVInDajrAqs4iUDnWTExnoo92z4u9joXHVE4C+rAUSbKYxvjWI
 sTlfkTlLxJ1SbIV82M1C9N6XV+MPQyWvPDJ40TEf9YdaxRWEOFlllPLqgwDgIcPUb4jt tw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ngxedg845-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 10:11:15 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 313ABDGa017536
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 3 Feb 2023 10:11:14 GMT
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 3 Feb 2023 02:11:11 -0800
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        "Pratham Pratap" <quic_ppratap@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH] usb: roles: disable pm for role switch device
Date:   Fri, 3 Feb 2023 18:10:59 +0800
Message-ID: <1675419059-30078-1-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Zikuaxr7poYzE1J-fpzHS07SJFRW77DV
X-Proofpoint-ORIG-GUID: Zikuaxr7poYzE1J-fpzHS07SJFRW77DV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_06,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=608
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030093
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

there is no PM operation for a role switch device,
call device_set_pm_not_required() in usb_role_switch_register() to disable.

Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
---
 drivers/usb/roles/class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/roles/class.c b/drivers/usb/roles/class.c
index eacb46e..b303c64 100644
--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -344,6 +344,7 @@ usb_role_switch_register(struct device *parent,
 	dev_set_drvdata(&sw->dev, desc->driver_data);
 	dev_set_name(&sw->dev, "%s-role-switch",
 		     desc->name ? desc->name : dev_name(parent));
+	device_set_pm_not_required(&sw->dev);
 
 	ret = device_register(&sw->dev);
 	if (ret) {
-- 
2.7.4

