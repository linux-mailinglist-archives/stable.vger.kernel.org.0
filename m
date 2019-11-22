Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD498106D54
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfKVK7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730387AbfKVK7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE1720706;
        Fri, 22 Nov 2019 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420350;
        bh=IWdzDFSf/TRr9ci4D2Ci/WM12+j7L/sItckgGxtTqy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBuO29+NCMUhIootlDXcvwYv6X9HK5HjYGvP0XJUMrHQ/J3totu1I7cxyybKj4fYh
         i5H1/3+8m4VyVy3t/d3KT5ciMtnaCkDPC3C5ElDWVs6I4vLPDtJ1hjKnzSi793ap2n
         JwCmqs8EPZorYG6JT/OszOHIIz8v+21SvyuMhHMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/220] mt76: fix handling ps-poll frames
Date:   Fri, 22 Nov 2019 11:26:38 +0100
Message-Id: <20191122100914.763259022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36d910960fae3f9e74bedf3e0ef39ee26bdaa51f ]

Hardware station lookup for pspoll frames can fail, which makes the driver
ignore ps-poll frames. Fix the resulting powersave issues by looking up
the station for pspoll frames in software

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ade4a2029a24a..1b5abd4816ed7 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -548,6 +548,12 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 	struct mt76_wcid *wcid = status->wcid;
 	bool ps;
 
+	if (ieee80211_is_pspoll(hdr->frame_control) && !wcid) {
+		sta = ieee80211_find_sta_by_ifaddr(dev->hw, hdr->addr2, NULL);
+		if (sta)
+			wcid = status->wcid = (struct mt76_wcid *) sta->drv_priv;
+	}
+
 	if (!wcid || !wcid->sta)
 		return;
 
-- 
2.20.1



