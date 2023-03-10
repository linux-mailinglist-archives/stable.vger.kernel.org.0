Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7679E6B4362
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbjCJOOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjCJONz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:13:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B125243
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B78BB822DF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A1FC433D2;
        Fri, 10 Mar 2023 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457557;
        bh=dXcICe2xezhgCiSe+T9JiPugcHQjcBDitguDCI9w7Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfWFlA5Egdk3vndLdT99GxBpISjqqhtyie8UAYrvMm6tieEjfnliruddudgBi4LK5
         7GiX4aYxEszGkGhD5zEUkFKDBWcFNw4FWUR3/rLDJV6mbvLP9z/MZf9TlHhlokXwPD
         N3VuzFUPkznudAmquTR8xWMFEoGX9acEcLSP5snM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 179/200] vDPA/ifcvf: decouple config space ops from the adapter
Date:   Fri, 10 Mar 2023 14:39:46 +0100
Message-Id: <20230310133722.596528435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit af8eb69a62b73a2ce5f91575453534ac07f06eb4 upstream.

This commit decopules the config space ops from the
adapter layer, so these functions can be invoked
once the device is probed.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-3-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -10,11 +10,6 @@
 
 #include "ifcvf_base.h"
 
-struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
-{
-	return container_of(hw, struct ifcvf_adapter, vf);
-}
-
 u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
@@ -37,8 +32,6 @@ u16 ifcvf_set_config_vector(struct ifcvf
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
-	struct ifcvf_adapter *ifcvf;
-	struct pci_dev *pdev;
 	u32 length, offset;
 	u8 bar;
 
@@ -46,17 +39,14 @@ static void __iomem *get_cap_addr(struct
 	offset = le32_to_cpu(cap->offset);
 	bar = cap->bar;
 
-	ifcvf= vf_to_adapter(hw);
-	pdev = ifcvf->pdev;
-
 	if (bar >= IFCVF_PCI_MAX_RESOURCE) {
-		IFCVF_DBG(pdev,
+		IFCVF_DBG(hw->pdev,
 			  "Invalid bar number %u to get capabilities\n", bar);
 		return NULL;
 	}
 
-	if (offset + length > pci_resource_len(pdev, bar)) {
-		IFCVF_DBG(pdev,
+	if (offset + length > pci_resource_len(hw->pdev, bar)) {
+		IFCVF_DBG(hw->pdev,
 			  "offset(%u) + len(%u) overflows bar%u's capability\n",
 			  offset, length, bar);
 		return NULL;
@@ -92,6 +82,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, s
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
+	hw->pdev = pdev;
 
 	while (pos) {
 		ret = ifcvf_read_config_range(pdev, (u32 *)&cap,
@@ -230,13 +221,11 @@ int ifcvf_verify_min_features(struct ifc
 
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *adapter;
 	u32 net_config_size = sizeof(struct virtio_net_config);
 	u32 blk_config_size = sizeof(struct virtio_blk_config);
 	u32 cap_size = hw->cap_dev_config_size;
 	u32 config_size;
 
-	adapter = vf_to_adapter(hw);
 	/* If the onboard device config space size is greater than
 	 * the size of struct virtio_net/blk_config, only the spec
 	 * implementing contents size is returned, this is very
@@ -251,7 +240,7 @@ u32 ifcvf_get_config_size(struct ifcvf_h
 		break;
 	default:
 		config_size = 0;
-		IFCVF_ERR(adapter->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
+		IFCVF_ERR(hw->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
 	}
 
 	return config_size;


