Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DE56AE96A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjCGRXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCGRXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445CC99D57
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01EFDB819A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DFEC433EF;
        Tue,  7 Mar 2023 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209539;
        bh=6rfxfOttElUOCbqxFL7QbGUudtFYCLMDu0nNTdz6wbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0e1W+jkhoJuNsCQzG6wK3BJ9/mOlB/FER40CsAxWtWZWnQsCWM1cSc3qYqwJNkhDB
         XcGAzp7AJO/P5DNKzmpBmAD41F95kbDy/yUv4lVM/hi9GFaYqVwDEv7dRR1Cup795V
         0ogWh+p1RLYmxUsU4e7HRTwPDhnxSerWIDNMDhdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sujuan Chen <sujuan.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0250/1001] wifi: mt76: mt7915: fix WED TxS reporting
Date:   Tue,  7 Mar 2023 17:50:22 +0100
Message-Id: <20230307170032.642929584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 0d7084e209a9e2c924cb0d6e7f1f978db2a54127 ]

The previous commit forgot to remove a leftover check.

Fixes: 43eaa3689507 ("wifi: mt76: add PPDU based TxS support for WED device")
Reported-By: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index f0d5a3603902a..1a6def77db571 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1061,9 +1061,6 @@ static void mt7915_mac_add_txs(struct mt7915_dev *dev, void *data)
 	u16 wcidx;
 	u8 pid;
 
-	if (le32_get_bits(txs_data[0], MT_TXS0_TXS_FORMAT) > 1)
-		return;
-
 	wcidx = le32_get_bits(txs_data[2], MT_TXS2_WCID);
 	pid = le32_get_bits(txs_data[3], MT_TXS3_PID);
 
-- 
2.39.2



