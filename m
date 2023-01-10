Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392F9664AF9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbjAJSiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239438AbjAJShl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC015B4BA
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:32:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D99FBB81902
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17483C433D2;
        Tue, 10 Jan 2023 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375570;
        bh=lxNdN0VNI+WNzvXborzBWKvRj8CcdpP50zuipCj9ang=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOvfWI7kmR5wCm5WQhxEbEJmyvh4QuxDpzTJLJHd4DZ1b8++9E9LLijxs6PfB2Wb2
         sQcR3LqKjVU7oUOknmnIAdRciZxyDlBDKsMXCw/f5hti3w9Emph1hK5mWWwO/sFS8c
         XzEvF6lLHliM3iWptW/Cc7RnVK6Qjrpsa1KFBStw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Agroskin <shayagr@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/290] net: ena: Dont register memory info on XDP exchange
Date:   Tue, 10 Jan 2023 19:05:23 +0100
Message-Id: <20230110180039.995887937@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 9c9e539956fa67efb8a65e32b72a853740b33445 ]

Since the queues aren't destroyed when we only exchange XDP programs,
there's no need to re-register them again.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f032e58a4c3c..da16f428e7fa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -516,16 +516,18 @@ static void ena_xdp_exchange_program_rx_in_range(struct ena_adapter *adapter,
 						 struct bpf_prog *prog,
 						 int first, int count)
 {
+	struct bpf_prog *old_bpf_prog;
 	struct ena_ring *rx_ring;
 	int i = 0;
 
 	for (i = first; i < count; i++) {
 		rx_ring = &adapter->rx_ring[i];
-		xchg(&rx_ring->xdp_bpf_prog, prog);
-		if (prog) {
+		old_bpf_prog = xchg(&rx_ring->xdp_bpf_prog, prog);
+
+		if (!old_bpf_prog && prog) {
 			ena_xdp_register_rxq_info(rx_ring);
 			rx_ring->rx_headroom = XDP_PACKET_HEADROOM;
-		} else {
+		} else if (old_bpf_prog && !prog) {
 			ena_xdp_unregister_rxq_info(rx_ring);
 			rx_ring->rx_headroom = NET_SKB_PAD;
 		}
-- 
2.35.1



