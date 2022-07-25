Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B726B5802C4
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbiGYQeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 12:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiGYQeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 12:34:10 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B551A80F
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:34:09 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PCirVt008257;
        Mon, 25 Jul 2022 16:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=KAUnjo5rBaOqgJlCQRJFUIwbQffL5MJbSKT4cGuhJcs=;
 b=eT7hvQIGb9bCOe8n8AxrCpPZi8gfaxyXjJKQeQ6L59pV0IIf8bUctMVAeCt5463uWIYr
 qCx4J1GgtUlTH/onKjC1unXn59vYthVqRcT0M1a73xXwdQqMhl64+ZOcBlc2oSK1sihD
 U/lKwLqz3G13E+KjB5FYuJljjmqePc1cO79scfRuS7A87MXF9YFghQwkFxMrM4AI8V+e
 pJ05XW62NcMQw8RiCRoHTTFxgpiupLJA9PNe97R9PLArV20j/tM1CdTEEj9n+/WZjhVN
 xTjAw8nwLVIWSyjOqZbVuje8aO6UDJau4j2F4/jmutJGhqdZuY0+GJKuB8mM8Ec17e7E UA== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3hhs84h6bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 16:34:00 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.47.97.222])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 26PGXxbv005044
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 16:33:59 GMT
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:59 -0700
Received: from bldr-qrn-hyperv-vm1.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 09:33:58 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Carl Vanderlip <quic_carlv@quicinc.com>, <quic_jhugo@quicinc.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>,
        <sthemmin@microsoft.com>, <wei.liu@microsoft.com>,
        <decui@microsoft.com>, <lorenzo.pieralisi@arm.com>,
        <robh@kernel.org>, <kw@linux.com>, <bhelgaas@google.com>
Subject: [PATCH 4.14 0/4] PCI: hv: Fix multi-MSI and IRTE allocation 
Date:   Mon, 25 Jul 2022 16:33:39 +0000
Message-ID: <20220725163343.13071-1-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: DSBjU1HlxQH9pYQdoDg_SwDruKuOfcF4
X-Proofpoint-GUID: DSBjU1HlxQH9pYQdoDg_SwDruKuOfcF4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_12,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=363 lowpriorityscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207250067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hyper-V driver has advertised support for multi-MSI, but any attempt at
using the feature would fallback to a single MSI (non-starter for
devices that require multi-MSI). The fallback also covered up other
bugs related to multi-MSI functionality rooted in the driver not being
able to tell MSIs apart.

These patches fix those bugs by enabling hv multi-MSI through IOMMU
remapping, distinguishing multi-MSIs from the initial MSI of the MSI
block, preventing retargeting of MSI subsets from invalidating the IRTE
block, and aiding hypervisor to preserve the block of requests.

Tested on 4.14.288

Jeffrey Hugo (4):
  PCI: hv: Fix multi-MSI to allow more than one MSI vector
  PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
  PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
  PCI: hv: Fix interrupt mapping for multi-MSI

 drivers/pci/controller/pci-hyperv.c | 99 +++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 26 deletions(-)

-- 
2.25.1

