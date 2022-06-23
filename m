Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707D55584EC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiFWRvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiFWRu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B660A6939;
        Thu, 23 Jun 2022 10:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE3DCB824B6;
        Thu, 23 Jun 2022 17:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D11C341C4;
        Thu, 23 Jun 2022 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004322;
        bh=6fH8AWnE43TUWzbd1LNxTcaH+c3QHupvuuJ7goaZ2nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXhjWIKzpNGWVU5gWnYDQ0aKTZ6tQya8M2n7RdDTbJilIR6rqSswHs+jPR3ca1H09
         wZETItCbLoCjhmsrZoruDY9f33UStxe082B58m6dpVq8flH00aYBtXeLmjsxdWKWmO
         MO7XnaCwKlOFtMPLu0Be/KOYBREu9T9teZYkFdQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 3/9] net: mana: Add handling of CQE_RX_TRUNCATED
Date:   Thu, 23 Jun 2022 18:44:46 +0200
Message-Id: <20220623164322.390907722@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
References: <20220623164322.288837280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit e4b7621982d29f26ff4d39af389e5e675a4ffed4 upstream.

The proper way to drop this kind of CQE is advancing rxq tail
without indicating the packet to the upper network layer.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -980,8 +980,10 @@ static void mana_process_rx_cqe(struct m
 		break;
 
 	case CQE_RX_TRUNCATED:
-		netdev_err(ndev, "Dropped a truncated packet\n");
-		return;
+		++ndev->stats.rx_dropped;
+		rxbuf_oob = &rxq->rx_oobs[rxq->buf_index];
+		netdev_warn_once(ndev, "Dropped a truncated packet\n");
+		goto drop;
 
 	case CQE_RX_COALESCED_4:
 		netdev_err(ndev, "RX coalescing is unsupported\n");
@@ -1043,6 +1045,7 @@ static void mana_process_rx_cqe(struct m
 
 	mana_rx_skb(old_buf, oob, rxq);
 
+drop:
 	mana_move_wq_tail(rxq->gdma_rq, rxbuf_oob->wqe_inf.wqe_size_in_bu);
 
 	mana_post_pkt_rxq(rxq);


