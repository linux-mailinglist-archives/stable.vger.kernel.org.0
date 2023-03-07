Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EC46AEFA0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjCGSY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjCGSYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD39499C28
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B97861501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4246BC433EF;
        Tue,  7 Mar 2023 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213192;
        bh=+4qa1cRGyKcj6Rvb0jubXyaq45q0+Q7ELXHfVA1gV4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCPOLA8LyA1z7OQHndgPisZyaKnd7OuEgvmNKtfHaLNABsYsNXoEkW25Yx/D/K3sl
         VvSghKNkcfe4cJmRHYkN6xtcblhmqPTVov55DlwmoFbcM4gtwD++5z6DABVaXKKw3c
         NvmZDQLXklRKOjzS0q/zC4DGlqtTdKfWTxRwsW1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yicong Yang <yangyicong@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 428/885] hwtracing: hisi_ptt: Only add the supported devices to the filters list
Date:   Tue,  7 Mar 2023 17:56:02 +0100
Message-Id: <20230307170021.008473012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit b8d976c7d41a28c0fccf22c7113be9a29dc07e5c ]

The PTT device can only support the devices on the same PCIe core,
within BDF range [lower_bdf, upper_bdf]. It's not correct to assume
the devices on the root bus are from the same PCIe core, there are
cases that root ports from different PCIe core are sharing the same
bus. So check when initializing the filters list.

Fixes: ff0de066b463 ("hwtracing: hisi_ptt: Add trace function support for HiSilicon PCIe Tune and Trace device")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230112112201.16283-1-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index 5d5526aa60c40..30f1525639b57 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -356,8 +356,18 @@ static int hisi_ptt_register_irq(struct hisi_ptt *hisi_ptt)
 
 static int hisi_ptt_init_filters(struct pci_dev *pdev, void *data)
 {
+	struct pci_dev *root_port = pcie_find_root_port(pdev);
 	struct hisi_ptt_filter_desc *filter;
 	struct hisi_ptt *hisi_ptt = data;
+	u32 port_devid;
+
+	if (!root_port)
+		return 0;
+
+	port_devid = PCI_DEVID(root_port->bus->number, root_port->devfn);
+	if (port_devid < hisi_ptt->lower_bdf ||
+	    port_devid > hisi_ptt->upper_bdf)
+		return 0;
 
 	/*
 	 * We won't fail the probe if filter allocation failed here. The filters
-- 
2.39.2



