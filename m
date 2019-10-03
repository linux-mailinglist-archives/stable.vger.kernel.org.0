Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCBCA29B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbfJCQHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732879AbfJCQHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29B4D215EA;
        Thu,  3 Oct 2019 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118825;
        bh=BdKXf97jE2/UC69PLNlnqNXE5Myg2bfbhBoXkFScitU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnMC2Mrhp7/tyh8tjQ5B9lwjVHAbdyeSRgXSY1kNWm/4FvUQH8VaxEHVdjhywGqPg
         esMDoGm1iIevfrE8RrxQe1rsOpcC9dxbfFgCDwiqG9GlGajkaZZz16hG2Ps1pd7Bt8
         vzaaUJkUN7LWPi9k1cdHDdv7kOsOmxVEIuGuTRtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/185] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it
Date:   Thu,  3 Oct 2019 17:51:41 +0200
Message-Id: <20191003154442.941063740@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 533ca1feed98b0bf024779a14760694c7cb4d431 ]

The slot must be removed before the pci_dev is removed, otherwise a panic
can happen due to use-after-free.

Fixes: 15becc2b56c6 ("PCI: hv: Add hv_pci_remove_slots() when we unload the driver")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 5a9d945122327..70825689e5a08 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -2740,8 +2740,8 @@ static int hv_pci_remove(struct hv_device *hdev)
 		/* Remove the bus from PCI's point of view. */
 		pci_lock_rescan_remove();
 		pci_stop_root_bus(hbus->pci_bus);
-		pci_remove_root_bus(hbus->pci_bus);
 		hv_pci_remove_slots(hbus);
+		pci_remove_root_bus(hbus->pci_bus);
 		pci_unlock_rescan_remove();
 		hbus->state = hv_pcibus_removed;
 	}
-- 
2.20.1



