Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226E34F2F21
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbiDEJb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245183AbiDEIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F9B2609;
        Tue,  5 Apr 2022 01:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C63D961509;
        Tue,  5 Apr 2022 08:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33D2C385A0;
        Tue,  5 Apr 2022 08:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148709;
        bh=q0syxxaTH7xp2V/r98sFo2P+r4nVpI03Joft2BVr5xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQMNk2gB2cejchGoDc8hBFcDxWG2pCWnF83gbI3CGXTCAzR2hWrqKeeGgtcPqij7j
         n7z/k4IUSUmmFZIhb045NCbMO0/oitMyY9Wimy1tHDQYxw/bwqXtyTKNg//NwmqQnn
         D4mw5bk36PHyXnJ2tpx1N7hTLe6Oa6MONYxuKh/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0453/1017] mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
Date:   Tue,  5 Apr 2022 09:22:46 +0200
Message-Id: <20220405070407.745073528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit abdb8bc94be4cf68aa71c9a8ee0bad9b3e6f52d3 ]

Similar to mt7915_mcu_wtbl_generic_tlv, rely on vif->bss_conf.aid for
aid in sta mode and not on sta->aid.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 8cdf689b383e..abc798536a81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1321,12 +1321,15 @@ mt7915_mcu_sta_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		basic->conn_type = cpu_to_le32(CONNECTION_INFRA_STA);
+		basic->aid = cpu_to_le16(sta->aid);
 		break;
 	case NL80211_IFTYPE_STATION:
 		basic->conn_type = cpu_to_le32(CONNECTION_INFRA_AP);
+		basic->aid = cpu_to_le16(vif->bss_conf.aid);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		basic->conn_type = cpu_to_le32(CONNECTION_IBSS_ADHOC);
+		basic->aid = cpu_to_le16(sta->aid);
 		break;
 	default:
 		WARN_ON(1);
@@ -1334,7 +1337,6 @@ mt7915_mcu_sta_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	}
 
 	memcpy(basic->peer_addr, sta->addr, ETH_ALEN);
-	basic->aid = cpu_to_le16(sta->aid);
 	basic->qos = sta->wme;
 }
 
-- 
2.34.1



