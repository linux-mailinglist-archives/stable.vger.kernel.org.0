Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87AC2E40F9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392504AbgL1PAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440265AbgL1ONv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E17F205CB;
        Mon, 28 Dec 2020 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164816;
        bh=jFVmtSDrJWKo8NAfmlnhVC/H6IFl7Pdu6U35T7j7Dek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSZA4xs0zwzVtpadBpABHFlBSl+xSsaRIzpgyeVD/xnSNJ4HFWmcHfSk32KV7LWeS
         fB2TiR3occCP1Nep0qvPsp3EjH8w9HBHCktEshmXwGRyGvvojFtjZRlcBp8HZHQe89
         k3soTxTHbLv+PYc2OApzjvuCqeNg/3o+mbAJIG5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/717] mt76: fix memory leak if device probing fails
Date:   Mon, 28 Dec 2020 13:45:05 +0100
Message-Id: <20201228125035.736189244@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bc348defcc6eceeb4f7784bf9a263ddb72fd3fb4 ]

Run mt76_free_device instead of ieee80211_free_hw if device probing
fails in order to remove the already allocated mt76 workqueue

Fixes: a86f1d01f5ce5 ("mt76: move mt76 workqueue in common code")
Fixes: f1d962369d568 ("mt76: mt7915: implement HE per-rate tx power support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c  | 5 +++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/pci.c b/drivers/net/wireless/mediatek/mt76/mt7603/pci.c
index a5845da3547a9..06fa28f645f28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/pci.c
@@ -57,7 +57,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
index 6de492a4cf025..9b191307e140e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
@@ -240,7 +240,8 @@ int mt7615_mmio_probe(struct device *pdev, void __iomem *mem_base,
 
 	return 0;
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index dda11c704abaa..b87d8e136cb9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -194,7 +194,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 4d50dad29ddff..ecaf85b483ac3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -90,7 +90,8 @@ mt76x2e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index fe62b4d853e48..3ac5bbb94d294 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -140,7 +140,7 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 	dev = container_of(mdev, struct mt7915_dev, mt76);
 	ret = mt7915_alloc_device(pdev, dev);
 	if (ret)
-		return ret;
+		goto error;
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
 	mdev->rev = (mt7915_l1_rr(dev, MT_HW_CHIPID) << 16) |
@@ -163,7 +163,8 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
+
 	return ret;
 }
 
-- 
2.27.0



