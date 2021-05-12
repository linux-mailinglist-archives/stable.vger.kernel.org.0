Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2737CE25
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhELRDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244149AbhELQmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851C961D24;
        Wed, 12 May 2021 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835869;
        bh=1Z206rr+ID4sR0PVskAJ2Dfihs0zrPdTKGcuV4niXbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfTQr0Dh3CsO4LrOisY0Bt0iKJ4nrBYadPgBC4pG6jtBDrHsvwgbCHhrNhUw4HHRd
         AtDr41pmiD0sLJDlBC2rUO5Y81I8oNqmMmkVEF+lFD8unteWPe+D09lHZFReQ4ByBZ
         MwpFWdPMtUN8V3RSwuRkWohyzqFXqfTQtmoV/p+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 516/677] mt7601u: fix always true expression
Date:   Wed, 12 May 2021 16:49:22 +0200
Message-Id: <20210512144854.530086442@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 87fce88658ba047ae62e83497d3f3c5dc22fa6f9 ]

Currently the expression ~nic_conf1 is always true because nic_conf1
is a u16 and according to 6.5.3.3 of the C standard the ~ operator
promotes the u16 to an integer before flipping all the bits. Thus
the top 16 bits of the integer result are all set so the expression
is always true.  If the intention was to flip all the bits of nic_conf1
then casting the integer result back to a u16 is a suitabel fix.

Interestingly static analyzers seem to thing a bitwise ! should be
used instead of ~ for this scenario, so I think the original intent
of the expression may need some extra consideration.

Addresses-Coverity: ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210225183241.1002129-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index c868582c5d22..aa3b64902cf9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -99,7 +99,7 @@ mt7601u_has_tssi(struct mt7601u_dev *dev, u8 *eeprom)
 {
 	u16 nic_conf1 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_1);
 
-	return ~nic_conf1 && (nic_conf1 & MT_EE_NIC_CONF_1_TX_ALC_EN);
+	return (u16)~nic_conf1 && (nic_conf1 & MT_EE_NIC_CONF_1_TX_ALC_EN);
 }
 
 static void
-- 
2.30.2



