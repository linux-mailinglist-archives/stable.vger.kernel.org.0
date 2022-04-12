Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993D64FD056
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350569AbiDLGqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351305AbiDLGob (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876E93A5C5;
        Mon, 11 Apr 2022 23:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F28E6B81B1F;
        Tue, 12 Apr 2022 06:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE18C385A6;
        Tue, 12 Apr 2022 06:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745478;
        bh=vMkDexjweUmasIEjMNA0iTwXpyQpsDJzypLZcKTOHZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTtIePatb6O/Fih6/jjqaR5SzTxV8ET1WOYc9P7QizsJu96fHgqvqE1ZDDTmSuw7o
         hMubkiwPrQwRkd6QD7c3jRtOzL1WjaA0emfH7V4L9wT7w6gfecAsvoIidQLMG7SOmz
         akveK6/YiC2RNgaGRAV9OLJOwVJke5K1tuVaHYRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/171] bnxt_en: reserve space inside receive page for skb_shared_info
Date:   Tue, 12 Apr 2022 08:30:00 +0200
Message-Id: <20220412062931.038115167@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Andy Gospodarek <gospo@broadcom.com>

[ Upstream commit facc173cf700e55b2ad249ecbd3a7537f7315691 ]

Insufficient space was being reserved in the page used for packet
reception, so the interface MTU could be set too large to still have
room for the contents of the packet when doing XDP redirect.  This
resulted in the following message when redirecting a packet between
3520 and 3822 bytes with an MTU of 3822:

[311815.561880] XDP_WARN: xdp_update_frame_from_buff(line:200): Driver BUG: missing reserved tailroom

Fixes: f18c2b77b2e4 ("bnxt_en: optimized XDP_REDIRECT support")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 92f9f7f5240b..34affd1de91d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -569,7 +569,8 @@ struct nqe_cn {
 #define BNXT_MAX_MTU		9500
 #define BNXT_MAX_PAGE_MODE_MTU	\
 	((unsigned int)PAGE_SIZE - VLAN_ETH_HLEN - NET_IP_ALIGN -	\
-	 XDP_PACKET_HEADROOM)
+	 XDP_PACKET_HEADROOM - \
+	 SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info)))
 
 #define BNXT_MIN_PKT_SIZE	52
 
-- 
2.35.1



