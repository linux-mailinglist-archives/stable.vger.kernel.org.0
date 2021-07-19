Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02D93CE25D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348206AbhGSPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348080AbhGSPYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D5C61411;
        Mon, 19 Jul 2021 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710481;
        bh=Sqtv2oYS9TW4dmQMiEDsE7hxSoVFTvockIzPUnWBKVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbWHTWkb+VOPrzs+bftjlzcq4CbVAbpsdgWQcTjoo45lbYnqIFP/YsjkUB4FTycoq
         9HPnJozXesLRf5mnsQeIlzAfVwq8HIAsAv3aif/V7R2e6nfSkuopHjV85nbawdPKxA
         jZP6nD3XWY55T6RqjrGdN7HkMuvLS/W25HPJ/CCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/243] scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()
Date:   Mon, 19 Jul 2021 16:54:24 +0200
Message-Id: <20210719144948.505621604@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 030e4138d11fced3b831c2761e4cecf347bae99c ]

If an error occurs after a pci_enable_pcie_error_reporting() call, it must
be undone by a corresponding pci_disable_pcie_error_reporting() call, as
already done in the remove function.

Link: https://lore.kernel.org/r/77adb02cfea7f1364e5603ecf3930d8597ae356e.1623482155.git.christophe.jaillet@wanadoo.fr
Fixes: 3567f36a09d1 ("[SCSI] be2iscsi: Fix AER handling in driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1643e2225692..987dc8135a9b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5745,6 +5745,7 @@ free_hba:
 	pci_disable_msix(phba->pcidev);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_disable_pcie_error_reporting(pcidev);
 	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_release_regions(pcidev);
-- 
2.30.2



