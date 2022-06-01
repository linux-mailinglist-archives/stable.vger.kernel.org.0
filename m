Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4F053A81B
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354595AbiFAOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355406AbiFAOFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD51DB0435;
        Wed,  1 Jun 2022 06:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69135615B2;
        Wed,  1 Jun 2022 13:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A02AC385B8;
        Wed,  1 Jun 2022 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091967;
        bh=xry6IlibLXy31UeppTQTdRP7qqE+LKAPoRAOS75hzqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVQQZGcrzfF9xJ1ErTuPlQL77iAG3uyz6QVQkpd3TK4mOSMgbDCIRlbK611KkmurM
         Gfyw1QO8XyhSw81vQ5bVOSevgHfj53GP88qCm9hve+x3QEShemfpOoih1F7n/r5bFW
         1uV0l2lm3qfH8zx3EANeixgFmvUC8fAexYCYGu3CkLX9AF647u2H8VarieU+B8/pWJ
         8z3B5lHxEbEhLAXgj4YvdtQTGtg7SdasMjXv21gRZvBpdFgSGMSfQxDKHD7THGNpnj
         GgxOAgtWV3YyvnvLh2bJQnzZ/u+jQD+i4JEa8cBxiiz51Ml2M96e13Wvvd81mwgjsV
         KZZQqmtK4kZuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicong Yang <yangyicong@hisilicon.com>,
        Jay Zhou <jianjay.zhou@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/20] PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()
Date:   Wed,  1 Jun 2022 09:58:55 -0400
Message-Id: <20220601135902.2004823-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit a91ee0e9fca9d7501286cfbced9b30a33e52740a ]

The sysfs sriov_numvfs_store() path acquires the device lock before the
config space access lock:

  sriov_numvfs_store
    device_lock                 # A (1) acquire device lock
    sriov_configure
      vfio_pci_sriov_configure  # (for example)
        vfio_pci_core_sriov_configure
          pci_disable_sriov
            sriov_disable
              pci_cfg_access_lock
                pci_wait_cfg    # B (4) wait for dev->block_cfg_access == 0

Previously, pci_dev_lock() acquired the config space access lock before the
device lock:

  pci_dev_lock
    pci_cfg_access_lock
      dev->block_cfg_access = 1 # B (2) set dev->block_cfg_access = 1
    device_lock                 # A (3) wait for device lock

Any path that uses pci_dev_lock(), e.g., pci_reset_function(), may
deadlock with sriov_numvfs_store() if the operations occur in the sequence
(1) (2) (3) (4).

Avoid the deadlock by reversing the order in pci_dev_lock() so it acquires
the device lock before the config space access lock, the same as the
sriov_numvfs_store() path.

[bhelgaas: combined and adapted commit log from Jay Zhou's independent
subsequent posting:
https://lore.kernel.org/r/20220404062539.1710-1-jianjay.zhou@huawei.com]
Link: https://lore.kernel.org/linux-pci/1583489997-17156-1-git-send-email-yangyicong@hisilicon.com/
Also-posted-by: Jay Zhou <jianjay.zhou@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d539eb379743..c988aa425ac9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4915,18 +4915,18 @@ static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
 
 static void pci_dev_lock(struct pci_dev *dev)
 {
-	pci_cfg_access_lock(dev);
 	/* block PM suspend, driver probe, etc. */
 	device_lock(&dev->dev);
+	pci_cfg_access_lock(dev);
 }
 
 /* Return 1 on successful lock, 0 on contention */
 static int pci_dev_trylock(struct pci_dev *dev)
 {
-	if (pci_cfg_access_trylock(dev)) {
-		if (device_trylock(&dev->dev))
+	if (device_trylock(&dev->dev)) {
+		if (pci_cfg_access_trylock(dev))
 			return 1;
-		pci_cfg_access_unlock(dev);
+		device_unlock(&dev->dev);
 	}
 
 	return 0;
@@ -4934,8 +4934,8 @@ static int pci_dev_trylock(struct pci_dev *dev)
 
 static void pci_dev_unlock(struct pci_dev *dev)
 {
-	device_unlock(&dev->dev);
 	pci_cfg_access_unlock(dev);
+	device_unlock(&dev->dev);
 }
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
-- 
2.35.1

