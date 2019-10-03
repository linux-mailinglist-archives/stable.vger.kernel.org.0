Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01A0CA7C0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405948AbfJCQvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405146AbfJCQu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939B820865;
        Thu,  3 Oct 2019 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121459;
        bh=nXQIQUChDQTJepmXhuT4OoVw16fDzfRJkyUABc3APIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txNQnknvRXHd2IBjLif/cvIggVGWZN3vEU9DjF0fXDkrOMkpWZv/OTGtEFkCgCMSq
         m934wYGylGUZCfvaJw8Qu90g39+QdHmI1uapa40GEHpLLsRRWkIT13Rk1J5K5LuxML
         d+Z5Lfv5dZwM0w0IintsJWeQIpPZ4LUuZvG8bJjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Nadav Amit <namit@vmware.com>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.3 286/344] iommu/vt-d: Fix wrong analysis whether devices share the same bus
Date:   Thu,  3 Oct 2019 17:54:11 +0200
Message-Id: <20191003154608.066370067@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 2c70010867f164d1b30e787e360e05d10cc40046 upstream.

set_msi_sid_cb() is used to determine whether device aliases share the
same bus, but it can provide false indications that aliases use the same
bus when in fact they do not. The reason is that set_msi_sid_cb()
assumes that pdev is fixed, while actually pci_for_each_dma_alias() can
call fn() when pdev is set to a subordinate device.

As a result, running an VM on ESX with VT-d emulation enabled can
results in the log warning such as:

  DMAR: [INTR-REMAP] Request device [00:11.0] fault index 3b [fault reason 38] Blocked an interrupt request due to source-id verification failure

This seems to cause additional ata errors such as:
  ata3.00: qc timeout (cmd 0xa1)
  ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)

These timeouts also cause boot to be much longer and other errors.

Fix it by checking comparing the alias with the previous one instead.

Fixes: 3f0c625c6ae71 ("iommu/vt-d: Allow interrupts from the entire bus for aliased devices")
Cc: stable@vger.kernel.org
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel_irq_remapping.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -376,13 +376,13 @@ static int set_msi_sid_cb(struct pci_dev
 {
 	struct set_msi_sid_data *data = opaque;
 
+	if (data->count == 0 || PCI_BUS_NUM(alias) == PCI_BUS_NUM(data->alias))
+		data->busmatch_count++;
+
 	data->pdev = pdev;
 	data->alias = alias;
 	data->count++;
 
-	if (PCI_BUS_NUM(alias) == pdev->bus->number)
-		data->busmatch_count++;
-
 	return 0;
 }
 


