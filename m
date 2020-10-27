Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E2729C5D1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756543AbgJ0OOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756539AbgJ0OOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:14:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87426206F7;
        Tue, 27 Oct 2020 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808041;
        bh=yuUPAauBzOJHRAHG0hIClVYymHiji0cjQl8wddwEQ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xg3kqQz9LdnLpsuyG4VQtCeqebJH0S+Bmn8LRsd9xZByzs1WbYn0gkmChURj4pT3j
         W8xeEBMS5ZPJbUjF+3ojND80Hu5zakbADC0IEZh9Y9o1voJNbMZuwb8Exw78yn02O6
         JVsEdUTXiBtec+2QndCtl8ep9dm8nj03G0HtiWGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Li <likaige@loongson.cn>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/191] NTB: hw: amd: fix an issue about leak system resources
Date:   Tue, 27 Oct 2020 14:49:48 +0100
Message-Id: <20201027134916.096785931@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>

[ Upstream commit 44a0a3c17919db1498cebb02ecf3cf4abc1ade7b ]

The related system resources were not released when pci_set_dma_mask(),
pci_set_consistent_dma_mask(), or pci_iomap() return error in the
amd_ntb_init_pci() function. Add pci_release_regions() to fix it.

Fixes: a1b3695820aa ("NTB: Add support for AMD PCI-Express Non-Transparent Bridge")
Signed-off-by: Kaige Li <likaige@loongson.cn>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index f0788aae05c9c..72a7981ef73fb 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1032,6 +1032,7 @@ static int amd_ntb_init_pci(struct amd_ntb_dev *ndev,
 
 err_dma_mask:
 	pci_clear_master(pdev);
+	pci_release_regions(pdev);
 err_pci_regions:
 	pci_disable_device(pdev);
 err_pci_enable:
-- 
2.25.1



