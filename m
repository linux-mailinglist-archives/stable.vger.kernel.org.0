Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9E582F87
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbiG0R1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242117AbiG0R07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090905FAE6;
        Wed, 27 Jul 2022 09:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C6B3B821AC;
        Wed, 27 Jul 2022 16:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF9DC433D7;
        Wed, 27 Jul 2022 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940410;
        bh=ZhxdM7jcjpWARpoyc/iCo1myCVH6FRG8l2e//X3LXSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcYfgtcN+1Ek6uiyg0NNpnUbvoYLZ14G/S025CTm6TWxkyXxs8H/QxWL4XqiH0NKQ
         r5nZUyeZC2Y7yrunX0Oy08rmofcoyvb6zz3iJtAl/u9XXYGhO7o2f/qRuS29+zgW4M
         h7XnPfpD85X0LEf203+99f5A13+e40ZJVkqc4XHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Dexuan Cui <decui@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Carl Vanderlip <quic_carlv@quicinc.com>
Subject: [PATCH 5.18 014/158] PCI: hv: Fix multi-MSI to allow more than one MSI vector
Date:   Wed, 27 Jul 2022 18:11:18 +0200
Message-Id: <20220727161022.034016477@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

[ upstream change 08e61e861a0e47e5e1a3fb78406afd6b0cea6b6d ]

If the allocation of multiple MSI vectors for multi-MSI fails in the core
PCI framework, the framework will retry the allocation as a single MSI
vector, assuming that meets the min_vecs specified by the requesting
driver.

Hyper-V advertises that multi-MSI is supported, but reuses the VECTOR
domain to implement that for x86.  The VECTOR domain does not support
multi-MSI, so the alloc will always fail and fallback to a single MSI
allocation.

In short, Hyper-V advertises a capability it does not implement.

Hyper-V can support multi-MSI because it coordinates with the hypervisor
to map the MSIs in the IOMMU's interrupt remapper, which is something the
VECTOR domain does not have.  Therefore the fix is simple - copy what the
x86 IOMMU drivers (AMD/Intel-IR) do by removing
X86_IRQ_ALLOC_CONTIGUOUS_VECTORS after calling the VECTOR domain's
pci_msi_prepare().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1649856981-14649-1-git-send-email-quic_jhugo@quicinc.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -614,7 +614,16 @@ static void hv_set_msi_entry_from_desc(u
 static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
 			  int nvec, msi_alloc_info_t *info)
 {
-	return pci_msi_prepare(domain, dev, nvec, info);
+	int ret = pci_msi_prepare(domain, dev, nvec, info);
+
+	/*
+	 * By using the interrupt remapper in the hypervisor IOMMU, contiguous
+	 * CPU vectors is not needed for multi-MSI
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_PCI_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
 }
 
 /**


