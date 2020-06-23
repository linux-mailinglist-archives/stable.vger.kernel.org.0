Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE6205C6D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387719AbgFWUBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387714AbgFWUBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:01:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92D0A2078A;
        Tue, 23 Jun 2020 20:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942512;
        bh=IJOs31q3U0GUA/Gt9yQ3tZenC2Ks1uwhy0P91NDVngA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAZLwo6HbmiQ31pDlbWA2fsRZRi+opLWnwyZnWrz7Doa90CFKNK37gIwc6JsseJ/H
         lj1yl3kuPla9KQHUdEWC3Ze9NZ6Vz5yd6V6CZC5h7LfBbVBoaMtnjNemguY+XXR+6z
         Nk+AiKeZpYUPARpTGVaXTWR6FVx8FNJObjVL4TB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 027/477] PCI: endpoint: functions/pci-epf-test: Fix DMA channel release
Date:   Tue, 23 Jun 2020 21:50:24 +0200
Message-Id: <20200623195408.891413807@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 60330f3e37516..c89a9561439f9 100644
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



