Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF8685DC7
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 04:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBADPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 22:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjBADO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 22:14:59 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113D13E0A7;
        Tue, 31 Jan 2023 19:14:59 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3112xAlt007861;
        Wed, 1 Feb 2023 03:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=X/i4geAXJCSCmCU2ceAQk61OzOY2NKNz5rns76c1/UM=;
 b=CbachKjQRaW66FOCQaSW5D41zxwlaIXkYqywni8JxTuDnbGaYdVmd2PIm0yUbHp2t+zK
 Jl0UinCC/z8/JM+MaQu7lTHbgnR4L1rWX8G64DizziozZjBThNEk1+yIrwyAREB+zWkK
 A+Cw/xM1IkieJxNfcQuDutjcotP9Fa8hcbUXgv9yhFmogJ9moYonc7ZKgusjOROVlHgX
 JjT2WJ8hB5q7n79969JIs5/kAlSeGfWUnP9LAIDGG0arWw9JzyFsihfC67ZaxJDIkLk7
 JUKejuWbKejX6NuAGxY28n8zvawm/M0xxxR7IOPqPaYHRc+M/3UvQbog+6JZTw5iDEaf bA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nfbuh0huu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 03:14:57 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3113Eu9T030821
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 1 Feb 2023 03:14:56 GMT
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 31 Jan 2023 19:14:54 -0800
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH] usb: dwc3: update link state when process wakeup interrupt
Date:   Wed, 1 Feb 2023 11:14:46 +0800
Message-ID: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Hc_pgM0MrURUVZs-XZ4PyKYe-qBtIC4S
X-Proofpoint-GUID: Hc_pgM0MrURUVZs-XZ4PyKYe-qBtIC4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 adultscore=0 mlxlogscore=565 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302010024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Consider there is interrpt sequences as suspend (U3) -> wakeup (U0) ->
suspend (U3), as there is no update to link state in wakeup interrupt,
the second suspend interrupt will not report to upper layer.

Fix it by update link state in wakeup interrupt handler.

Cc: stable@vger.kernel.org
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
---
 drivers/usb/dwc3/gadget.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 89dcfac..3533241 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4066,7 +4066,7 @@ static void dwc3_gadget_conndone_interrupt(struct dwc3 *dwc)
 	 */
 }
 
-static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc)
+static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc, unsigned int evtinfo)
 {
 	/*
 	 * TODO take core out of low power mode when that's
@@ -4078,6 +4078,8 @@ static void dwc3_gadget_wakeup_interrupt(struct dwc3 *dwc)
 		dwc->gadget_driver->resume(dwc->gadget);
 		spin_lock(&dwc->lock);
 	}
+
+	dwc->link_state = evtinfo & DWC3_LINK_STATE_MASK;
 }
 
 static void dwc3_gadget_linksts_change_interrupt(struct dwc3 *dwc,
@@ -4227,7 +4229,7 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
 		dwc3_gadget_conndone_interrupt(dwc);
 		break;
 	case DWC3_DEVICE_EVENT_WAKEUP:
-		dwc3_gadget_wakeup_interrupt(dwc);
+		dwc3_gadget_wakeup_interrupt(dwc, event->event_info);
 		break;
 	case DWC3_DEVICE_EVENT_HIBER_REQ:
 		if (dev_WARN_ONCE(dwc->dev, !dwc->has_hibernation,
-- 
2.7.4

