Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E266086BA
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiJVHwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiJVHvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E57AC2AC;
        Sat, 22 Oct 2022 00:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C39E60ADB;
        Sat, 22 Oct 2022 07:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A9C433D6;
        Sat, 22 Oct 2022 07:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424655;
        bh=9B4auItuu6R+2k1KwQ4JjfFlpPatjo0qE5hU/icNkEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E04x2Jxba970tn4ZmTAV5dlK8pwrCyR1QbCs08ZV+7SWC3XDz/wtWdnk1KVrsMC+7
         aXtJO/EVBlKK277zQQ8o9AHmv0QjXnthtY+OWeKn/wQVDLO26oqngWm9SLP6Y+AoMy
         5oTogm2dgXMYgRJT8eunL0sTClD9+VZVTomM/t1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 225/717] wifi: rtw89: pci: correct TX resource checking in low power mode
Date:   Sat, 22 Oct 2022 09:21:44 +0200
Message-Id: <20221022072454.934918734@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 4a29213cd775cabcbe395229d175903accedbb9d ]

Number of TX resource must be minimum of TX_BD and TX_WD. Only considering
TX_BD could drop TX packets pulled from mac80211 if TX_WD is unavailable.

Fixes: 52edbb9fb78a ("rtw89: ps: access TX/RX rings via another registers in low power mode")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220824063312.15784-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 622f95bc3ffc..bc8132e91992 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -922,10 +922,12 @@ u32 __rtw89_pci_check_and_reclaim_tx_resource_noio(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
 	struct rtw89_pci_tx_ring *tx_ring = &rtwpci->tx_rings[txch];
+	struct rtw89_pci_tx_wd_ring *wd_ring = &tx_ring->wd_ring;
 	u32 cnt;
 
 	spin_lock_bh(&rtwpci->trx_lock);
 	cnt = rtw89_pci_get_avail_txbd_num(tx_ring);
+	cnt = min(cnt, wd_ring->curr_num);
 	spin_unlock_bh(&rtwpci->trx_lock);
 
 	return cnt;
-- 
2.35.1



