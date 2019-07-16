Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6FA6A63C
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbfGPKLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 06:11:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42660 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731042AbfGPKLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 06:11:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so9192404pgb.9
        for <stable@vger.kernel.org>; Tue, 16 Jul 2019 03:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=R81ZzKgxtCEhGNXrZhRMrtHubJyNabvopqXLt4EYV7c=;
        b=bTxhlALZdZwuNaMJD0l76DKiv/xY60vuGKCqaS8QEqqZRcExr5r8b0wvXFTmRJ01Hi
         t+hWMBBM7n7xC7e3ED+y1vL6vldMWi34cXGfhoB6ktO3TCwSjuLu4qfS4+XS0oCg5M1g
         akiBiNwTe4ySYlcurbv/fAKMbXR1Phzha3WFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R81ZzKgxtCEhGNXrZhRMrtHubJyNabvopqXLt4EYV7c=;
        b=qZq8veTQIGyJI2iJX83Fp+X979qn3LJ3pTs3GXGQ0hNSD3QSihDTcTl9d/q4CXc89L
         RgZ0JsGIC6gdqMQrPwfcCA86N+26Lkx6oXQt0LeiaX+CCnyi9Rzh4AGDY2MR3FYUpIZf
         GAzoz1+ZW+bf6kOtBiJHvgYupOBZ/OeY43/kONG7ZgqRvv78J+AiVP/Mdu2/fYKYI4XY
         c3tNUpFZfjKCpKmE68VaQEddEBvSw4eYwVLHFsMkdKe+4+u6QyBVrO/66cnKTNj55HJW
         vIx5CL6Kt3/ppxJG6GGcE83TUrawrEpgCuJ9qBhuqOPgwTxj0qMT+u4Gm86TEwdw9kHB
         wG2Q==
X-Gm-Message-State: APjAAAXVWfNgCrulaOddRYJThjDNH4iI9jJUdXQCq2BL4DRr5Yh8/6Ww
        P6iqPlA9jUPSssJSUUITwR2W8Q==
X-Google-Smtp-Source: APXvYqzmndE3ZEiKWKq5APqXbLOEmW9FQSA1N3MEMEcwNkG38eeNgwpsXeo4PZJIJ/mYOmOVZOIOGg==
X-Received: by 2002:a17:90a:5288:: with SMTP id w8mr35239474pjh.61.1563271876140;
        Tue, 16 Jul 2019 03:11:16 -0700 (PDT)
Received: from dhcp-10-123-20-16.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x14sm22966839pfq.158.2019.07.16.03.11.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 03:11:15 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     helgaas@kernel.org
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH] PCI: set BAR size bits correctly in Resize BAR control register
Date:   Tue, 16 Jul 2019 23:39:40 +0530
Message-Id: <20190716180940.17828-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In Resize BAR control register, bits[8:12] represents size of BAR.
As per PCIe specification, below is encoded values in register bits
to actual BAR size table:

Bits  BAR size
0     1 MB
1     2 MB
2     4 MB
3     8 MB
--

For 1 MB BAR size, BAR size bits should be set to 0 but incorrectly
these bits are set to "1f". 
Latest megaraid_sas and mpt3sas adapters which support Resizable BAR 
with 1 MB BAR size fails to initialize during system resume from S3 sleep.

Fix: Correctly set BAR size bits to "0" for 1MB BAR size.

CC: stable@vger.kernel.org # v4.16+
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
Fixes: d3252ace0bc652a1a244455556b6a549f969bf99 ("PCI: Restore resized BAR state on resume")
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/pci/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8abc843..b651f32 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1417,12 +1417,13 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
 
 	for (i = 0; i < nbars; i++, pos += 8) {
 		struct resource *res;
-		int bar_idx, size;
+		int bar_idx, size, order;
 
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pdev->resource + bar_idx;
-		size = order_base_2((resource_size(res) >> 20) | 1) - 1;
+		order = order_base_2((resource_size(res) >> 20) | 1);
+		size = order ? order - 1 : 0;
 		ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
 		ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
 		pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
-- 
1.8.3.1

