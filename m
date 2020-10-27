Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3E29AF62
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754527AbgJ0OFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754520AbgJ0OFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:05:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DD022263;
        Tue, 27 Oct 2020 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807550;
        bh=TMvl6JqP5QWLLoIB7AQcGC1r6OKMz+DhBZQmQMC6+rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yw00NDlmS4C6VZCyG1dnI5GvNi80UEJYui7p/jn1t8W29qcVtM90ox3OKAjwHnXUG
         n6zVv9YatipLIJsiOOuoZSRXR7RsJjIIA3HY6v1HlR0WPF8/WU6RBLnVAmpIFPR3uX
         1h5pposkNTS3uAWjRU62DqFmTX2atvtN6A7ejNks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Li <likaige@loongson.cn>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/139] NTB: hw: amd: fix an issue about leak system resources
Date:   Tue, 27 Oct 2020 14:49:47 +0100
Message-Id: <20201027134906.550742570@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
index 6ccba0d862df7..927b574e5d596 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -994,6 +994,7 @@ static int amd_ntb_init_pci(struct amd_ntb_dev *ndev,
 
 err_dma_mask:
 	pci_clear_master(pdev);
+	pci_release_regions(pdev);
 err_pci_regions:
 	pci_disable_device(pdev);
 err_pci_enable:
-- 
2.25.1



