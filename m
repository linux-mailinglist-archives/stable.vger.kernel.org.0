Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217BB37CE60
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbhELRFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244296AbhELQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3369C61D2C;
        Wed, 12 May 2021 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835907;
        bh=s2/jRYkDy6iaZrXnJAX1zLFuujZ7N3N0efbmrLWFqEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecSe5gqQyCUFSY8j2HDDpcHRIkA4dSg4EOpQ54n1h8L6n0lvltjm0gHEAv4MDWoE9
         htAh7T8Q0j77Zx17u96pa29+/fcCcC231cP4IyH6As8bsBhd+4dul1IKSwrhCQR3vI
         buvC53MQUNxVvv3fGolyyVuS+pV6dbB5VA+2mGQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 525/677] mt76: mt7915: fix aggr len debugfs node
Date:   Wed, 12 May 2021 16:49:31 +0200
Message-Id: <20210512144854.831192360@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9fb9d755fae20b5ad62ef8b4e9289e5baea2c6fc ]

Similar to mt7921, fix 802.11 aggr len debugfs reporting for mt7915 driver.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 77dcd71e49a5..2f706620686e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -124,7 +124,7 @@ mt7915_ampdu_stat_read_phy(struct mt7915_phy *phy,
 		range[i] = mt76_rr(dev, MT_MIB_ARNG(ext_phy, i));
 
 	for (i = 0; i < ARRAY_SIZE(bound); i++)
-		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i) + 1;
+		bound[i] = MT_MIB_ARNCR_RANGE(range[i / 4], i % 4) + 1;
 
 	seq_printf(file, "\nPhy %d\n", ext_phy);
 
-- 
2.30.2



