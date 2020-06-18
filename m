Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3451FE8ED
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgFRCwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgFRBIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA2021D7D;
        Thu, 18 Jun 2020 01:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442523;
        bh=hoCU8WMiSipGRhTwA1idIQYXuWJKj3HYboe160YztMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALfbarEtzc0AE6Ct7kHb8hF5w+PRWq/iy+A1kBwLttK1wXjaANFceA81MCMJtrdQS
         XMZtGKyNrU4uEovT6msSPE8osPbSsAtTRcQabzOr2z8m7FckwBKy1/lyuM+5JpKS0G
         LSSiQTyVmqddnK/dP8C8NAHJEmb27qswtz4cxCGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 028/388] PCI: endpoint: functions/pci-epf-test: Fix DMA channel release
Date:   Wed, 17 Jun 2020 21:02:05 -0400
Message-Id: <20200618010805.600873-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 0e86d981f9b7252e9716c5137cd8e4d9ad8ef32f ]

When unbinding pci_epf_test, pci_epf_test_clean_dma_chan() is called in
pci_epf_test_unbind() even though epf_test->dma_supported is false.

As a result, dma_release_channel() will trigger a NULL pointer
dereference because dma_chan is not set.

Avoid calling dma_release_channel() if epf_test->dma_supported
is false.

Link: https://lore.kernel.org/r/1587540287-10458-1-git-send-email-hayashi.kunihiko@socionext.com
Fixes: 5ebf3fc59bd2 ("PCI: endpoint: functions/pci-epf-test: Add DMA support to transfer data")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 60330f3e3751..c89a9561439f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -187,6 +187,9 @@ static int pci_epf_test_init_dma_chan(struct pci_epf_test *epf_test)
  */
 static void pci_epf_test_clean_dma_chan(struct pci_epf_test *epf_test)
 {
+	if (!epf_test->dma_supported)
+		return;
+
 	dma_release_channel(epf_test->dma_chan);
 	epf_test->dma_chan = NULL;
 }
-- 
2.25.1

