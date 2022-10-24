Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB03A60ACCB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiJXOQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiJXOOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A729B86C;
        Mon, 24 Oct 2022 05:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7AA461350;
        Mon, 24 Oct 2022 12:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E43C433C1;
        Mon, 24 Oct 2022 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615984;
        bh=5wnxw6C7mEaBmctzT+ji9b0d4mmzMnevfMMXcjoG3Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4yEtn2EkCJM0iuetWCKXXHvIQ47oFzqjVGxIUmodULgSUcgxeiuHPgs4hEMv7u4N
         OlRQ+moRm0PE4+w5Yyg+sjhrmzl2kEdEVTU60AqBbLLfxnVbX16LJF0gT7zX+tMktr
         Ee88nAmAwMNXtEFkg+VW9Eb/lnfkEDOuoyty+tXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/530] wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value
Date:   Mon, 24 Oct 2022 13:32:54 +0200
Message-Id: <20221024113104.550982157@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 1bf66dc31032ff5292f4d5b76436653f269fcfbd ]

We should reset mstat->airtime_ac along with clear up the entries in the
hardware WLAN table for the Rx and Rx accumulative airtime. Otherwsie, the
value msta->airtime_ac - [tx, rx]_last may be a negative and that is not
the actual airtime the device took in the last run.

Reported-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6cb65391427f..7b48df301079 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -627,6 +627,7 @@ void mt7921_mac_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 
 	mt7921_mac_wtbl_update(dev, msta->wcid.idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+	memset(msta->airtime_ac, 0, sizeof(msta->airtime_ac));
 
 	mt7921_mcu_sta_update(dev, sta, vif, true, MT76_STA_INFO_STATE_ASSOC);
 
-- 
2.35.1



