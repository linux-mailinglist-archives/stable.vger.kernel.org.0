Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7899D4F3743
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352633AbiDELL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348924AbiDEJss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFDAEE4F1;
        Tue,  5 Apr 2022 02:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6891661577;
        Tue,  5 Apr 2022 09:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B90AC385A2;
        Tue,  5 Apr 2022 09:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151457;
        bh=XSfy//YYcopjlaHQsWH9cy6ABdbOfQiF+txQ3zMQlmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMmxQcEhfjmuGwb1GWrwo18lraIAVbzBZajDB40bP3mwN8jKyCc+2uEYMSDniqPq7
         OmwqZ0dLZEjtSXVq6+cO5/LjMcnm+R0tIvd5udgr4f960b9fVTAcw3ssgJlozJVK3s
         y/mrazUHDc/eY6jToowZUBQ5tDUxDGv2GfQCnRdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/913] mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
Date:   Tue,  5 Apr 2022 09:24:45 +0200
Message-Id: <20220405070352.525143221@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index b157db9f8903..e9d854e3293e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1454,12 +1454,15 @@ mt7915_mcu_sta_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
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
@@ -1467,7 +1470,6 @@ mt7915_mcu_sta_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	}
 
 	memcpy(basic->peer_addr, sta->addr, ETH_ALEN);
-	basic->aid = cpu_to_le16(sta->aid);
 	basic->qos = sta->wme;
 }
 
-- 
2.34.1



