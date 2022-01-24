Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91A34994EB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389505AbiAXUts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40704 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388094AbiAXUiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:38:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7664B81243;
        Mon, 24 Jan 2022 20:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CA6C340E7;
        Mon, 24 Jan 2022 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056687;
        bh=syKAXgGkNN/cd6e1sptDYNJgaiCH3RcEKn5+Joj72mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QakadFLoEXBOv+vTd7CAVT8jUH4SfgfSHKZ4cFJGpAwzCcl72e3GfG8yq3yMx9NVX
         pgWhNCSN1b44Vp54AI1G6f20MEkLZ6Vk3Madf28NzCNC9J8XSrbI6n1sY9BRxkPpfU
         9D0HRnvNDzLPmSiqunSi0MHCvvfkSaKlQldPEm3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 567/846] mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()
Date:   Mon, 24 Jan 2022 19:41:24 +0100
Message-Id: <20220124184120.586707680@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 8c55516de3f9b76b9d9444e7890682ec2efc809f ]

ieee80211_register_hw() is called with rtnl_lock held, and this could be
caused lockdep from a work item that's on a workqueue that is flushed
with the rtnl held.

Move mt7615_register_ext_phy() outside the init_work().

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index a2465b49ecd0c..87b4aa52ee0f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -28,8 +28,6 @@ static void mt7615_pci_init_work(struct work_struct *work)
 		return;
 
 	mt7615_init_work(dev);
-	if (dev->dbdc_support)
-		mt7615_register_ext_phy(dev);
 }
 
 static int mt7615_init_hardware(struct mt7615_dev *dev)
@@ -160,6 +158,12 @@ int mt7615_register_device(struct mt7615_dev *dev)
 	mt7615_init_txpower(dev, &dev->mphy.sband_2g.sband);
 	mt7615_init_txpower(dev, &dev->mphy.sband_5g.sband);
 
+	if (dev->dbdc_support) {
+		ret = mt7615_register_ext_phy(dev);
+		if (ret)
+			return ret;
+	}
+
 	return mt7615_init_debugfs(dev);
 }
 
-- 
2.34.1



