Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC69C14DE
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfI2N6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbfI2N6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D104218DE;
        Sun, 29 Sep 2019 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765522;
        bh=o3LJsIv4ejrSMRZyry6Gv9gFeMdkXt4FuLD2PHuDnDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLMZ2kkPGmdNzxGQYU7LH3E3QBrEFQMGZN5yTrhjn01lX+aGL6h+QXoXhqljLvcPo
         YE7uxj08odetnw/P1xlVyEGKc9Dcp97nR938lKn+GOSrWkc0px1g41gbktmpC8hSJm
         bxfuI/8SvZGZU6DPnfhfl/q8GG1Wy8I0V5VwxjQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/63] PCI: hv: Avoid use of hv_pci_dev->pci_slot after freeing it
Date:   Sun, 29 Sep 2019 15:54:18 +0200
Message-Id: <20190929135039.530989431@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
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
 drivers/pci/controller/pci-hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 5dadc964ad3b4..5c28498466415 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2706,8 +2706,8 @@ static int hv_pci_remove(struct hv_device *hdev)
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



