Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812B9451DE9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhKPAea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343955AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FCDA6360F;
        Mon, 15 Nov 2021 18:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002159;
        bh=1JJY+d1hilmZPQB4fO71zQCsWNuLLbJf8RR3944VvFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiXQ23raZo03qp2g8qepLKKO2zPARxM6YncP7woX/ahUauUcEmlZyGoywAObtXs2R
         b0lP2OssgqGT7LsQBByqOpIUowYU2a9D3vY3aYIRas5WlNVgSQDsbfWJiQ0bFyke5v
         bhCc4CMl3qMM9xG4MhsaqlBCQl10VDygNLfoSdcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/917] mt76: mt7915: fix info leak in mt7915_mcu_set_pre_cal()
Date:   Mon, 15 Nov 2021 17:59:16 +0100
Message-Id: <20211115165444.407565141@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3924715ffe5e064a85f56490f77b7b2084230800 ]

Zero out all the unused members of "req" so that we don't disclose
stack information.

Fixes: 495184ac91bb ("mt76: mt7915: add support for applying pre-calibration data")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 2f30047bd80f2..caf2033c5c17e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3481,7 +3481,7 @@ static int mt7915_mcu_set_pre_cal(struct mt7915_dev *dev, u8 idx,
 		u8 idx;
 		u8 rsv[4];
 		__le32 len;
-	} req;
+	} req = {};
 	struct sk_buff *skb;
 
 	skb = mt76_mcu_msg_alloc(&dev->mt76, NULL, sizeof(req) + len);
-- 
2.33.0



