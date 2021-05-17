Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81A338341B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbhEQPF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241038AbhEQPCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F215461A0F;
        Mon, 17 May 2021 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261660;
        bh=PYEZy+o/d4XEqCxocBCi/YNgBQBtU3X4yF0Be6Eo66o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foAnSfG16UlbMgqMp5o9lRtlOHp0y7gV50E6bT3KMa6KUhHoIrfePKsMQdKdQaw1R
         bmo5XYqXnDR/PE8ksJGY1tB+ir/jlP5IYJONF8gnvmA5TYL3ceJr71b1hWjU3BGWYq
         WRlgGBgBgeY54uiTF0YI68Tn7mquS+mzM/HNsKXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Stijn Segers <foss@volatilesystems.org>,
        Sander Vanheule <sander@svanheule.net>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/289] mt76: mt7615: support loading EEPROM for MT7613BE
Date:   Mon, 17 May 2021 15:59:33 +0200
Message-Id: <20210517140306.816969180@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 858ebf446bee7d5077bd99488aae617908c3f4fe ]

EEPROM blobs for MT7613BE radios start with (little endian) 0x7663,
which is also the PCI device ID for this device. The EEPROM is required
for the radio to work at useful power levels, otherwise only the lowest
power level is available.

Suggested-by: Georgi Vlaev <georgi.vlaev@konsulko.com>
Tested-by: Stijn Segers <foss@volatilesystems.org>
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index f4756bb946c3..e9cdcdc54d5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -86,6 +86,7 @@ static int mt7615_check_eeprom(struct mt76_dev *dev)
 	switch (val) {
 	case 0x7615:
 	case 0x7622:
+	case 0x7663:
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.30.2



