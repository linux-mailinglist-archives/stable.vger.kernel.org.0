Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B075E501435
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbiDNNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344104AbiDNNju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEBF1FA7F;
        Thu, 14 Apr 2022 06:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ADE6B82983;
        Thu, 14 Apr 2022 13:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDB5C385A5;
        Thu, 14 Apr 2022 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943442;
        bh=vnEk134Kx4D0oRVO2tM/o6uUt6tN7E97qZ+aeslwYNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg+oWjnoa5l9iKiZ5zIE3zxF/6lfnR0RoNXjk6Z1RJVTGEeiukQiT9pB6qcKxbzO3
         6IX2dYKhtl5wufpQEg5NjdShIjOK4Fbp5d3xEiDzRn7aM9U34Ip/ln/pdcXM1JWYrB
         SdR1tY5rKYY3AQcZFSXv9deyP78bCU8GLUrvbY3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/475] ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern
Date:   Thu, 14 Apr 2022 15:09:02 +0200
Message-Id: <20220414110859.535075482@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit e3fb3d4418fce5484dfe7995fcd94c18b10a431a ]

In function ath10k_wow_convert_8023_to_80211(), it will do memcpy for
the new->pattern, and currently the new->pattern and new->mask is same
with the old, then the memcpy of new->pattern will also overwrite the
old->pattern, because the header format of new->pattern is 802.11,
its length is larger than the old->pattern which is 802.3. Then the
operation of "Copy frame body" will copy a mistake value because the
body memory has been overwrite when memcpy the new->pattern.

Assign another empty value to new_pattern to avoid the overwrite issue.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Fixes: fa3440fa2fa1 ("ath10k: convert wow pattern from 802.3 to 802.11")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211222031347.25463-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wow.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index 8c26adddd034..b4f54ca12756 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -337,14 +337,15 @@ static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
 			if (patterns[i].mask[j / 8] & BIT(j % 8))
 				bitmask[j] = 0xff;
 		old_pattern.mask = bitmask;
-		new_pattern = old_pattern;
 
 		if (ar->wmi.rx_decap_mode == ATH10K_HW_TXRX_NATIVE_WIFI) {
-			if (patterns[i].pkt_offset < ETH_HLEN)
+			if (patterns[i].pkt_offset < ETH_HLEN) {
 				ath10k_wow_convert_8023_to_80211(&new_pattern,
 								 &old_pattern);
-			else
+			} else {
+				new_pattern = old_pattern;
 				new_pattern.pkt_offset += WOW_HDR_LEN - ETH_HLEN;
+			}
 		}
 
 		if (WARN_ON(new_pattern.pattern_len > WOW_MAX_PATTERN_SIZE))
-- 
2.34.1



