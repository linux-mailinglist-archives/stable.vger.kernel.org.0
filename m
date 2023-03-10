Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190D96B4276
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjCJODn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCJODM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:03:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF31DEC76
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C33B60D29
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E7FC433D2;
        Fri, 10 Mar 2023 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456990;
        bh=UPqmlEwRSziVrqYgqVNYMyaxL2DbuOy2Dmlzgry/sIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5ljgE5LJKyhATVRhPX7evF0UdAzuhiB15MiVj5C+th8pg5vVXBwCaCjZxFf3j2tA
         a/fGvrfTZsPXVGQ6ZPcyAxxeJRwxXTqHST+EJPwrUoKEgw2G/4ygWbWEUfHGegI4Uf
         BntmOD0UsIQixUcpSUOgUrNMpZN/aYZmKprsClhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 194/211] vDPA/ifcvf: decouple vq IRQ releasers from the adapter
Date:   Fri, 10 Mar 2023 14:39:34 +0100
Message-Id: <20230310133724.782107338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

commit 004cbcabab46d9346e2524c4eedd71ea57fe4f3c upstream.

This commit decouples the IRQ releasers from the
adapter, so that these functions could be
safely invoked once probe

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-5-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -69,10 +69,9 @@ static void ifcvf_free_irq_vectors(void
 	pci_free_irq_vectors(data);
 }
 
-static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++) {
@@ -83,10 +82,9 @@ static void ifcvf_free_per_vq_irq(struct
 	}
 }
 
-static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->vqs_reused_irq != -EINVAL) {
 		devm_free_irq(&pdev->dev, vf->vqs_reused_irq, vf);
@@ -95,14 +93,12 @@ static void ifcvf_free_vqs_reused_irq(st
 
 }
 
-static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
-
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ifcvf_free_per_vq_irq(adapter);
+		ifcvf_free_per_vq_irq(vf);
 	else
-		ifcvf_free_vqs_reused_irq(adapter);
+		ifcvf_free_vqs_reused_irq(vf);
 }
 
 static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
@@ -126,8 +122,9 @@ static void ifcvf_free_config_irq(struct
 static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
+	struct ifcvf_hw *vf = &adapter->vf;
 
-	ifcvf_free_vq_irq(adapter);
+	ifcvf_free_vq_irq(vf);
 	ifcvf_free_config_irq(adapter);
 	ifcvf_free_irq_vectors(pdev);
 }


