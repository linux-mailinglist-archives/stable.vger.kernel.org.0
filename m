Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4A4BE852
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348611AbiBUJWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350002AbiBUJV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53A537003;
        Mon, 21 Feb 2022 01:09:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7253A6077B;
        Mon, 21 Feb 2022 09:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C8CC340E9;
        Mon, 21 Feb 2022 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434560;
        bh=Vz4WDZtoUOzAcf9QAL9mQykts41Q8Xh0KlaY1mwEN2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ7NzSrQaDEyJflxgDs0y9W3BFlRrnnoqU6tW9vw9rV2DFiRLYi73d9S43pCqkbhB
         5W4ST+dMiU2+04+ib6yuB3ec1hcGAeR6lCsBjdpJ1TcqhXQRo8zNFNDLxAK5ebV6k8
         LwvQOCK3Lq0SMQ4XwW5TvkCS5C1P/7u/TnS6YRTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Purna Pavan Chandra Aekkaladevi <paekkaladevi@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 018/196] PCI: hv: Fix NUMA node assignment when kernel boots with custom NUMA topology
Date:   Mon, 21 Feb 2022 09:47:30 +0100
Message-Id: <20220221084931.498848452@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit 3149efcdf2c6314420c418dfc94de53bfd076b1f upstream.

When kernel boots with a NUMA topology with some NUMA nodes offline, the PCI
driver should only set an online NUMA node on the device. This can happen
during KDUMP where some NUMA nodes are not made online by the KDUMP kernel.

This patch also fixes the case where kernel is booting with "numa=off".

Fixes: 999dd956d838 ("PCI: hv: Add support for protocol 1.3 and support PCI_BUS_RELATIONS2")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Purna Pavan Chandra Aekkaladevi <paekkaladevi@microsoft.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/1643247814-15184-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1899,8 +1899,17 @@ static void hv_pci_assign_numa_node(stru
 		if (!hv_dev)
 			continue;
 
-		if (hv_dev->desc.flags & HV_PCI_DEVICE_FLAG_NUMA_AFFINITY)
-			set_dev_node(&dev->dev, hv_dev->desc.virtual_numa_node);
+		if (hv_dev->desc.flags & HV_PCI_DEVICE_FLAG_NUMA_AFFINITY &&
+		    hv_dev->desc.virtual_numa_node < num_possible_nodes())
+			/*
+			 * The kernel may boot with some NUMA nodes offline
+			 * (e.g. in a KDUMP kernel) or with NUMA disabled via
+			 * "numa=off". In those cases, adjust the host provided
+			 * NUMA node to a valid NUMA node used by the kernel.
+			 */
+			set_dev_node(&dev->dev,
+				     numa_map_to_online_node(
+					     hv_dev->desc.virtual_numa_node));
 
 		put_pcichild(hv_dev);
 	}


