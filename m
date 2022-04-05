Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16FB4F28C2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbiDEIVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiDEIGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:06:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C91569CC5;
        Tue,  5 Apr 2022 01:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF933B81B14;
        Tue,  5 Apr 2022 08:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5E7C385A1;
        Tue,  5 Apr 2022 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145709;
        bh=3B7rci6vm+gxEqP43CLYfU7pk9MUF4tG0H80bTJNQXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZNFzNg9z8Tqahft92VsTcbfqy348121AtWQQm+vyfum1YDaz30NynnETvAm3p1p2
         Oxtljf3OyEYpRbhZ19vGW/B41kKVxzJlDE4PqryWiL5i4DncyJEdpjF01cniDhlwOG
         xht4EX6tXzISb3DDXYlP1jpAXe7YF//fMxPihXag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0500/1126] mt76: mt7915: fix ht mcs in mt7915_mac_add_txs_skb()
Date:   Tue,  5 Apr 2022 09:20:47 +0200
Message-Id: <20220405070422.303076267@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit d8e4e8d148fb68858d6a997d88a87a2c615629ce ]

The mcs value of HT mode reported by mt7915_mac_add_txs_skb()
has already been converted to the expected format.

Fixes: 9908d98ae72cd ("mt76: mt7915: report tx rate directly from tx status")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 48f115502282..d18a2e93cff5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1512,7 +1512,6 @@ mt7915_mac_add_txs_skb(struct mt7915_dev *dev, struct mt76_wcid *wcid, int pid,
 		break;
 	case MT_PHY_TYPE_HT:
 	case MT_PHY_TYPE_HT_GF:
-		rate.mcs += (rate.nss - 1) * 8;
 		if (rate.mcs > 31)
 			goto out;
 
-- 
2.34.1



