Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877E82E3EE9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392127AbgL1OeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505087AbgL1Odr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0142063A;
        Mon, 28 Dec 2020 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165986;
        bh=07tnKvvndi1F9f8lpgzudk5I7d76Hn1JE48dhrTU+7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re4kvsf5eJiwvmpAqi4UVbRKMBDuBNS0aaSNRVhUDh2f3lCJzHx3vb6Sl2cxJzpNh
         r264WcJeZesWs+X/DdSvwyFWMPkkIYPuerbZN5H9X96qGtRIdRiioKcU7UxrANlVnc
         2ro7S+ziXVwXjzw4N3IlUDpehVcJURMUf46+lpgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.10 708/717] mt76: add back the SUPPORTS_REORDERING_BUFFER flag
Date:   Mon, 28 Dec 2020 13:51:46 +0100
Message-Id: <20201228125054.912660304@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit ed89b89330b521f20682ead6bf93e1014b21a200 upstream.

It was accidentally dropped while adding multiple wiphy support
Fixes fast-rx support and avoids handling reordering in both mac80211
and the driver

Cc: stable@vger.kernel.org
Fixes: c89d36254155 ("mt76: add function for allocating an extra wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mac80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -305,6 +305,7 @@ mt76_phy_init(struct mt76_dev *dev, stru
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
 
 	if (!(dev->drv->drv_flags & MT_DRV_AMSDU_OFFLOAD)) {
 		ieee80211_hw_set(hw, TX_AMSDU);


