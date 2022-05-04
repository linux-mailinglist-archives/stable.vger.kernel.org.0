Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ABD51A6F2
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354619AbiEDRBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355519AbiEDRAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F1F4B846;
        Wed,  4 May 2022 09:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C2B617BD;
        Wed,  4 May 2022 16:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A90FC385B3;
        Wed,  4 May 2022 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683106;
        bh=ySZ75yxQ9rSlMS/LBm0D7/joJG1yatqRZc8qRvexBFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TV0F6pQwOl/H5KJzRyE8UCAmkuzfwh0jG9OtU2OkEdXfPSu1dh5ZH4JhRbWEgUzwt
         Kn1phYokUVstDcgMRgKl71TAUWSuwvWZcc/vqcoorOua3jkTjM/Cm6Ew2+RewollFn
         lG4vLIoQuN2V1CT8Ty2XQL1OrFEzGbNzpyi8hnWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/129] tcp: fix F-RTO may not work correctly when receiving DSACK
Date:   Wed,  4 May 2022 18:44:50 +0200
Message-Id: <20220504153028.695363982@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit d9157f6806d1499e173770df1f1b234763de5c79 ]

Currently DSACK is regarded as a dupack, which may cause
F-RTO to incorrectly enter "loss was real" when receiving
DSACK.

Packetdrill to demonstrate:

// Enable F-RTO and TLP
    0 `sysctl -q net.ipv4.tcp_frto=2`
    0 `sysctl -q net.ipv4.tcp_early_retrans=3`
    0 `sysctl -q net.ipv4.tcp_congestion_control=cubic`

// Establish a connection
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

// RTT 10ms, RTO 210ms
  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 2 data segments
   +0 write(4, ..., 2000) = 2000
   +0 > P. 1:2001(2000) ack 1

// TLP
+.022 > P. 1001:2001(1000) ack 1

// Continue to send 8 data segments
   +0 write(4, ..., 10000) = 10000
   +0 > P. 2001:10001(8000) ack 1

// RTO
+.188 > . 1:1001(1000) ack 1

// The original data is acked and new data is sent(F-RTO step 2.b)
   +0 < . 1:1(0) ack 2001 win 257
   +0 > P. 10001:12001(2000) ack 1

// D-SACK caused by TLP is regarded as a dupack, this results in
// the incorrect judgment of "loss was real"(F-RTO step 3.a)
+.022 < . 1:1(0) ack 2001 win 257 <sack 1001:2001,nop,nop>

// Never-retransmitted data(3001:4001) are acked and
// expect to switch to open state(F-RTO step 3.b)
   +0 < . 1:1(0) ack 4001 win 257
+0 %{ assert tcpi_ca_state == 0, tcpi_ca_state }%

Fixes: e33099f96d99 ("tcp: implement RFC5682 F-RTO")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1650967419-2150-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c25a95c74128..2e267b2e33e5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3814,7 +3814,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_process_tlp_ack(sk, ack, flag);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
-		if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
+		if (!(flag & (FLAG_SND_UNA_ADVANCED |
+			      FLAG_NOT_DUP | FLAG_DSACKING_ACK))) {
 			num_dupack = 1;
 			/* Consider if pure acks were aggregated in tcp_add_backlog() */
 			if (!(flag & FLAG_DATA))
-- 
2.35.1



