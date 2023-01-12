Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3EE66753E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjALOTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjALOTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C879158D13
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6664D6202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46919C433EF;
        Thu, 12 Jan 2023 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532649;
        bh=ggaHZDIhWgyy59i+LG7c5MJLm+sWHFU8wo0iCjr8F/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mn2nV83AvcmBK3/mQ7kcD0sdkA/dMaOBEZoWGwTfQ3e7EXwmDg0n8KHIztHCRVDkt
         qXBFnJEh5YzW3CkgjBwsAO6QEjn/+id7vd2aEDf+xAGOzAHUvD+AhR/3DEZ/E6XSZS
         xqTvA3pZcwVceCYfu+DEY+G1xbWBDpAJr65pmmcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/783] wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
Date:   Thu, 12 Jan 2023 14:48:40 +0100
Message-Id: <20230112135533.796097528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 03dd0d49de7db680a856fa566963bb8421f46368 ]

Make sure the nss is valid for nss_delta array. Return zero
if the index is invalid.

Coverity message:
Event overrun-call: Overrunning callee's array of size 4 by passing
argument "n_chains" (which evaluates to 15) in call to
"mt76_tx_power_nss_delta".
int delta = mt76_tx_power_nss_delta(n_chains);

Fixes: 07cda406308b ("mt76: fix rounding issues on converting per-chain and combined txpower")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a5be66de1cff..5a8060790a61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -884,8 +884,9 @@ static inline bool mt76_is_skb_pktid(u8 pktid)
 static inline u8 mt76_tx_power_nss_delta(u8 nss)
 {
 	static const u8 nss_delta[4] = { 0, 6, 9, 12 };
+	u8 idx = nss - 1;
 
-	return nss_delta[nss - 1];
+	return (idx < ARRAY_SIZE(nss_delta)) ? nss_delta[idx] : 0;
 }
 
 static inline bool mt76_testmode_enabled(struct mt76_dev *dev)
-- 
2.35.1



