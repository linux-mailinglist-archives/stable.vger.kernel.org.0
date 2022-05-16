Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16B2528E60
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345969AbiEPTnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245097AbiEPTk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:40:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1633F31D;
        Mon, 16 May 2022 12:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4521DB81609;
        Mon, 16 May 2022 19:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ED9C34115;
        Mon, 16 May 2022 19:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652729981;
        bh=xF16YJGVi16zTBgv/Q9xC7aci1LoctRep2Rbtib1gJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/HXcVgV5zoaMMI3pBO0i4LVFfgFz3xlq765BMUg23VyHdLQ4Tkb0u7NRvNYipmKz
         w28TlHf/TFdI7CHzIh5RWaCwZYzDrl2hgtBV6obMt9tNmaXWwJmYnOOL0zlZSUHx6h
         dCBxXAkNV2DMPy4NLiPPBvum8h5Lj7CPccXDFlIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/25] net: Fix features skip in for_each_netdev_feature()
Date:   Mon, 16 May 2022 21:36:16 +0200
Message-Id: <20220516193614.757864411@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.678319286@linuxfoundation.org>
References: <20220516193614.678319286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 85db6352fc8a158a893151baa1716463d34a20d0 ]

The find_next_netdev_feature() macro gets the "remaining length",
not bit index.
Passing "bit - 1" for the following iteration is wrong as it skips
the adjacent bit. Pass "bit" instead.

Fixes: 3b89ea9c5902 ("net: Fix for_each_netdev_feature on Big endian")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://lore.kernel.org/r/20220504080914.1918-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdev_features.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index de123f436f1a..3a308bf98fc3 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -145,7 +145,7 @@ enum {
 #define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
 #define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -164,7 +164,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-- 
2.35.1



