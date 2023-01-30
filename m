Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CE76810F3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbjA3OIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbjA3OIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107B3802F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FCE661025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48419C433D2;
        Mon, 30 Jan 2023 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087722;
        bh=As6x/Hz70c/nY0B9/ppMqxYXAVWVzRfoSP2gfVGhq9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW039d/FgqwTFKCoNzopzhkvDaevikVZHtXQ8hIgr3D8iESqRrSOfdgiDNnCcsJMG
         Kfed68D6KG4iF/WlD9/ofq3i9LYnP90G8X6liLe1I/DAHx3e6NwXehDGujZytK2d0a
         Ix6XqN+dqUYoXvm1sKLXGlbteR/scvSFhjvxpbZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/313] net: ethernet: adi: adin1110: Fix multicast offloading
Date:   Mon, 30 Jan 2023 14:51:47 +0100
Message-Id: <20230130134349.401668223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit 8a4f6d023221c4b052ddfa1db48b27871bad6e96 ]

Driver marked broadcast/multicast frames as offloaded incorrectly.
Mark them as offloaded only when HW offloading has been enabled.
This should happen only for ADIN2111 when both ports are bridged
by the software.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230120090846.18172-1-alexandru.tachici@analog.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 9d8dfe172994..ecce5f7a549f 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -356,7 +356,7 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 
 	if ((port_priv->flags & IFF_ALLMULTI && rxb->pkt_type == PACKET_MULTICAST) ||
 	    (port_priv->flags & IFF_BROADCAST && rxb->pkt_type == PACKET_BROADCAST))
-		rxb->offload_fwd_mark = 1;
+		rxb->offload_fwd_mark = port_priv->priv->forwarding;
 
 	netif_rx(rxb);
 
-- 
2.39.0



