Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3911D4CF78E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbiCGJqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbiCGJmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B878422A;
        Mon,  7 Mar 2022 01:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 306ADCE0EAA;
        Mon,  7 Mar 2022 09:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1194C340E9;
        Mon,  7 Mar 2022 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646065;
        bh=w3xW6sXuqTAEkeMEks1u2RQfpbj9vS7RE95tWEHFmkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A822l9Ea7/jXUa12UqALbJC5bfmtT4HvWQebdARmsHdi9mgRkEt4ui1ythMajKuFH
         xDNglMeWvveSDtVm55M6dq4EPeSEXKjZPjMuL/mqtb7rM2ELQhJ+ennoCqwdfiIiOx
         xz4u/DlDufOqz3dTkFvomr3XUhoowrBbraZWtDTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <xliutaox@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/262] gve: Recording rx queue before sending to napi
Date:   Mon,  7 Mar 2022 10:17:45 +0100
Message-Id: <20220307091705.877888655@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 629d8ed08fc61..97431969a488f 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -450,6 +450,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 		skb_set_hash(skb, be32_to_cpu(rx_desc->rss_hash),
 			     gve_rss_type(rx_desc->flags_seq));
 
+	skb_record_rx_queue(skb, rx->q_num);
 	if (skb_is_nonlinear(skb))
 		napi_gro_frags(napi);
 	else
-- 
2.34.1



