Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338835418F4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358855AbiFGVSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380710AbiFGVQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764FE21F9B9;
        Tue,  7 Jun 2022 11:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0699E61724;
        Tue,  7 Jun 2022 18:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F94AC385A2;
        Tue,  7 Jun 2022 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628191;
        bh=g0u/pd5I5cajoFlJAmHmEkUnMh+QPi0LxEXCIF7xBjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ey7HmNvpcplrQm/AXqRmZOQ+gRV5upvMtWsupfCH0XtPnH6dlfGAx+yoXWk7uuINU
         sEMSLnd/31CMdesM0ioJJKPYCxpPdP0ohrVGc6ESFtOxPyXUwgErrNEWV1vH0XE5Rg
         y3bq1msW25Gq3pVhZioWlFX9HtYrhcfuoVDNbwvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yicong Yang <yangyicong@hisilicon.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Jay Zhou <jianjay.zhou@huawei.com>
Subject: [PATCH 5.18 237/879] PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()
Date:   Tue,  7 Jun 2022 18:55:55 +0200
Message-Id: <20220607165009.732563014@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d25122fbe98a..1af69e298ac3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5113,19 +5113,19 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
 
 void pci_dev_lock(struct pci_dev *dev)
 {
-	pci_cfg_access_lock(dev);
 	/* block PM suspend, driver probe, etc. */
 	device_lock(&dev->dev);
+	pci_cfg_access_lock(dev);
 }
 EXPORT_SYMBOL_GPL(pci_dev_lock);
 
 /* Return 1 on successful lock, 0 on contention */
 int pci_dev_trylock(struct pci_dev *dev)
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
@@ -5134,8 +5134,8 @@ EXPORT_SYMBOL_GPL(pci_dev_trylock);
 
 void pci_dev_unlock(struct pci_dev *dev)
 {
-	device_unlock(&dev->dev);
 	pci_cfg_access_unlock(dev);
+	device_unlock(&dev->dev);
 }
 EXPORT_SYMBOL_GPL(pci_dev_unlock);
 
-- 
2.35.1



