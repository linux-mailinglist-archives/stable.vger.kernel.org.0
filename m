Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81CC29B0F5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758925AbgJ0OZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754067AbgJ0OZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:25:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2FC2072D;
        Tue, 27 Oct 2020 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808731;
        bh=LltNz5blzkG3eB0hrIl+yG/F6kFORKwk3dmgl+7H1wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtzDkDT6kxyuM/dbEHuSp2cBVKMiaijzQR0w0soqM9keewYI+VVxUi+6ENMZqTx7i
         dGCkHsEsGxoAgUU2grPuyXytJD5OY5kMWfkgTH2G/HafNnOac63p7mNVeK1itoObaT
         AX7Ilfupen5U1FReW4yuLWWu0YxORuq6j75kZC3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Li <likaige@loongson.cn>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/264] NTB: hw: amd: fix an issue about leak system resources
Date:   Tue, 27 Oct 2020 14:54:20 +0100
Message-Id: <20201027135440.157598822@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index efb214fc545a2..0b1fbb5dba9b6 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1036,6 +1036,7 @@ static int amd_ntb_init_pci(struct amd_ntb_dev *ndev,
 
 err_dma_mask:
 	pci_clear_master(pdev);
+	pci_release_regions(pdev);
 err_pci_regions:
 	pci_disable_device(pdev);
 err_pci_enable:
-- 
2.25.1



