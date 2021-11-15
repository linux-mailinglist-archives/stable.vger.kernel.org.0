Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5182A4513BE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbhKOTze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343961AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59EBA61507;
        Mon, 15 Nov 2021 18:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002180;
        bh=2Csa3RlP8oQ3zepQJ0ewM1F0WOsacMoWO32ZvvS0ekg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzDqKkwVeGb9oZX3bPaXlPtI50MFGzBakPDUIYKrJ5R7UpwoxO8XHH24SvRXH24fc
         yA4zcAKuhKPZQe13CJuckIEe7DOrJEa+iYD1KreRAv7LnTxkG+EmmGHiMEUlah6xLB
         uax/CAWdAuLnfnSLG3zs1neRv+ZP/5/2qe01NIeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/917] mt76: mt7915: fix bit fields for HT rate idx
Date:   Mon, 15 Nov 2021 17:59:23 +0100
Message-Id: <20211115165444.640703784@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 47f1c08db7f3aaa2d13f8e56209375462ace7b8a ]

The bit fields of tx rate idx should be 6 bits, otherwise it might be
incorrect in HT mode.
For VHT/HE rates, only 4 bits are actually used by rate idx, the other
2 bits are used for other functions.

Fixes: c31d94af1843 ("mt76: mt7915: fix tx rate related fields in tx descriptor")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.h b/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
index eb1885f4bd8eb..fee7741b5d421 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
@@ -272,7 +272,8 @@ enum tx_mcu_port_q_idx {
 #define MT_TX_RATE_MODE			GENMASK(9, 6)
 #define MT_TX_RATE_SU_EXT_TONE		BIT(5)
 #define MT_TX_RATE_DCM			BIT(4)
-#define MT_TX_RATE_IDX			GENMASK(3, 0)
+/* VHT/HE only use bits 0-3 */
+#define MT_TX_RATE_IDX			GENMASK(5, 0)
 
 #define MT_TXP_MAX_BUF_NUM		6
 
-- 
2.33.0



