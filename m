Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80460870A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiJVHzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiJVHyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF91951CA;
        Sat, 22 Oct 2022 00:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A08660AFA;
        Sat, 22 Oct 2022 07:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BD9C433C1;
        Sat, 22 Oct 2022 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424832;
        bh=z8354MLPzt46BjyGsVWJYbQLbpGutp1mNQkt1bEaeCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvCwJcpQSfuWcMgpTVuRMYlq/K9SyMkvgnT0jzIsYRnYME8/F4dN72mvx1bMo9UdQ
         Zw2cTho2qSD071QIf8/ThbnPm8LyeHyEhHPpy2SZgyjZ48sPz/Sya4Xi3WybjljYVK
         BldVMnrJIHBvQkTwjO0IlwD7WM4NZfCPvPO4Rf8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Ansuel Marangi <ansuelsmth@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 263/717] wifi: ath11k: fix peer addition/deletion error on sta band migration
Date:   Sat, 22 Oct 2022 09:22:22 +0200
Message-Id: <20221022072501.174437947@linuxfoundation.org>
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

From: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>

[ Upstream commit d673cb6fe6c03b2be157cc6c5db40481828d282d ]

This patch try to fix the following error.

Wed Jun  1 22:19:30 2022 kern.warn kernel: [  119.561227] ath11k c000000.wifi: peer already added vdev id 0 req, vdev id 1 present
Wed Jun  1 22:19:30 2022 kern.warn kernel: [  119.561282] ath11k c000000.wifi: Failed to add peer: 28:c2:1f:xx:xx:xx for VDEV: 0
Wed Jun  1 22:19:30 2022 kern.warn kernel: [  119.568053] ath11k c000000.wifi: Failed to add station: 28:c2:1f:xx:xx:xx for VDEV: 0
Wed Jun  1 22:19:31 2022 daemon.notice hostapd: wlan2: STA 28:c2:1f:xx:xx:xx IEEE 802.11: Could not add STA to kernel driver
Wed Jun  1 22:19:31 2022 daemon.notice hostapd: wlan2: STA 28:c2:1f:xx:xx:xx IEEE 802.11: did not acknowledge authentication response
Wed Jun  1 22:19:31 2022 daemon.notice hostapd: wlan1: AP-STA-DISCONNECTED 28:c2:1f:xx:xx:xx
Wed Jun  1 22:19:31 2022 daemon.info hostapd: wlan1: STA 28:c2:1f:xx:xx:xx IEEE 802.11: disassociated due to inactivity
Wed Jun  1 22:19:32 2022 daemon.info hostapd: wlan1: STA 28:c2:1f:xx:xx:xx IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)

To repro this:
- Have 2 Wifi with the same bssid and pass on different band (2.4 and
5GHz)
- Enable 802.11r Fast Transaction with same mobility domain
- FT Protocol: FT over the Air
>From a openwrt system issue the command (with the correct mac)
ubus call hostapd.wlan1 wnm_disassoc_imminent '{"addr":"28:C2:1F:xx:xx:xx"}'
Notice the log printing the errors.

The cause of this error has been investigated and we found that this is
related to the WiFi Fast Transaction feature. We observed that this is
triggered when the router tells the device to change band. In this case
the device first auth to the other band and then the disconnect path
from the prev band is triggered.
This is problematic with the current rhash implementation since the
addrs is used as key and the logic of "adding first, delete later"
conflicts with the rhash logic.
In fact peer addition will fail since the peer is already added and with
that fixed a peer deletion will cause unitended effect by removing the
peer just added.

Current solution to this is to add additional logic to the peer delete,
make sure we are deleting the correct peer taken from the rhash
table (and fallback to the peer list) and for the peer add logic delete
the peer entry for the rhash list before adding the new one (counting as
an error only when a peer with the same vlan_id is asked to be added).

With this change, a sta can correctly transition from 2.4GHz and 5GHZ
with no drop and no error are printed.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Fixes: 7b0c70d92a43 ("ath11k: Add peer rhash table support")
Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220603164559.27769-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/peer.c | 30 ++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index 9e22aaf34b88..1ae7af02c364 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -302,6 +302,21 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
 	spin_lock_bh(&ab->base_lock);
 
 	peer = ath11k_peer_find_by_addr(ab, addr);
+	/* Check if the found peer is what we want to remove.
+	 * While the sta is transitioning to another band we may
+	 * have 2 peer with the same addr assigned to different
+	 * vdev_id. Make sure we are deleting the correct peer.
+	 */
+	if (peer && peer->vdev_id == vdev_id)
+		ath11k_peer_rhash_delete(ab, peer);
+
+	/* Fallback to peer list search if the correct peer can't be found.
+	 * Skip the deletion of the peer from the rhash since it has already
+	 * been deleted in peer add.
+	 */
+	if (!peer)
+		peer = ath11k_peer_find(ab, vdev_id, addr);
+
 	if (!peer) {
 		spin_unlock_bh(&ab->base_lock);
 		mutex_unlock(&ab->tbl_mtx_lock);
@@ -312,8 +327,6 @@ static int __ath11k_peer_delete(struct ath11k *ar, u32 vdev_id, const u8 *addr)
 		return -EINVAL;
 	}
 
-	ath11k_peer_rhash_delete(ab, peer);
-
 	spin_unlock_bh(&ab->base_lock);
 	mutex_unlock(&ab->tbl_mtx_lock);
 
@@ -372,8 +385,17 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 	spin_lock_bh(&ar->ab->base_lock);
 	peer = ath11k_peer_find_by_addr(ar->ab, param->peer_addr);
 	if (peer) {
-		spin_unlock_bh(&ar->ab->base_lock);
-		return -EINVAL;
+		if (peer->vdev_id == param->vdev_id) {
+			spin_unlock_bh(&ar->ab->base_lock);
+			return -EINVAL;
+		}
+
+		/* Assume sta is transitioning to another band.
+		 * Remove here the peer from rhash.
+		 */
+		mutex_lock(&ar->ab->tbl_mtx_lock);
+		ath11k_peer_rhash_delete(ar->ab, peer);
+		mutex_unlock(&ar->ab->tbl_mtx_lock);
 	}
 	spin_unlock_bh(&ar->ab->base_lock);
 
-- 
2.35.1



