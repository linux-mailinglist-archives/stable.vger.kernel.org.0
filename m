Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6B4540636
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiFGRdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347726AbiFGRa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B4311AFEB;
        Tue,  7 Jun 2022 10:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 283C6CE0E13;
        Tue,  7 Jun 2022 17:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F42C385A5;
        Tue,  7 Jun 2022 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622885;
        bh=E8QtK/qtvY0B9iXnVuByMA1wdsq/LdsG42DXw/oRoLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Iwi3S0+vbZ5ChfLo8KnYHX8nEEbfDOw9ul65PRe+mcarQ1RyWlY0gMhTB2pOWdTW
         lYaY8BFYEt3D+L5lHE1Q0TSJ5+WU9V8ITghYOkLkgM5p4FsSXk0h17Ie76OiQZYic9
         QVWbJiJr9tHtPYe+BIo3aIUUVFjWui5WWhB8B2Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/452] ath11k: Dont check arvif->is_started before sending management frames
Date:   Tue,  7 Jun 2022 19:00:58 +0200
Message-Id: <20220607164914.552880447@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 355333a217541916576351446b5832fec7930566 ]

Commit 66307ca04057 ("ath11k: fix mgmt_tx_wmi cmd sent to FW for
deleted vdev") wants both of below two conditions are true before
sending management frames:

1: ar->allocated_vdev_map & (1LL << arvif->vdev_id)
2: arvif->is_started

Actually the second one is not necessary because with the first one
we can make sure the vdev is present.

Also use ar->conf_mutex to synchronize vdev delete and mgmt. TX.

This issue is found in case of Passpoint scenario where ath11k
needs to send action frames before vdev is started.

Fix it by removing the second condition.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Fixes: 66307ca04057 ("ath11k: fix mgmt_tx_wmi cmd sent to FW for deleted vdev")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220506013614.1580274-3-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b2928a5cf72e..44282aec069d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4008,8 +4008,8 @@ static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 		}
 
 		arvif = ath11k_vif_to_arvif(skb_cb->vif);
-		if (ar->allocated_vdev_map & (1LL << arvif->vdev_id) &&
-		    arvif->is_started) {
+		mutex_lock(&ar->conf_mutex);
+		if (ar->allocated_vdev_map & (1LL << arvif->vdev_id)) {
 			ret = ath11k_mac_mgmt_tx_wmi(ar, arvif, skb);
 			if (ret) {
 				ath11k_warn(ar->ab, "failed to tx mgmt frame, vdev_id %d :%d\n",
@@ -4025,6 +4025,7 @@ static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 				    arvif->is_started);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
+		mutex_unlock(&ar->conf_mutex);
 	}
 }
 
-- 
2.35.1



