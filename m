Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5477311D1B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfEBP2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfEBP2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61FD2177B;
        Thu,  2 May 2019 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810932;
        bh=ijzTTViMk4iWd8MVa5mHOrgfgm075r/82qL/wZFE5iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJOrQXW/FHph4sbHVKDSxDHXGkPAoY+em/ZCnqggyHlE5LOz2de1FEcQjg0Hg6FYx
         hmg/Edpc/sYjXH5pYjgb8V/p/pHm4MemhdoHvvqnUtlIz0oE3HmyzMHVrnbuDmypSJ
         Jq3CwIbyqLwxPV0Ox3uFKxbYF4Xl4IQE7nVYUwT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 012/101] mt76: mt76x2: fix external LNA gain settings
Date:   Thu,  2 May 2019 17:20:14 +0200
Message-Id: <20190502143340.998426756@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 45a042e3026824a7e910db7a4dd38fef0540b902 ]

Devices with external LNA need different values for AGC registers 8 and 9

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index c9634a774705..11167b7af668 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -260,10 +260,15 @@ mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 	gain_val[0] = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
 	gain_val[1] = dev->cal.agc_gain_cur[1] - dev->cal.agc_gain_adjust;
 
-	if (dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
+	val = 0x1836 << 16;
+	if (!mt76x2_has_ext_lna(dev) &&
+	    dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
 		val = 0x1e42 << 16;
-	else
-		val = 0x1836 << 16;
+
+	if (mt76x2_has_ext_lna(dev) &&
+	    dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ &&
+	    dev->mt76.chandef.width < NL80211_CHAN_WIDTH_40)
+		val = 0x0f36 << 16;
 
 	val |= 0xf8;
 
-- 
2.19.1



