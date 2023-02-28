Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4FF6A588D
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 12:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjB1LuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 06:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjB1LuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 06:50:09 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6229E1F481;
        Tue, 28 Feb 2023 03:50:08 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31S6Vr8P024430;
        Tue, 28 Feb 2023 11:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=RiKQxet1aV+aN1dp0TU54EAcebB+HyrH3HYWI54gMSk=;
 b=My3zBjawpEp2W4HaP/3TCGFoH3c4bIEkmg6BgoNEtFQh5ecHJVL6qM//eawnKZsuTl9M
 fsSDWAckTsxk2NHJsKOyTaLnF6cY2Q1kfYT399/P9pujmgzyjL9+qjU+dYlwmX2vdt0x
 PrP0Oj1G0qtZtE/IyE5rt6ShFDWJCKUhCTVVJThbahZUE/nrCeqwFmnVpXBhLqSsNuLA
 VqvidQm6nk7ZHsB2JNMmQU20gmCuKnS/lFr7kjPCfQu7y2zY35nho0ywlXEY06vWHT5V
 SUZPgPfZmw+x4wewfhWC6O1z3/XGvVWtDtdhOsaMrtF4mUiV6fzcsL3PUj+OLSk4vPlv gg== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3p1ccxgtb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 11:49:25 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 31SBnEW4004703;
        Tue, 28 Feb 2023 11:49:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3nybdkeaxb-1;
        Tue, 28 Feb 2023 11:49:21 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SBnLcE006237;
        Tue, 28 Feb 2023 11:49:21 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-krichai-hyd.qualcomm.com [10.213.110.37])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 31SBnKX5006167;
        Tue, 28 Feb 2023 11:49:21 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 4058933)
        id F027547B9; Tue, 28 Feb 2023 17:19:19 +0530 (+0530)
From:   Krishna chaitanya chundru <quic_krichai@quicinc.com>
To:     helgaas@kernel.org
Cc:     linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mka@chromium.org,
        quic_vbadigan@quicinc.com, quic_hemantk@quicinc.com,
        quic_nitegupt@quicinc.com, quic_skananth@quicinc.com,
        quic_ramkri@quicinc.com, manivannan.sadhasivam@linaro.org,
        swboyd@chromium.org, dmitry.baryshkov@linaro.org,
        svarbanov@mm-sol.com, agross@kernel.org, andersson@kernel.org,
        konrad.dybcio@somainline.org, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com,
        linux-phy@lists.infradead.org, vkoul@kernel.org, kishon@ti.com,
        mturquette@baylibre.com, linux-clk@vger.kernel.org,
        Krishna chaitanya chundru <quic_krichai@quicinc.com>,
        stable@vger.kernel.org, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Prasad Malisetty <pmaliset@codeaurora.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH V2] arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent
Date:   Tue, 28 Feb 2023 17:19:12 +0530
Message-Id: <1677584952-17496-1-git-send-email-quic_krichai@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: PJJOU_hZapybQxqINK46QQuT9oKQlc8V
X-Proofpoint-ORIG-GUID: PJJOU_hZapybQxqINK46QQuT9oKQlc8V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-28_07,2023-02-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 clxscore=1011 mlxlogscore=656 bulkscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280094
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the controller is not marked as cache coherent, then kernel will
try to ensure coherency during dma-ops and that may cause data corruption.
So, mark the PCIe node as dma-coherent as the devices on PCIe bus are
cache coherent.

Cc: stable@vger.kernel.org
Fixes: 92e0ee9f83b3 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related node")
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
---

changes since v1:
	- Updated the commit text.
---
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index bdcb749..8f4ab6b 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2131,6 +2131,8 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_clkreq_n>;
 
+			dma-coherent;
+
 			iommus = <&apps_smmu 0x1c80 0x1>;
 
 			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-- 
2.7.4

