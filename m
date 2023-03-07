Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BCA6AE8A7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjCGRSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjCGRRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330B5265BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2B4BB81929
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255F3C433D2;
        Tue,  7 Mar 2023 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209213;
        bh=eC3UnA5tud49eIqf8DgXUmqKwUXu3+3o0hX+tEqejPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atbB+peHzTBryyHNPychuh7uGRWfYwQsUvYtTF7uhe9ZF+C+TVqm2cpd4F9aZVeSd
         bN1WmLVW1/nIqVxCWwv/RW1Q2BBK2cfOcRTO2GBOUx3xTHQKDLB0bh1jKUJaDnXFpP
         tyKmjHSjefVorou0C5XAzWuSdzyJ6ZTmCqduvb4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0146/1001] wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()
Date:   Tue,  7 Mar 2023 17:48:38 +0100
Message-Id: <20230307170028.394621189@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 0ffcb2a68b15bd63d5555a923ae7dfe8bfdb14a7 ]

The default case for frame_contorl is invalid. We should always
assign addr3 of this frame properly.

Coverity error message:
if (ieee80211_has_a4(hdr.frame_control))
(19) Event uninit_use_in_call:	Using uninitialized value "hdr".
Field "hdr.addr3" is uninitialized when calling "memcpy".
	memcpy(skb_push(skb, sizeof(hdr)), &hdr, sizeof(hdr));
else
	memcpy(skb_push(skb, sizeof(hdr) - 6), &hdr, sizeof(hdr) - 6);

Fixes: 0880d40871d1 ("mt76: connac: move mt76_connac2_reverse_frag0_hdr_trans in mt76-connac module")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index fd60123fb2840..c8d0c84e688b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -930,7 +930,7 @@ int mt76_connac2_reverse_frag0_hdr_trans(struct ieee80211_vif *vif,
 		ether_addr_copy(hdr.addr4, eth_hdr->h_source);
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	skb_pull(skb, hdr_offset + sizeof(struct ethhdr) - 2);
-- 
2.39.2



