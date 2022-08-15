Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7C593900
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbiHOSm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244012AbiHOSl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724532ED76;
        Mon, 15 Aug 2022 11:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 067E6B81085;
        Mon, 15 Aug 2022 18:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42411C433C1;
        Mon, 15 Aug 2022 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587935;
        bh=LRYanTTuM7Fr/DtH9Gv9pC3t6OmIF336n5aBC7aLuoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI9Llr53gn/QD3wzKQ3OtKzgDvCwVfm+qPn530XZqJPnE7AwchVWA+gpIXq5V76a6
         bHhHBh9vZ0/C+4nLv6okqIPvN8LcZgPYH1M0/SjZt9ZUV6yHZ+Vf+q01obcUznKa5p
         696nMIp2XzAnlLSSygS2epRJkLmxYEsRDd+AU9Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/779] ath11k: Fix incorrect debug_mask mappings
Date:   Mon, 15 Aug 2022 19:58:06 +0200
Message-Id: <20220815180347.642909135@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 659a275e2eb3..694ebba17fad 100644
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



