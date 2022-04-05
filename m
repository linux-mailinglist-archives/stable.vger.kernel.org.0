Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72504F2A2D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiDEInk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241168AbiDEIcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2A5DF9C;
        Tue,  5 Apr 2022 01:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD241B81BC5;
        Tue,  5 Apr 2022 08:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBCEC385A6;
        Tue,  5 Apr 2022 08:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147340;
        bh=yMDw+3Dl6/Eb0dGKBwer0nh7Fx6ro0c+hSAlN+Glybo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jewYagGsL9SPkrwWQ4a3tqopzGbiJ7ctHRylp+aXsKsls7vRDEKZQcBZBz7wHW3Xu
         CTMvN+HlIJC0M0dQCBEaaOnX8EqekyFd+Zz4m/gs+QQokMwnwsUslR43dSaUNfUJo2
         9mn5ICsFc579Jx9qyXmQtUlyZGAT55oiuVz08lh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.17 1051/1126] Revert "virtio-pci: harden INTX interrupts"
Date:   Tue,  5 Apr 2022 09:29:58 +0200
Message-Id: <20220405070438.318149200@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

commit 7b79edfb862d6b1ecc66479419ae67a7db2d02e3 upstream.

This reverts commit 080cd7c3ac8701081d143a15ba17dd9475313188. Since
the MSI-X interrupts hardening will be reverted in the next patch. We
will rework the interrupt hardening in the future.

Fixes: 080cd7c3ac87 ("virtio-pci: harden INTX interrupts")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220323031524.6555-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_pci_common.c |   23 ++---------------------
 drivers/virtio/virtio_pci_common.h |    1 -
 2 files changed, 2 insertions(+), 22 deletions(-)

--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -30,16 +30,8 @@ void vp_disable_cbs(struct virtio_device
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i;
 
-	if (vp_dev->intx_enabled) {
-		/*
-		 * The below synchronize() guarantees that any
-		 * interrupt for this line arriving after
-		 * synchronize_irq() has completed is guaranteed to see
-		 * intx_soft_enabled == false.
-		 */
-		WRITE_ONCE(vp_dev->intx_soft_enabled, false);
+	if (vp_dev->intx_enabled)
 		synchronize_irq(vp_dev->pci_dev->irq);
-	}
 
 	for (i = 0; i < vp_dev->msix_vectors; ++i)
 		disable_irq(pci_irq_vector(vp_dev->pci_dev, i));
@@ -51,16 +43,8 @@ void vp_enable_cbs(struct virtio_device
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	int i;
 
-	if (vp_dev->intx_enabled) {
-		disable_irq(vp_dev->pci_dev->irq);
-		/*
-		 * The above disable_irq() provides TSO ordering and
-		 * as such promotes the below store to store-release.
-		 */
-		WRITE_ONCE(vp_dev->intx_soft_enabled, true);
-		enable_irq(vp_dev->pci_dev->irq);
+	if (vp_dev->intx_enabled)
 		return;
-	}
 
 	for (i = 0; i < vp_dev->msix_vectors; ++i)
 		enable_irq(pci_irq_vector(vp_dev->pci_dev, i));
@@ -113,9 +97,6 @@ static irqreturn_t vp_interrupt(int irq,
 	struct virtio_pci_device *vp_dev = opaque;
 	u8 isr;
 
-	if (!READ_ONCE(vp_dev->intx_soft_enabled))
-		return IRQ_NONE;
-
 	/* reading the ISR has the effect of also clearing it so it's very
 	 * important to save off the value. */
 	isr = ioread8(vp_dev->isr);
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -63,7 +63,6 @@ struct virtio_pci_device {
 	/* MSI-X support */
 	int msix_enabled;
 	int intx_enabled;
-	bool intx_soft_enabled;
 	cpumask_var_t *msix_affinity_masks;
 	/* Name strings for interrupts. This size should be enough,
 	 * and I'm too lazy to allocate each name separately. */


