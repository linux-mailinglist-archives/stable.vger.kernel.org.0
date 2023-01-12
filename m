Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4266767F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbjALOc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237897AbjALObo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:31:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7FE52762
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FDB6B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A8C433F0;
        Thu, 12 Jan 2023 14:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533405;
        bh=jhAlfDVH0rOWW0WfeGl9pbd/ls7DFYuP5L50MYIKMCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E870yCz2EuNumkga/TdvMc8ryZ+ayK9rigAKDPZRiNjAUAF/jL7SjrNUChU2uQwwz
         OdLY5KtjqjYt5asPEeoOVPyng58rA/ih5Fg5TDYTPucC2sxtHjU2eOuAOQ4mBoTQzj
         i4e1Ma5kjTM+qDoSSG/s9sekrqXgMAF9ozFcyUM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/783] net: igc: use skb_csum_is_sctp instead of protocol check
Date:   Thu, 12 Jan 2023 14:53:02 +0100
Message-Id: <20230112135545.848916871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 609d29a9d2429a840a2f1f44e77b71d58e3e9a33 ]

Using skb_csum_is_sctp is a easier way to validate it's a SCTP CRC
checksum offload packet, and yet it also makes igc support SCTP
CRC checksum offload for UDP and GRE encapped packets, just as it
does in igb driver.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e7ffe63925fd..f438cdf83e55 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -954,15 +954,6 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 	}
 }
 
-static inline bool igc_ipv6_csum_is_sctp(struct sk_buff *skb)
-{
-	unsigned int offset = 0;
-
-	ipv6_find_hdr(skb, &offset, IPPROTO_SCTP, NULL, NULL);
-
-	return offset == skb_checksum_start_offset(skb);
-}
-
 static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 {
 	struct sk_buff *skb = first->skb;
@@ -985,10 +976,7 @@ static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 		break;
 	case offsetof(struct sctphdr, checksum):
 		/* validate that this is actually an SCTP request */
-		if ((first->protocol == htons(ETH_P_IP) &&
-		     (ip_hdr(skb)->protocol == IPPROTO_SCTP)) ||
-		    (first->protocol == htons(ETH_P_IPV6) &&
-		     igc_ipv6_csum_is_sctp(skb))) {
+		if (skb_csum_is_sctp(skb)) {
 			type_tucmd = IGC_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-- 
2.35.1



