Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90C6B4279
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjCJODu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjCJODX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:03:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21F5A6E5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:03:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68304CE28FF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C46C4339C;
        Fri, 10 Mar 2023 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456993;
        bh=WHWFpoQ1nrjbpody8adXpagBLdlcYWceEFt87NMVy4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATboc5VgP+MPjtHF64R6csIXA/laApvh8mr59EnzYSA/6nyRHmhLp9tKm+vIRSo4V
         LyvvO/NklCiqzsVj4aYHV7s64z35KyISEySe3JXTkKQu/23gouMOSjNj6/Ep64Pf/R
         ZA7HH1Uo7jY30mPjK3Gmu/Keqkx7sOpSKN7bRd0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 195/211] vDPA/ifcvf: decouple config IRQ releaser from the adapter
Date:   Fri, 10 Mar 2023 14:39:35 +0100
Message-Id: <20230310133724.811251456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

commit 23dac55cec3afdbc1b4eaed1c79f2cee00477f8b upstream.

This commit decouples config IRQ releaser from the adapter,
so that it could be invoked once probe or in err handlers.
ifcvf_free_irq() works on ifcvf_hw in this commit

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-6-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -101,10 +101,9 @@ static void ifcvf_free_vq_irq(struct ifc
 		ifcvf_free_vqs_reused_irq(vf);
 }
 
-static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->config_irq == -EINVAL)
 		return;
@@ -119,13 +118,12 @@ static void ifcvf_free_config_irq(struct
 	}
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	ifcvf_free_vq_irq(vf);
-	ifcvf_free_config_irq(adapter);
+	ifcvf_free_config_irq(vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -187,7 +185,7 @@ static int ifcvf_request_per_vq_irq(stru
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -221,7 +219,7 @@ static int ifcvf_request_vqs_reused_irq(
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -262,7 +260,7 @@ static int ifcvf_request_dev_irq(struct
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 
@@ -317,7 +315,7 @@ static int ifcvf_request_config_irq(stru
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -508,7 +506,7 @@ static int ifcvf_vdpa_reset(struct vdpa_
 
 	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter);
+		ifcvf_free_irq(vf);
 	}
 
 	ifcvf_reset_vring(adapter);


