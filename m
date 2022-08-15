Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D845941C9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346345AbiHOUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347339AbiHOUvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:51:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FFC65B5;
        Mon, 15 Aug 2022 12:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C6A060EEE;
        Mon, 15 Aug 2022 19:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B28C433D6;
        Mon, 15 Aug 2022 19:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590623;
        bh=SRi8kUHq7tGKlhz6xYUk1plavmbnQCBV5VrKeiUxa6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcXZZRIY3PK5/4zZUZLKdWa1U/ZLlKN8i2+ZjKW5wrcLwLJjZFVRGPzgKzYjGwYDa
         kdZMA3i3mnMHRwSbO/ZSS+Kd8vKP1oUQz38WOBtFE5M+9bzRrdoAV3JvC1aXJGF0L4
         sD7F0X6//uzVADppk5jT89XDtYyR1e0n/yEKwTbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0318/1095] ath11k: Fix incorrect debug_mask mappings
Date:   Mon, 15 Aug 2022 19:55:17 +0200
Message-Id: <20220815180442.941259834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

[ Upstream commit 9331f7d3c54a263bede5055e106e40b28d0bd937 ]

Currently a couple of debug_mask entries are mapped to the same value,
this could enable unintended driver logging. If enabling DP_TX logs was
the intention, then this could also enable PCI logs flooding the dmesg
buffer or vice versa. Fix this by correctly assigning the debug masks.

Found during code review.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: aa2092a9bab3f ("ath11k: add raw mode and software crypto support")
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220602115621.15339-1-quic_mpubbise@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debug.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index fbbd5fe02aa8..91545640c47b 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -23,8 +23,8 @@ enum ath11k_debug_mask {
 	ATH11K_DBG_TESTMODE	= 0x00000400,
 	ATH11k_DBG_HAL		= 0x00000800,
 	ATH11K_DBG_PCI		= 0x00001000,
-	ATH11K_DBG_DP_TX	= 0x00001000,
-	ATH11K_DBG_DP_RX	= 0x00002000,
+	ATH11K_DBG_DP_TX	= 0x00002000,
+	ATH11K_DBG_DP_RX	= 0x00004000,
 	ATH11K_DBG_ANY		= 0xffffffff,
 };
 
-- 
2.35.1



