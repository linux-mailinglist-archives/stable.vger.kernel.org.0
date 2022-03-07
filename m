Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAB64CF599
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbiCGJaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbiCGJ23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E234961A22;
        Mon,  7 Mar 2022 01:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E40B810C0;
        Mon,  7 Mar 2022 09:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBA2C340F3;
        Mon,  7 Mar 2022 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645169;
        bh=R0Ss79X9yzSC9iRJKQk2wvDI1Sh7FnLe/NlY07EHVzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3HnMgKALbYTaKj0VSFnzanHAVraIcip0R/7ejRIa3COanANOD81A498lPvogC9Wv
         3fOCDP7odKVVhw0sdAafU6rHIXeu/CMCR48s2fJTy7ioYKjlUsSO2MqJuLzXcucbrB
         G/qaIt4n5Lpqn3E3W+Y7+tqiMWLnkn5Zan1e5p98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/64] mac80211_hwsim: report NOACK frames in tx_status
Date:   Mon,  7 Mar 2022 10:18:34 +0100
Message-Id: <20220307091639.180946220@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

[ Upstream commit 42a79960ffa50bfe9e0bf5d6280be89bf563a5dd ]

Add IEEE80211_TX_STAT_NOACK_TRANSMITTED to tx_status flags to have proper
statistics for non-acked frames.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Link: https://lore.kernel.org/r/20220111221327.1499881-1-benjamin.beichler@uni-rostock.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 07b070b14d75d..cfd97fe92d468 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3316,6 +3316,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
+
+	if (hwsim_flags & HWSIM_TX_CTL_NO_ACK)
+		txi->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
 out:
-- 
2.34.1



