Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF0D657E4A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiL1Pwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiL1PwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467B2186C1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA9C661562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87AEC433D2;
        Wed, 28 Dec 2022 15:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242734;
        bh=9isJzObK1fz5kLZly/vR8zYnFnKh9qDMeh0qxKWWqk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+WxZVDavFXyFXiLI4DmOJSMlBeHXYUQ44bMp3s8Uf3GCFCiFchzOqjdUZT4k8Nlj
         aG0SLO/+cHaoDNdVh3junJoGstO4u04IboAMT2lPjlcR7u4PGaIsd77s8AP19VRP0V
         QE0VdIjpNDoZ0lLm5ZIiAkkfoWvM5sPdPeUvRxjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0445/1073] wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
Date:   Wed, 28 Dec 2022 15:33:53 +0100
Message-Id: <20221228144340.117563439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 4da77d47b0a6..1f8da524a305 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1101,8 +1101,9 @@ static inline bool mt76_is_skb_pktid(u8 pktid)
 static inline u8 mt76_tx_power_nss_delta(u8 nss)
 {
 	static const u8 nss_delta[4] = { 0, 6, 9, 12 };
+	u8 idx = nss - 1;
 
-	return nss_delta[nss - 1];
+	return (idx < ARRAY_SIZE(nss_delta)) ? nss_delta[idx] : 0;
 }
 
 static inline bool mt76_testmode_enabled(struct mt76_phy *phy)
-- 
2.35.1



