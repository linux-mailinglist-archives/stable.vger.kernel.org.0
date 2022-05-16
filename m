Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1475E528E69
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346019AbiEPTnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbiEPTms (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D163F322;
        Mon, 16 May 2022 12:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FD161548;
        Mon, 16 May 2022 19:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CF5C385AA;
        Mon, 16 May 2022 19:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730070;
        bh=Kt5dt3FlKV7eGa6zGiDS99m4kzuj0Lcok+UidDRxhSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYlZp30pplIMgRb7HrACecRuAGPNxdUK0mRJdDlWWgDpWDLDbhFaT4eeZJ5adcbqD
         G6mz4TmwJRFef8QyCYSRIdYN1k7KWdwOFKotT/NqsXrM02teBY3Wub9z6/UufRSe+8
         h9IHhqlXQ3NO98LORAaxV0wpwp11V8Fj86x4pIsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/32] net: Fix features skip in for_each_netdev_feature()
Date:   Mon, 16 May 2022 21:36:17 +0200
Message-Id: <20220516193614.877806329@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
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
index 2a8105d204a9..78411dc4a040 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -156,7 +156,7 @@ enum {
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -175,7 +175,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-- 
2.35.1



