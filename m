Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED6681184
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbjA3OOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbjA3OOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:14:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361016AC2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D110B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BEFC433D2;
        Mon, 30 Jan 2023 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088042;
        bh=8+e6o1H71dQPb1QBul389DIoNts6TiciHatOPVQbkx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3GicxtdC2HyRF7oawL8vAGyOd1x+AJLw0iGQdIl6JPbU0ILRmFLW12X8ru39/n08
         qg1N2Jo0zxXoG3kbiW+NEJNUSmpEHwXol6eaoiXWPQRolaB2bUMTje939UIqNQtCMC
         iyO/ilY7JtsY7cZC/y1LRH3l1Raz8YzoSVwg9DR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuchung Cheng <ycheng@google.com>,
        David Morley <morleyd@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/204] tcp: fix rate_app_limited to default to 1
Date:   Mon, 30 Jan 2023 14:51:00 +0100
Message-Id: <20230130134320.538276295@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index fe1972aad279..51f34560a9d6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -439,6 +439,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -3066,6 +3067,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->last_oow_ack_time = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
-- 
2.39.0



