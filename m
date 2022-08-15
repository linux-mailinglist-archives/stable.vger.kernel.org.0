Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B12059472B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiHOXWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243565AbiHOXTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:19:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F4014A1F0;
        Mon, 15 Aug 2022 13:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE3EB81135;
        Mon, 15 Aug 2022 20:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363D7C433D6;
        Mon, 15 Aug 2022 20:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593843;
        bh=SRi8kUHq7tGKlhz6xYUk1plavmbnQCBV5VrKeiUxa6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5RL2gfCQFM9tfDv+8mVfanov3AlS+RhVgAMWR9WQCXbOTE3SGh+RFvDQUZGDwNnG
         zBJfKJXkDFCNbDODcjC0owNhDF3Zqb3F5Ii8MFtaBXeKM53PXUaepDUa/UAD516pof
         XP/zk5l2SmKN2gJ30WTcY09gznA0vo4XIsmnx/G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0334/1157] ath11k: Fix incorrect debug_mask mappings
Date:   Mon, 15 Aug 2022 19:54:50 +0200
Message-Id: <20220815180453.023958182@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



