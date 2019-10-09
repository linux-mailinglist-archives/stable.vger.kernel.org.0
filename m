Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9ED1692
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbfJIRbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732103AbfJIRYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:05 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 951D32190F;
        Wed,  9 Oct 2019 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641844;
        bh=ETaAvzsQEiP4oZJWvRcthsJ/ZN8IdDXxzwucysDt7Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH1MmBoyd/FRGiwMeTSjP26YT+zhbQ9azCsOpsFizZucevrAKxe7FS/0Uhoz+Nqp9
         iUiN2MUnaLegi/hdDfVOAkZe/ytAnl1Tmd87j5uMDs69MkZ2c063CmlF/oFsjYfewg
         iHGjN9U8OqWPDefSYMvsy9VmQvKTlgizLXvlUU3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/26] scsi: megaraid: disable device when probe failed after enabled device
Date:   Wed,  9 Oct 2019 13:05:36 -0400
Message-Id: <20191009170558.32517-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 70054aa39a013fa52eff432f2223b8bd5c0048f8 ]

For pci device, need to disable device when probe failed after enabled
device.

Link: https://lore.kernel.org/r/1567818450-173315-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 8c7154143a4eb..a84878fbf45d2 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4189,11 +4189,11 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_COMPAQ &&
 		    pdev->subsystem_device == 0xC000)
-		   	return -ENODEV;
+			goto out_disable_device;
 		/* Now check the magic signature byte */
 		pci_read_config_word(pdev, PCI_CONF_AMISIG, &magic);
 		if (magic != HBA_SIGNATURE_471 && magic != HBA_SIGNATURE)
-			return -ENODEV;
+			goto out_disable_device;
 		/* Ok it is probably a megaraid */
 	}
 
-- 
2.20.1

