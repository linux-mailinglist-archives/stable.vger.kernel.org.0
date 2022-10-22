Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A50460894F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJVIci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJVIb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A232F2E5E03;
        Sat, 22 Oct 2022 01:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA649B82E1B;
        Sat, 22 Oct 2022 07:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A45C433D7;
        Sat, 22 Oct 2022 07:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424692;
        bh=D8oIh+1zXiFFvPpS+HgYcc84mQJZmkJPdY0WfYVOJTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYy2RHtPQC+xoeIzgSdhrNONTfTAOlrrLige04YJRWst4pOmnZESgmpYc1bfcHzgX
         Fwpou9YRKsBrTd+w+uwm6gudJhNJYAQCCgkTF5jISw4ki3tzkPwk67v6LCd3KWACfH
         f1xwRn+xp5ayhMJN3BzO9wPrmuqlY6nQqNJt4s4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 241/717] wifi: mt76: sdio: poll sta stat when device transmits data
Date:   Sat, 22 Oct 2022 09:22:00 +0200
Message-Id: <20221022072457.603810048@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit a323e5f041dd11af5e3de19ed7ea95a97d588c11 ]

It is not meaningful to poll sta stat when there is no data traffic.
So polling sta stat when the device has transmitted data instead to save
CPU power.

That implies that it is unallowed the stat_work to work while MCU is being
initialized in the really early stage to fix the possible time to time MCU
initialization failure.

Fixes: d39b52e31aa6 ("mt76: introduce mt76_sdio module")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 574687ca93a9..fa54ee112b0b 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -480,7 +480,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 		if (ndata_frames > 0)
 			resched = true;
 
-		if (dev->drv->tx_status_data &&
+		if (dev->drv->tx_status_data && ndata_frames > 0 &&
 		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
 		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
 			ieee80211_queue_work(dev->hw, &dev->sdio.stat_work);
-- 
2.35.1



