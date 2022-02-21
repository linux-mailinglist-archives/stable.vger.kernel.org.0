Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00424BE7FE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348043AbiBUJKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347869AbiBUJJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B290DFF3;
        Mon, 21 Feb 2022 01:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBA85B80EB3;
        Mon, 21 Feb 2022 09:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA257C340E9;
        Mon, 21 Feb 2022 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434112;
        bh=ZuE/Z/bq3S+9y920nyWf42fUMdYekNAaXDde+xO2nPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WD4tuGIOEPkD7Ubw5hVU24o8Sn+kKOLVSjviY1+vKC/4gXccvH0DOI6MyR1yeZFX0
         aTcxZt1nxWtHc4b6xkG4w7KGNfIPcs3I6Rxw+UmZE8FrTTWQVB8tmsqVVWMxsEw9F/
         PeXgmFVoMfYcW6VG9waC1aZXPIckeJDrrXvCt3Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Purna Pavan Chandra Aekkaladevi <paekkaladevi@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.10 017/121] PCI: hv: Fix NUMA node assignment when kernel boots with custom NUMA topology
Date:   Mon, 21 Feb 2022 09:48:29 +0100
Message-Id: <20220221084921.732987240@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
@@ -1841,8 +1841,17 @@ static void hv_pci_assign_numa_node(stru
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


