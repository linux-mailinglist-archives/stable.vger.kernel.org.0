Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D2576888
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 22:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiGOUwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 16:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiGOUwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 16:52:31 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7438958850
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657918350; x=1689454350;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LjfmSWVaC5Q24qGJJ7Ze7Lew5a8Ndikvo2LAK9xKsgw=;
  b=ON65NIjItm/uiVE+vLTCkl8hu6rR2dpRgr/YBUfo4hj+9SvPpX9hWBOm
   Tk9Vv/3EUV+rYIUPpDzchs+TGp30SMhzNvqA1qn2K2j2efnMQRYxXXYIV
   GsprcIGyB8nhLqbGPpVd4AZd/AyWMfF504a+fqydg/OXuvniMphvzrRpf
   s=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 15 Jul 2022 13:52:30 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:52:30 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:52:29 -0700
Received: from ubuntuvm.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Jul 2022 13:52:28 -0700
From:   Carl Vanderlip <quic_carlv@quicinc.com>
To:     <stable@vger.kernel.org>
CC:     Carl Vanderlip <quic_carlv@quicinc.com>, <quic_jhugo@quicinc.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>,
        <sthemmin@microsoft.com>, <wei.liu@microsoft.com>,
        <decui@microsoft.com>, <lorenzo.pieralisi@arm.com>,
        <robh@kernel.org>, <kw@linux.com>, <bhelgaas@google.com>
Subject: [PATCH 5.10 0/4] PCI: hv: Fix multi-MSI and IRTE allocation 
Date:   Fri, 15 Jul 2022 20:52:06 +0000
Message-ID: <20220715205210.18544-1-quic_carlv@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Tested on 5.10.130

Jeffrey Hugo (4):
  PCI: hv: Fix multi-MSI to allow more than one MSI vector
  PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI
  PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()
  PCI: hv: Fix interrupt mapping for multi-MSI

 drivers/pci/controller/pci-hyperv.c | 99 +++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 26 deletions(-)

-- 
2.25.1

