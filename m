Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B071965FA
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHTQOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:14:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38720 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHTQOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:14:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id e11so3513237pga.5;
        Tue, 20 Aug 2019 09:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rfpTxm0NAlEy8xKy4wmYmwInXk2X4QMQ21G/QjPhbGQ=;
        b=CsgDlslaxLWx9+hIAAZXrW6hCZmgvxBNwrkKUshqVcu9c+zBYyOnbn/hieCN02EmYy
         bshIHdLNgg1ffOvfVjduqeYRcTzO2lf2gv027lpc3idtDg2S6pVA558VPcHeHcCjMNcM
         +p+kLlnXCwjKjpi9Q4+vBiiQzygzvJKJ9jwDMcdcCrtmQ9gDkZnlwjY6WQVIgqmtXZcO
         EvLcC0tdaenxc68SmNpMgs+XWQBgsFvIIGPx1SXz3OO/L6E/8L1kxbWdQfZUSEb/nput
         rGZg6W5WXPdjdJeXV6afUnLlBTP5nF647MTMl5FMND6VR7GS5/Tt5NVnaY9hUY78NU3/
         QSjw==
X-Gm-Message-State: APjAAAXrPRSHDhUOMzOyOUJ24f2C1xPmVGf1O9nwZkUyOqUtYbBqjiRA
        r4rCfAjH0onN7gk73dBMPTE=
X-Google-Smtp-Source: APXvYqxTIV3zuOXqQRI/JI1qaV7Iq/Y4nRwsb5qOUjTnvGS327RD0amGzW/WoGsdRxyFRjBQUAbgOA==
X-Received: by 2002:a65:514c:: with SMTP id g12mr25438710pgq.76.1566317639818;
        Tue, 20 Aug 2019 09:13:59 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id u23sm19759252pgj.58.2019.08.20.09.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 09:13:59 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@vmware.com>, stable@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] iommu/vt-d: Fix wrong analysis whether devices share the same bus
Date:   Tue, 20 Aug 2019 01:53:17 -0700
Message-Id: <20190820085317.29458-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/iommu/intel_irq_remapping.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 4786ca061e31..81e43c1df7ec 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -376,13 +376,13 @@ static int set_msi_sid_cb(struct pci_dev *pdev, u16 alias, void *opaque)
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
 
-- 
2.17.1

