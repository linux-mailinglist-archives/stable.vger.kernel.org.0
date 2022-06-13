Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335DB5486BA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiFMKTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243045AbiFMKTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7497D132;
        Mon, 13 Jun 2022 03:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75FD36066C;
        Mon, 13 Jun 2022 10:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A1C34114;
        Mon, 13 Jun 2022 10:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115401;
        bh=b9fvL+Aln/GyyXZsWK12ZQBLHcA2LKsCkHVZHZoRrhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KG/S13ePBoDh3AwFwIIL4j1ov+aDEALnaCS5ube2sNJ1r1fJXPM7i9cT1TVRaRRb
         Yg8Wqvd9cD+d005fiP9t1dKLdxFo3QmuZon1Ttn5W1K/U5pdDlaNa+VPF9Ip+Jcopw
         nmtxpN+PCn/HhN5uJGK9MJJSLd6c12RwAwdGfOMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/167] sctp: read sk->sk_bound_dev_if once in sctp_rcv()
Date:   Mon, 13 Jun 2022 12:08:53 +0200
Message-Id: <20220613094854.726968989@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a20ea298071f46effa3aaf965bf9bb34c901db3f ]

sctp_rcv() reads sk->sk_bound_dev_if twice while the socket
is not locked. Another cpu could change this field under us.

Fixes: 0fd9a65a76e8 ("[SCTP] Support SO_BINDTODEVICE socket option on incoming packets.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9c1670b4a687..ed3a8a66a00b 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -103,6 +103,7 @@ int sctp_rcv(struct sk_buff *skb)
 	struct sctp_chunk *chunk;
 	union sctp_addr src;
 	union sctp_addr dest;
+	int bound_dev_if;
 	int family;
 	struct sctp_af *af;
 	struct net *net = dev_net(skb->dev);
@@ -180,7 +181,8 @@ int sctp_rcv(struct sk_buff *skb)
 	 * If a frame arrives on an interface and the receiving socket is
 	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
 	 */
-	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb))) {
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if && (bound_dev_if != af->skb_iif(skb))) {
 		if (transport) {
 			sctp_transport_put(transport);
 			asoc = NULL;
-- 
2.35.1



