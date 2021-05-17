Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C408A382F17
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbhEQONF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236441AbhEQOLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA3DD613CE;
        Mon, 17 May 2021 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260465;
        bh=B+IHTmOX6U/yt3aMa3Mp9RTA6fBRTDDNgafWLvQ6EfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj077OrL8licA8p1eNv7/Wc0mPZe6ODL6jb/HKyGYD924jNbLZzn3Akw9Rc5JDCfD
         QXYKcXz2nro1mOkuITVwn/NYDamJKhjK15uTp7dGHSILcYHgyuc8TWDt4bS9U55k27
         B19c2EFEtWO+E0eQl1WMNxbuo3REv89CGXfq9bpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 066/363] mt76: connac: always check return value from mt76_connac_mcu_alloc_wtbl_req
Date:   Mon, 17 May 2021 15:58:52 +0200
Message-Id: <20210517140304.838736374@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit baa3afb39e94965f4ca5b5d3d274379504b8fa24 ]

Even if this is not a real bug since mt76_connac_mcu_alloc_wtbl_req routine
can fails just if nskb is NULL , always check return value from
mt76_connac_mcu_alloc_wtbl_req in order to avoid possible future
mistake.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 631596fc2f36..4ecbd5406e2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1040,6 +1040,9 @@ mt7615_mcu_sta_ba(struct mt7615_dev *dev,
 
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(&dev->mt76, &msta->wcid,
 						  WTBL_SET, sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt76_connac_mcu_wtbl_ba_tlv(&dev->mt76, skb, params, enable, tx,
 				    sta_wtbl, wtbl_hdr);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 76a61e8b7fb9..cefd33b74a87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -833,6 +833,9 @@ int mt76_connac_mcu_add_sta_cmd(struct mt76_phy *phy,
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(dev, wcid,
 						  WTBL_RESET_AND_SET,
 						  sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	if (enable) {
 		mt76_connac_mcu_wtbl_generic_tlv(dev, skb, vif, sta, sta_wtbl,
 						 wtbl_hdr);
-- 
2.30.2



