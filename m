Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8452257DAF
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgHaPjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgHaP35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:29:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C5B20E65;
        Mon, 31 Aug 2020 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887797;
        bh=L0Iz0oktZ4DsRF8xV00NFozhcnwlPIlJfnhtNskrnaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUINvk+ooagsUl8J/86+Tzr6MiSrHv0OJnTNTYFUibr6tseToNQIKXGbzT/3EVPFR
         7Bismvn18jrc7/JU0y2qyBhHI6SwYznCJeny237RgrZu/gAs7YFsLf49ZYwhLQ4ZJ8
         W36u2hQAkTVqqwFWFOzyQB3fD80V6CayBgQ0Auaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 14/42] habanalabs: unmap PCI bars upon iATU failure
Date:   Mon, 31 Aug 2020 11:29:06 -0400
Message-Id: <20200831152934.1023912-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

