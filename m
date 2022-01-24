Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A049A288
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365802AbiAXXvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575156AbiAXWyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:54:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF8BC0F0540;
        Mon, 24 Jan 2022 13:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1F3E6149E;
        Mon, 24 Jan 2022 21:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F02CC340E7;
        Mon, 24 Jan 2022 21:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058544;
        bh=yxmUWDxo0QK6+OQVC9KcXWy/LiQA2z+wdDrXTXeVaZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx3bIqXYBVb1NvHjQbCUgFOej9/mRxRpK6huBv2rljg64M2ZARo8biNkNbGumRkHQ
         Ytqxu+dUeSipWu5OlPGyEeZoudQOWJJyd1rsZ+toU5cK6/xcWxwDGFRxHle0dnFeON
         WFNAjGeXUFGol/RAmxkUaNKswCmz9NPKOn4Iu08w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0323/1039] mt76: mt7921s: fix suspend error with enlarging mcu timeout value
Date:   Mon, 24 Jan 2022 19:35:12 +0100
Message-Id: <20220124184136.154834917@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 1bb42a354d8ca2888c7c2fcbf0add410176a33dc ]

Fix the false positive suspend error that may occur on mt7921s
with enlarging mcu timeout value.

The reason why we have to enlarge mcu timeout from HZ / 3 to HZ is
we should consider the additional overhead caused by running
concurrently with btmtksdio (a MT7921 bluetooth SDIO driver) that
would compete for the same SDIO bus in process context to complete
the suspend procedure.

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index e741db152c0d2..1cc1c32ca258e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -229,7 +229,7 @@ int mt7921_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	if (cmd == MCU_UNI_CMD(HIF_CTRL) ||
 	    cmd == MCU_UNI_CMD(SUSPEND) ||
 	    cmd == MCU_UNI_CMD(OFFLOAD))
-		mdev->mcu.timeout = HZ / 3;
+		mdev->mcu.timeout = HZ;
 	else
 		mdev->mcu.timeout = 3 * HZ;
 
-- 
2.34.1



