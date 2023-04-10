Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653376DC8DA
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjDJP7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDJP7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:59:04 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57910B0;
        Mon, 10 Apr 2023 08:58:47 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AAMUiO024759;
        Mon, 10 Apr 2023 15:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=mmcyLRiBJx9gAHhptPzkuDIDBuac3B3MBef4hnojS2M=;
 b=WhihGZkGRgs5ztarMq+wh4Wo2nvZV84EB3c0t6m5YsR5xAtmW4FsogpDcVUfY8P5as0x
 E18UHmKWrs1MeE4v6jeKpo1/jKRX27Q8PjfvIae5K7L+Q3VOdL5VG+0H1UjpC4a+bY5V
 Zv3swp/FK827evhJtdgnxDHGU2GUxV2GKWuhUm2/jSGhEr56vnACACa+kp2MG3OvbaRN
 KjMnarNQAODo6EM+hEOywUUgZO0BvQ1Ln3aOfK6dg2IP1+A9IEGuFXbYQoUCytnHsCqP
 l4N39n4KMggSGrS02banNVBy1BJ/vUbeCqGWQTVKKkDYoi1N4j+DNbHoB+hNgEzbe6xa lA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pu0c33bf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 15:58:37 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33AFwaHm015262
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 15:58:36 GMT
Received: from jhugo-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 10 Apr 2023 08:58:36 -0700
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
To:     <mani@kernel.org>
CC:     <mhi@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] bus: mhi: host: Remove duplicate ee check for syserr
Date:   Mon, 10 Apr 2023 09:58:11 -0600
Message-ID: <1681142292-27571-2-git-send-email-quic_jhugo@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681142292-27571-1-git-send-email-quic_jhugo@quicinc.com>
References: <1681142292-27571-1-git-send-email-quic_jhugo@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 6ESPAp2ed3QSNIlH3WOqeug9W06acyNm
X-Proofpoint-ORIG-GUID: 6ESPAp2ed3QSNIlH3WOqeug9W06acyNm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_11,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100135
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we detect a system error via intvec, we only process the syserr if the
current ee is different than the last observed ee.  The reason for this
check is to prevent bhie from running multiple times, but with the single
queue handling syserr, that is not possible.

The check can cause an issue with device recovery.  If PBL loads a bad SBL
via BHI, but that SBL hangs before notifying the host of an ee change,
then issuing soc_reset to crash the device and retry (after supplying a
fixed SBL) will not recover the device as the host will observe a PBL->PBL
transition and not process the syserr.  The device will be stuck until
either the driver is reloaded, or the host is rebooted.  Instead, remove
the check so that we can attempt to recover the device.

Fixes: ef2126c4e2ea ("bus: mhi: core: Process execution environment changes serially")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
 drivers/bus/mhi/host/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index 4fa0969..3a08518 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -503,7 +503,7 @@ irqreturn_t mhi_intvec_threaded_handler(int irq_number, void *priv)
 	}
 	write_unlock_irq(&mhi_cntrl->pm_lock);
 
-	if (pm_state != MHI_PM_SYS_ERR_DETECT || ee == mhi_cntrl->ee)
+	if (pm_state != MHI_PM_SYS_ERR_DETECT)
 		goto exit_intvec;
 
 	switch (ee) {
-- 
2.7.4

