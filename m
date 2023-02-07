Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1453168D8AB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjBGNLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjBGNLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:11:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368A3A599
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:10:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B779B81977
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E99FC433D2;
        Tue,  7 Feb 2023 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775396;
        bh=k5IRJoPCdDvC9nVT8BVYa6KupsP9zhjCginJqZKWups=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bH6lceAICUmI5rhOeRjLspcStLcKrcNWK3Adna87Qh6qXXzUBCNFcztxrKwgGNjoc
         hEmgdDiqkRfUFUIFBDjvuIdJJrZ6JWDX6YsvfTINviIK4ToM7JnR61HVmmk1Tdi/Jf
         JoH/50ZD1vJGytK/bzGcr36CVZsmK/SYxERGvuO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/120] sfc: correctly advertise tunneled IPv6 segmentation
Date:   Tue,  7 Feb 2023 13:56:38 +0100
Message-Id: <20230207125619.944883455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit ffffd2454a7a1bc9f7242b12c4cc0b05c12692b4 ]

Recent sfc NICs are TSO capable for some tunnel protocols. However, it
was not working properly because the feature was not advertised in
hw_enc_features, but in hw_features only.

Setting up a GENEVE tunnel and using iperf3 to send IPv4 and IPv6 traffic
to the tunnel show, with tcpdump, that the IPv4 packets still had ~64k
size but the IPv6 ones had only ~1500 bytes (they had been segmented by
software, not offloaded). With this patch segmentation is offloaded as
expected and the traffic is correctly received at the other end.

Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20230125143513.25841-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 43ef4f529028..b6243f03e953 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1005,8 +1005,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
 		net_dev->features |= NETIF_F_TSO6;
+		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
+			net_dev->hw_enc_features |= NETIF_F_TSO6;
+	}
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
-- 
2.39.0



