Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDD82F3060
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404336AbhALM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403960AbhALM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A10DA2388A;
        Tue, 12 Jan 2021 12:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456219;
        bh=dXuMAfBKCBi2SX5HxRW7MZYwE9tglm8NkGuh2VHqTmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfQBFcrCAm0I6s7sdHRJxuv2LkXmomlrwb/tbELgq0FJ/dW7O45b/cubDijiDZHWL
         4sr6BT2K3nqD5Yyc+6VhCGTZDdsQtrVur6keurVUUXJ3rMj8tLVKsk4UL1DT3JdzIV
         pJ51EwH0WhPl/HXYTXSHQVuLF5CzBcNZvpukr9kuGARorOWHbCNpZWYAf0UiayB+fe
         Ia7JElv2djSITnaic7wcZY/5OE1sHW/i8mkbWB6Np9M6jrMFbnxEgSKd9ugZTSNHdZ
         iATEvm8N80V6Cfr788J6/F3AxJMS/+c6EQN27/NPmP233gshHwXvtvo9saWd6vmw5I
         j84hLBIueIHDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oded Gabbay <ogabbay@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 10/28] habanalabs: register to pci shutdown callback
Date:   Tue, 12 Jan 2021 07:56:26 -0500
Message-Id: <20210112125645.70739-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <ogabbay@kernel.org>

[ Upstream commit fcaebc7354188b0d708c79df4390fbabd4d9799d ]

We need to make sure our device is idle when rebooting a virtual
machine. This is done in the driver level.

The firmware will later handle FLR but we want to be extra safe and
stop the devices until the FLR is handled.

Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/habanalabs_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/habanalabs/habanalabs_drv.c b/drivers/misc/habanalabs/habanalabs_drv.c
index 8c342fb499ca6..ae50bd55f30af 100644
--- a/drivers/misc/habanalabs/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/habanalabs_drv.c
@@ -443,6 +443,7 @@ static struct pci_driver hl_pci_driver = {
 	.id_table = ids,
 	.probe = hl_pci_probe,
 	.remove = hl_pci_remove,
+	.shutdown = hl_pci_remove,
 	.driver.pm = &hl_pm_ops,
 };
 
-- 
2.27.0

