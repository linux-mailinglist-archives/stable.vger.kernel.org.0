Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8051E4B4B19
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347373AbiBNKcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:32:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347864AbiBNKcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:32:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758656BDD8;
        Mon, 14 Feb 2022 02:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9022260B31;
        Mon, 14 Feb 2022 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D04BC340E9;
        Mon, 14 Feb 2022 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832813;
        bh=vtvCnSQpdw7qOucHM0NWvM5R9bVPjaYmC2aS75+Gk+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmx2GM8v+25s0s2nCtPFXRyoCOvjTEwb9mcLeZYtwtDysw/DuXGOgWFTVtAishP2D
         ypn45Ab2/DrhFAGk/9H6Qnznt2plO9phLB7nPfKINBLCYMA2ElQdDAyGNF6qFW0pX8
         VA5kvfmqIYAV4h69TBKmDFHe9K2T6gwuR0f0QJZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <xliutaox@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 132/203] gve: Recording rx queue before sending to napi
Date:   Mon, 14 Feb 2022 10:26:16 +0100
Message-Id: <20220214092514.721288575@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

[ Upstream commit 084cbb2ec3af2d23be9de65fcc9493e21e265859 ]

This caused a significant performance degredation when using generic XDP
with multiple queues.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Tao Liu <xliutaox@google.com>
Link: https://lore.kernel.org/r/20220207175901.2486596-1-jeroendb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 04a08904305a9..3453e565472c1 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -609,6 +609,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 
 	*packet_size_bytes = skb->len + (skb->protocol ? ETH_HLEN : 0);
 	*work_done = work_cnt;
+	skb_record_rx_queue(skb, rx->q_num);
 	if (skb_is_nonlinear(skb))
 		napi_gro_frags(napi);
 	else
-- 
2.34.1



