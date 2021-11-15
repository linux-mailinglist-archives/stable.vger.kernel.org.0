Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63A450D85
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhKOR7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239292AbhKOR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 381EC60234;
        Mon, 15 Nov 2021 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997650;
        bh=1wbu2UDNVvG4pGmKsS4xC+JaJVLy+awbAXuvYuBPrwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgW5pwLPj7gF5nKquhcEkEpDtp/dCzstq/UjpHZRjZS6IdxopF2rdzkP1zVRAzOr2
         ycMad5ZfRhnTP7nLWOcubIBrXPnWHAiTN5cOch0qrMP4c7tsPQGPsNWR0YciPh3xJ0
         D1uJo2NanHo+F6EriWXQnP9Y/qHBtUgrNRALG2AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/575] mt76: mt7915: fix an off-by-one bound check
Date:   Mon, 15 Nov 2021 17:59:11 +0100
Message-Id: <20211115165351.534442531@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit d45dac0732a287fc371a23f257cce04e65627947 ]

The bounds check on datalen is off-by-one, so fix it.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ea71409751519..7c2d09a64882e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -830,7 +830,7 @@ static void mt7915_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 
 	elem = ieee80211_bss_get_elem(bss, WLAN_EID_EXT_CAPABILITY);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen <= 10 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT))
 		data->tolerated = false;
-- 
2.33.0



