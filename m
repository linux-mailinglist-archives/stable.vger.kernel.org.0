Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F936812DB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbjA3OZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbjA3OZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:25:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B0741B54
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E266CE1409
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFA0C433D2;
        Mon, 30 Jan 2023 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088647;
        bh=TL0psT4H0udZfqqE8PT0TB58jYH10Y7qd/xNfl9kObM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1JLouP8EUBYt2zWA28xTU/zOONrfenYw+2c0DEeWa5HHA7frScCW3JXEmQKWYCR8
         aw1rMWoz5TUZQtbTTBDmfr7AzDZybGwwQVz/I3HBUJ0hnCw4rJ/fFoaSysAETrHdqh
         CTyi9CEAQjJNxyEOuSMuriNxPe5RG4uo67U5fno8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuchung Cheng <ycheng@google.com>,
        David Morley <morleyd@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/143] tcp: fix rate_app_limited to default to 1
Date:   Mon, 30 Jan 2023 14:51:56 +0100
Message-Id: <20230130134309.305458496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Morley <morleyd@google.com>

[ Upstream commit 300b655db1b5152d6101bcb6801d50899b20c2d6 ]

The initial default value of 0 for tp->rate_app_limited was incorrect,
since a flow is indeed application-limited until it first sends
data. Fixing the default to be 1 is generally correct but also
specifically will help user-space applications avoid using the initial
tcpi_delivery_rate value of 0 that persists until the connection has
some non-zero bandwidth sample.

Fixes: eb8329e0a04d ("tcp: export data delivery rate")
Suggested-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David Morley <morleyd@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Tested-by: David Morley <morleyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cc588bc2b11d..6a0560a735ce 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -432,6 +432,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -2837,6 +2838,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->last_oow_ack_time = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
-- 
2.39.0



