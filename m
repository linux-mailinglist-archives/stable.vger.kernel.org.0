Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856166949BA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBMPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjBMPBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39911E1DA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C47096112D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AA0C433D2;
        Mon, 13 Feb 2023 15:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300454;
        bh=vFGH+8NCVnnXTeqHbBOjKmZepuPN3zt68N+5jGyeDgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxHolhPRE0P4WiXn29GIaZpUtL5w7/jFCJ+/s++SyDPmNt4LzDaa2UBx/ojW75gVt
         /5pxwQjJsGOvH9m1nHi4Jn/saSkScorimGVEgXKoLYsx24DmdX5vj/1c8Qlo3wcYHs
         WNNpbK8KyMWFduYTu7+VI6pXkMvxnRFx/aLlxRjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/139] sfc: correctly advertise tunneled IPv6 segmentation
Date:   Mon, 13 Feb 2023 15:49:26 +0100
Message-Id: <20230213144746.764210155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 718308076341..29c8d2c99004 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1047,8 +1047,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
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



