Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D866AE937
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjCGRWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjCGRVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:21:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4F95BF7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3122B819AD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E251C433EF;
        Tue,  7 Mar 2023 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209411;
        bh=O+yygR2JX2Xz6oXdCSgYNx81NXO5p7ba0VVcb20jmtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GEO3Kx4tTVcTAabcQJJHAIltOS+kpco0D330y9arngMXfLqvFFtQuL0+LIztku0R
         Pta9aPC80CuoX6mu7MnjSnXvA00V7iB410HyEv7nuHOz0RiVvH5OTFFwlxNcdV1NpZ
         ikTbQyHT6VZ3n0N/eH9BES51R5dqmxG5k7/YNXxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0210/1001] wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
Date:   Tue,  7 Mar 2023 17:49:42 +0100
Message-Id: <20230307170031.009281083@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ed3f83b3459a67a3ab9d806490ac304b567b1c2d ]

crypto_alloc_shash() allocates resources, which should be released by
crypto_free_shash(). When ath11k_peer_find() fails, there has memory
leak. Add missing crypto_free_shash() to fix this.

Fixes: 243874c64c81 ("ath11k: handle RX fragments")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230102081142.3937570-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c5a4c34d77499..0c53d88293eb7 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3126,6 +3126,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
-- 
2.39.2



