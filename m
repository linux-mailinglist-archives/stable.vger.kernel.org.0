Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1A74CCF
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404031AbfGYLTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:19:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45126 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390493AbfGYLTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 07:19:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so22590134pfq.12
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 04:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=R81ZzKgxtCEhGNXrZhRMrtHubJyNabvopqXLt4EYV7c=;
        b=QFoeMIJ2xnk1lN/sbOkFc+TglFBTMdjt4X1DAE3Ot1g+fOLc4h939AyJQqev5C2SY3
         twL87xpjawUnU8exsiiuOXEsy2RA2MG+AfARBc6ziraSUHvLDLO62o+IUp4C9qfU/dp3
         wkWdZHzzlG8I8Mz1/F2FT6gG/2vgMF6iaQQtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R81ZzKgxtCEhGNXrZhRMrtHubJyNabvopqXLt4EYV7c=;
        b=JlO/sqxLHL+VG703PnFR11STkW6LRVkGnPYlM8i0WDoDKXWQ4NLyUTOZqoaNnp2krY
         o6UKUbRnSCj0M96NJH09sq381AsKl+MyCGw+SjXqH1fi0ULawLu/WECGLEqgU3f/H5BC
         CB9WO7Qb4cQRESqy7HHauW25yp1cR02HNipoz7V7DgtwcBYxJDeR8saiPgzcvOfKvq5/
         O3LOu6F3pHRbtWNumJNInHgCX3AQ5MbKqdxUolpZBbQWX0BmagqHm+yS+k3gHK9d1Azn
         +3Do525Rp1rHrBJeTAsfZoOKszVxPm9eBXLRNIIMHkNoiLYtaEXCL/nUWTfBo6e35TJ4
         Rxpw==
X-Gm-Message-State: APjAAAUUVZzV2VyUYI9VaShiNm5l4f+cSjNPOsv/r7z9y8hpNno4/MvC
        I6snJzyLVDx/aMRLySwsElD3FQ==
X-Google-Smtp-Source: APXvYqyKqhU48N9TQuxSG0hvU7JWWsCUXpSs2/EWc3i8+tszqYDkH3vz7NY4T/IiUmbFnb3J6KD2LA==
X-Received: by 2002:a63:4f51:: with SMTP id p17mr64083775pgl.333.1564053554053;
        Thu, 25 Jul 2019 04:19:14 -0700 (PDT)
Received: from dhcp-10-123-20-16.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w2sm41791961pgc.32.2019.07.25.04.19.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 04:19:13 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     saxenasumit87m@gmail.com
Cc:     chandrakanth.patil@broadcom.com, stable@vger.kernel.org,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH] PCI: set BAR size bits correctly in Resize BAR control register
Date:   Fri, 26 Jul 2019 00:47:58 +0530
Message-Id: <20190725191758.23462-1-sumit.saxena@broadcom.com>
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

