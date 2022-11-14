Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69B627E99
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiKNMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237320AbiKNMt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3519E6144
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:49:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59706CE1005
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CD8C433C1;
        Mon, 14 Nov 2022 12:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430163;
        bh=kX220HN9+Y5IbOgSEVx/YuwIZ6ClEswRR4kjbwsbLxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8Hvjihwn7+DY2hFIBpWTINi5nHYA1pIue2h3h/3IJ5lsoZ5I6t/ZjCvC10uG85pk
         hnA+hf8DHOEy8XLwZHGg2Denkz7FVotRrU66Hz+LarS17YGp9V1qm0fE6Q+c9SQ/K3
         8x5R1dbXWz4ui+FKqHv/y7x4pqLmQ9JwlVIJUYyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/95] macsec: fix detection of RXSCs when toggling offloading
Date:   Mon, 14 Nov 2022 13:45:09 +0100
Message-Id: <20221114124443.150207572@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 80df4706357a5a06bbbc70273bf2611df1ceee04 ]

macsec_is_configured incorrectly uses secy->n_rx_sc to check if some
RXSCs exist. secy->n_rx_sc only counts the number of active RXSCs, but
there can also be inactive SCs as well, which may be stored in the
driver (in case we're disabling offloading), or would have to be
pushed to the device (in case we're trying to enable offloading).

As long as RXSCs active on creation and never turned off, the issue is
not visible.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index a816fbbe23a7..69108c1db130 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2562,7 +2562,7 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	int i;
 
-	if (secy->n_rx_sc > 0)
+	if (secy->rx_sc)
 		return true;
 
 	for (i = 0; i < MACSEC_NUM_AN; i++)
-- 
2.35.1



