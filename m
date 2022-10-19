Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F330D603D22
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiJSI5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiJSI5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4321452085;
        Wed, 19 Oct 2022 01:52:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82E906174E;
        Wed, 19 Oct 2022 08:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9410AC433D7;
        Wed, 19 Oct 2022 08:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169495;
        bh=mFUfEOAY7UgFEz0zOrho4a8Un5hZ2rqTQSz5pjCrbhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAgRG3N0LhpELRlwVxPdsWE9MxHE32t0zQE2/oDmJz82eosuu0wGtaDr5P3xpepSi
         tI8Pt+li50GV4KJu16pacMJi/ABCcK2VGCR/aFcQq+MNBOR+UT9IcnDsUQWxnbBaXp
         Zd91yr6lVWWK0LcV36WlZNGeO/oZcGMBKs5TPqj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 297/862] wifi: ath11k: Include STA_KEEPALIVE_ARP_RESPONSE TLV header by default
Date:   Wed, 19 Oct 2022 10:26:24 +0200
Message-Id: <20221019083303.127004220@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit b7b6f86149a7e06269d61a7a5206360f5b642f80 ]

In current code STA_KEEPALIVE_ARP_RESPONSE TLV header is included only
when ARP method is used, this causes firmware always to crash when wowlan
is enabled because firmware needs it to be present no matter ARP method
is used or not.

Fix this issue by including STA_KEEPALIVE_ARP_RESPONSE TLV header by
default.

Also fix below typo:
  s/WMI_TAG_STA_KEEPALVE_ARP_RESPONSE/WMI_TAG_STA_KEEPALIVE_ARP_RESPONSE/

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: 0f84a156aa3b ("ath11k: Handle keepalive during WoWLAN suspend and resume")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220913044358.2037-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 9 +++++----
 drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 88ee4f9d19da..b658ea60dcf7 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8962,12 +8962,13 @@ int ath11k_wmi_sta_keepalive(struct ath11k *ar,
 	cmd->interval = arg->interval;
 	cmd->method = arg->method;
 
+	arp = (struct wmi_sta_keepalive_arp_resp *)(cmd + 1);
+	arp->tlv_header = FIELD_PREP(WMI_TLV_TAG,
+				     WMI_TAG_STA_KEEPALIVE_ARP_RESPONSE) |
+			 FIELD_PREP(WMI_TLV_LEN, sizeof(*arp) - TLV_HDR_SIZE);
+
 	if (arg->method == WMI_STA_KEEPALIVE_METHOD_UNSOLICITED_ARP_RESPONSE ||
 	    arg->method == WMI_STA_KEEPALIVE_METHOD_GRATUITOUS_ARP_REQUEST) {
-		arp = (struct wmi_sta_keepalive_arp_resp *)(cmd + 1);
-		arp->tlv_header = FIELD_PREP(WMI_TLV_TAG,
-					     WMI_TAG_STA_KEEPALVE_ARP_RESPONSE) |
-				 FIELD_PREP(WMI_TLV_LEN, sizeof(*arp) - TLV_HDR_SIZE);
 		arp->src_ip4_addr = arg->src_ip4_addr;
 		arp->dest_ip4_addr = arg->dest_ip4_addr;
 		ether_addr_copy(arp->dest_mac_addr.addr, arg->dest_mac_addr);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 4da248ffa318..ba5343a3411f 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -1214,7 +1214,7 @@ enum wmi_tlv_tag {
 	WMI_TAG_NS_OFFLOAD_TUPLE,
 	WMI_TAG_FTM_INTG_CMD,
 	WMI_TAG_STA_KEEPALIVE_CMD,
-	WMI_TAG_STA_KEEPALVE_ARP_RESPONSE,
+	WMI_TAG_STA_KEEPALIVE_ARP_RESPONSE,
 	WMI_TAG_P2P_SET_VENDOR_IE_DATA_CMD,
 	WMI_TAG_AP_PS_PEER_CMD,
 	WMI_TAG_PEER_RATE_RETRY_SCHED_CMD,
-- 
2.35.1



