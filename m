Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8C760486B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiJSN4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiJSNyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7DE1DDC21;
        Wed, 19 Oct 2022 06:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068E7B82386;
        Wed, 19 Oct 2022 08:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A77BC433D7;
        Wed, 19 Oct 2022 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169442;
        bh=NFjboH5Ssva6H4YiEcOPIbsLI+ky7p8zequ7ek/+zBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3pVIZnX0Di40y1c+KHerC/uNdQViD3pLrP+ccidM+IlLY3CLpMK147FHP0N95OYd
         iXw0OE4F5uFqkaSbKRm1ylYIg+XZp9fpKlFAHs2OUcvfgIePCJxrtvEqQfhzCFGy2V
         SRiTqkOaA2wZaY0ou9Ocb7CPK+yIY76HNui1jqBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 279/862] wifi: mt76: sdio: poll sta stat when device transmits data
Date:   Wed, 19 Oct 2022 10:26:06 +0200
Message-Id: <20221019083302.353274253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fb2caeae6dba..ece4e4bb94a1 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -478,7 +478,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 		if (ndata_frames > 0)
 			resched = true;
 
-		if (dev->drv->tx_status_data &&
+		if (dev->drv->tx_status_data && ndata_frames > 0 &&
 		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
 		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
 			ieee80211_queue_work(dev->hw, &dev->sdio.stat_work);
-- 
2.35.1



