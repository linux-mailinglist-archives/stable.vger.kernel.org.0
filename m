Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330D46B4377
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjCJOOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjCJOOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FD327D53
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCF246193B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A9DC4339C;
        Fri, 10 Mar 2023 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457555;
        bh=n1i3NvaG2SxKt8zwZ2odSSgR4n2nDdNQC0cmgmpIHqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqUKMhE9MVPKpi0ojLu0bRBj+LV5ntSjG8G+vgNFrs2EyeJ6r6uKyAhEv/bq5l/L8
         yhHDLOzh8UrD+iQSviaLNu9JuEg9tAZFfRZEt2FpWlT546FHA3BxtJNzLcd8jyI1qD
         p0ZBcraH9cdC8hCNFq3AJBxlpC0jlDTxmjFgGgC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 178/200] vDPA/ifcvf: decouple hw features manipulators from the adapter
Date:   Fri, 10 Mar 2023 14:39:45 +0100
Message-Id: <20230310133722.568283132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit d59f633dd05940739b5f46f5d4403cafb91d2742 upstream.

This commit gets rid of ifcvf_adapter in hw features related
functions in ifcvf_base. Then these functions are more rubust
and de-coupling from the ifcvf_adapter layer. So these
functions could be invoded once the device is probed, even
before the adapter is allocaed.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-2-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |    9 ++-------
 drivers/vdpa/ifcvf/ifcvf_base.h |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |    1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -220,10 +220,8 @@ u64 ifcvf_get_features(struct ifcvf_hw *
 
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 {
-	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
-
 	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
-		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
+		IFCVF_ERR(hw->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
 		return -EINVAL;
 	}
 
@@ -301,14 +299,11 @@ static void ifcvf_set_features(struct if
 
 static int ifcvf_config_features(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *ifcvf;
-
-	ifcvf = vf_to_adapter(hw);
 	ifcvf_set_features(hw, hw->req_features);
 	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
 
 	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
-		IFCVF_ERR(ifcvf->pdev, "Failed to set FEATURES_OK status\n");
+		IFCVF_ERR(hw->pdev, "Failed to set FEATURES_OK status\n");
 		return -EIO;
 	}
 
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -89,6 +89,7 @@ struct ifcvf_hw {
 	u16 nr_vring;
 	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
 	u32 cap_dev_config_size;
+	struct pci_dev *pdev;
 };
 
 struct ifcvf_adapter {
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -842,6 +842,7 @@ static int ifcvf_probe(struct pci_dev *p
 	vf = &adapter->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
+	vf->pdev = pdev;
 
 	adapter->pdev = pdev;
 	adapter->vdpa.dma_dev = &pdev->dev;


