Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7CB5412E9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357276AbiFGTzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358431AbiFGTw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946FDEFF17;
        Tue,  7 Jun 2022 11:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DDC0B82239;
        Tue,  7 Jun 2022 18:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED47C385A2;
        Tue,  7 Jun 2022 18:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626024;
        bh=B7+TLIpamswXZAjKolO5qXIuezHKavchvj0PzWpvahY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCWZ54sh8U6nwKr7j55cfTgfxQj/6OBK5b5Ux2fHyw0x24kgjjjoeyiUEBz4C2IXv
         exNhCakPVzATPHhrDatyRTHsv6zq8J6PAZGSKKahoR3C/hIAtED2SxmCQdffXzWWeW
         FKe3Oqb0rQ+nb92ogqMya+6jFZ8r9eni5vjks01o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 230/772] ath11k: acquire ab->base_lock in unassign when finding the peer by addr
Date:   Tue,  7 Jun 2022 18:57:02 +0200
Message-Id: <20220607164955.809651781@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 2db80f93869d491be57cbc2b36f30d0d3a0e5bde ]

ath11k_peer_find_by_addr states via lockdep that ab->base_lock must be
held when calling that function in order to protect the list. All
callers except ath11k_mac_op_unassign_vif_chanctx have that lock
acquired when calling ath11k_peer_find_by_addr. That lock is also not
transitively held by a path towards ath11k_mac_op_unassign_vif_chanctx.
The solution is to acquire the lock when calling
ath11k_peer_find_by_addr inside ath11k_mac_op_unassign_vif_chanctx.

I am currently working on a static analyser to detect missing locks and
this was a reported case. I manually verified the report by looking at
the code, but I do not have real hardware so this is compile tested
only.

Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220314215253.92658-1-dossche.niels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b2dac859dfe1..16b45b742f9d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7068,6 +7068,7 @@ ath11k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath11k *ar = hw->priv;
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_vif *arvif = (void *)vif->drv_priv;
+	struct ath11k_peer *peer;
 	int ret;
 
 	mutex_lock(&ar->conf_mutex);
@@ -7079,9 +7080,13 @@ ath11k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	WARN_ON(!arvif->is_started);
 
 	if (ab->hw_params.vdev_start_delay &&
-	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR &&
-	    ath11k_peer_find_by_addr(ab, ar->mac_addr))
-		ath11k_peer_delete(ar, arvif->vdev_id, ar->mac_addr);
+	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
+		spin_lock_bh(&ab->base_lock);
+		peer = ath11k_peer_find_by_addr(ab, ar->mac_addr);
+		spin_unlock_bh(&ab->base_lock);
+		if (peer)
+			ath11k_peer_delete(ar, arvif->vdev_id, ar->mac_addr);
+	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR) {
 		ret = ath11k_mac_monitor_stop(ar);
-- 
2.35.1



