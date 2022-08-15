Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6064593F14
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbiHOUyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346569AbiHOUw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0402F4B0E8;
        Mon, 15 Aug 2022 12:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40C866009B;
        Mon, 15 Aug 2022 19:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A91EC433D6;
        Mon, 15 Aug 2022 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590626;
        bh=I+I2wzV0Z+MxOytYnSFYZBmG2OVavB/tYy6DM0PO2BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDkPbZgyaTElTHmR4cDusjzci2npgby3UmINYeZ04GKYYk/dMMw7DY1xoFzOeYuKh
         3QY+JkdbmmHa06xKevHGeWG7NlCoq8Elfortc47a76cf6gAbk49fzpNsIS2wgEGiV7
         +WCqhpIWchVpHIERYsoqMF+Ic5aJH9Z3CM8RAUc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0319/1095] ath11k: Avoid REO CMD failed prints during firmware recovery
Date:   Mon, 15 Aug 2022 19:55:18 +0200
Message-Id: <20220815180442.983210975@linuxfoundation.org>
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

[ Upstream commit 0ab52b2bd7be8fd49c8ade7703c1faa15359c6c5 ]

Currently when firmware recovery is in progress, we do not queue REO
commands to the firmware, instead -ESHUTDOWN will be returned to the
caller leading to a failure print on the console. The REO command in
the problem scenario is sent for all tids of a peer in which case we
will have 16 failure prints on the console for a single peer. For an
AP usecase, this count would be even higher in a worst case scenario.
Since these commands are bound to fail during firmware recovery, it
is better to avoid printing these failures and thereby avoid message
flooding on the console.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: 8ee8d38ca472 ("ath11k: Fix crash during firmware recovery on reo cmd ring access")
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220602122929.18896-1-quic_mpubbise@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 049774cc158c..b3e133add1ce 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -835,8 +835,9 @@ void ath11k_peer_rx_tid_delete(struct ath11k *ar,
 					HAL_REO_CMD_UPDATE_RX_QUEUE, &cmd,
 					ath11k_dp_rx_tid_del_func);
 	if (ret) {
-		ath11k_err(ar->ab, "failed to send HAL_REO_CMD_UPDATE_RX_QUEUE cmd, tid %d (%d)\n",
-			   tid, ret);
+		if (ret != -ESHUTDOWN)
+			ath11k_err(ar->ab, "failed to send HAL_REO_CMD_UPDATE_RX_QUEUE cmd, tid %d (%d)\n",
+				   tid, ret);
 		dma_unmap_single(ar->ab->dev, rx_tid->paddr, rx_tid->size,
 				 DMA_BIDIRECTIONAL);
 		kfree(rx_tid->vaddr);
-- 
2.35.1



