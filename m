Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC53CDA69
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbhGSOfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245221AbhGSOe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0E5161279;
        Mon, 19 Jul 2021 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707637;
        bh=aE8rBFuYz3w5rOYaRyxgwOAw28bOE77csA3Aj7bsi9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzycPhdsW3dYLFSH2SPMNkPWGjQ5mpXHuh4gytd8vbREED6WBYMMgUMg8R6BlhfC3
         gmM5NCOOsQb8CYZIIeL1t4s/cU1jqKU/4Gm0nL40tJJWAVzAdluilzOOY/is2g7ZUj
         qOyqV3hLhhfYpuagPkmZESlpVcJkd1vSGEPN1OkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 242/245] scsi: be2iscsi: Fix an error handling path in beiscsi_dev_probe()
Date:   Mon, 19 Jul 2021 16:53:04 +0200
Message-Id: <20210719144948.187253369@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 741cc96379cb..628bf2e6a526 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5847,6 +5847,7 @@ hba_free:
 		pci_disable_msix(phba->pcidev);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_disable_pcie_error_reporting(pcidev);
 	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_release_regions(pcidev);
-- 
2.30.2



