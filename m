Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF08499972
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455366AbiAXVfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46924 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452794AbiAXV0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:26:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1302661320;
        Mon, 24 Jan 2022 21:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20732C340E4;
        Mon, 24 Jan 2022 21:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059595;
        bh=syKAXgGkNN/cd6e1sptDYNJgaiCH3RcEKn5+Joj72mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwL7mIcRKNrtdRnVhXugrE7R6u7XLI+qBs6BWTgZ/D3IQFdBisEBlgxpnBqdhyJdI
         hETtNEJYu4nqYFijQ8INpb0BCw/lYycFgY/rKHcNiZ47Z8N0J5sl7Udymfuc5GOK1y
         k8quSd+1LKbTms3RLOtgFvoZfLi/tul/s34h5bUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0669/1039] mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()
Date:   Mon, 24 Jan 2022 19:40:58 +0100
Message-Id: <20220124184147.862142126@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



