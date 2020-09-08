Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24166261EF3
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbgIHT5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgIHPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDE8224BE;
        Tue,  8 Sep 2020 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579297;
        bh=L0Iz0oktZ4DsRF8xV00NFozhcnwlPIlJfnhtNskrnaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f44uc6s8xOa/6oq6ffwDvvYogd1pk2NIW2kBqXJju2BXRumNhnLWMyRL/HtRK7MhM
         6GzQOxDpSm5+26amSQjXx5ci88BUcY1ETywCJ7/evJ9tmkgzAIhLSr7T22CECNt1lt
         VMiMkswr1uuHGskd+U/cv/kr5Un3vYUXtb5jC7uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 011/186] habanalabs: unmap PCI bars upon iATU failure
Date:   Tue,  8 Sep 2020 17:22:33 +0200
Message-Id: <20200908152242.199967391@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit f1aae40e8dbd2655e3b10cae381a1e8292b19d57 ]

In case the driver fails to configure the PCI controller iATU, it needs to
unmap the PCI bars before exiting so if the driver is removed, the bars
won't be left mapped.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/habanalabs/pci.c b/drivers/misc/habanalabs/pci.c
index 9f634ef6f5b37..77022c0b42027 100644
--- a/drivers/misc/habanalabs/pci.c
+++ b/drivers/misc/habanalabs/pci.c
@@ -378,15 +378,17 @@ int hl_pci_init(struct hl_device *hdev)
 	rc = hdev->asic_funcs->init_iatu(hdev);
 	if (rc) {
 		dev_err(hdev->dev, "Failed to initialize iATU\n");
-		goto disable_device;
+		goto unmap_pci_bars;
 	}
 
 	rc = hl_pci_set_dma_mask(hdev);
 	if (rc)
-		goto disable_device;
+		goto unmap_pci_bars;
 
 	return 0;
 
+unmap_pci_bars:
+	hl_pci_bars_unmap(hdev);
 disable_device:
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
-- 
2.25.1



