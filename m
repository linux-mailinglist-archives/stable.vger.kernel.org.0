Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE280541AB3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356644AbiFGVgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380214AbiFGVet (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:34:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1690176D55;
        Tue,  7 Jun 2022 12:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EAACB822C0;
        Tue,  7 Jun 2022 19:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DB8C385A5;
        Tue,  7 Jun 2022 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628670;
        bh=wEKKenlvPb1mVxBs0kYMNPZMdqG1HK4ATWQH0fnv72Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfQ84Bg0EVX0xxJak6MMQXbJ+X0k5rZqckIhnQ2QVTrCkFvjhSCcZdcc/xnqBscWB
         VjgwW5TSDvA/DZT8N2rgHdaIgtslrNdgXqR/hqoRC2o5bylxgSxIB9NrjmEDAwXD+D
         6P5VqBd1/uQc8l3wJuSBX/p4ka+J3BaBZZpcYWLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 411/879] ath11k: Dont check arvif->is_started before sending management frames
Date:   Tue,  7 Jun 2022 18:58:49 +0200
Message-Id: <20220607165014.793023265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 2c8d5f2a0517..54d738bdee0e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5520,8 +5520,8 @@ static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 		}
 
 		arvif = ath11k_vif_to_arvif(skb_cb->vif);
-		if (ar->allocated_vdev_map & (1LL << arvif->vdev_id) &&
-		    arvif->is_started) {
+		mutex_lock(&ar->conf_mutex);
+		if (ar->allocated_vdev_map & (1LL << arvif->vdev_id)) {
 			ret = ath11k_mac_mgmt_tx_wmi(ar, arvif, skb);
 			if (ret) {
 				ath11k_warn(ar->ab, "failed to tx mgmt frame, vdev_id %d :%d\n",
@@ -5539,6 +5539,7 @@ static void ath11k_mgmt_over_wmi_tx_work(struct work_struct *work)
 				    arvif->is_started);
 			ath11k_mgmt_over_wmi_tx_drop(ar, skb);
 		}
+		mutex_unlock(&ar->conf_mutex);
 	}
 }
 
-- 
2.35.1



