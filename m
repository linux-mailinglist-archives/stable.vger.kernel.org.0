Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A016B4368
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjCJOO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjCJOOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:14:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A9A4205
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9385BB822CC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E936C4339E;
        Fri, 10 Mar 2023 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457571;
        bh=sUiRhxewCgC3dtqFzN+Sq11Vm+nXjivcxsoRaI+Rd/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZNbz3yaMo4ne3ITBXukHp5d7XYxbe9J92m3/ZQF7adjheTUre7TT3+jNaYO0XjfZ
         8PllXcEhtC+He3vjlQbf6+4seUviDjyaKt2+QjEtnlDbV19d05iadrq5OBa6Czwj5p
         P/jizOtC3byuWfejprQ1x81r9rgW9Y7qBn0+jg1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 183/200] vDPA/ifcvf: decouple vq irq requester from the adapter
Date:   Fri, 10 Mar 2023 14:39:50 +0100
Message-Id: <20230310133722.718669057@linuxfoundation.org>
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

commit f9a9ffb2e4dbde81090416fc51662441c2a7b73b upstream.

This commit decouples the vq irq requester from the adapter,
so that these functions can be invoked since probe.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-7-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -155,10 +155,9 @@ static int ifcvf_alloc_vectors(struct if
 	return ret;
 }
 
-static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vf->vqs_reused_irq = -EINVAL;
@@ -190,10 +189,9 @@ err:
 	return -EFAULT;
 }
 
-static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -266,15 +264,14 @@ err:
 
 }
 
-static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ret = ifcvf_request_per_vq_irq(adapter);
+		ret = ifcvf_request_per_vq_irq(vf);
 	else
-		ret = ifcvf_request_vqs_reused_irq(adapter);
+		ret = ifcvf_request_vqs_reused_irq(vf);
 
 	return ret;
 }
@@ -341,7 +338,7 @@ static int ifcvf_request_irq(struct ifcv
 		return ret;
 	}
 
-	ret = ifcvf_request_vq_irq(adapter);
+	ret = ifcvf_request_vq_irq(vf);
 	if (ret)
 		return ret;
 


