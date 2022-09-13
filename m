Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D8F5B747F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiIMPY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiIMPW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:22:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B487C31F;
        Tue, 13 Sep 2022 07:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6294614E3;
        Tue, 13 Sep 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34DDC433D6;
        Tue, 13 Sep 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079414;
        bh=hTIDCkkY+yz035+KYOS7FOKTLAS//Yd9joPVGfX1drQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2IRC1V7f1pivTex3EnKzJRgFe1PXdvdXkS64xWUhJT6C5HRzEzj7evITpYrAld/L
         CyqQjQfamrcQNX1JdcTvU77JonM2zDBRbavv6YATXsKORThONK7nO/Sv/PRFbwP1A0
         wwI/Rq8ryBVDPEmaj7kTlcJLMBMVlBv2qU8VHHGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/79] tcp: annotate data-race around challenge_timestamp
Date:   Tue, 13 Sep 2022 16:06:35 +0200
Message-Id: <20220913140349.707980737@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8c70521238b7863c2af607e20bcba20f974c969b ]

challenge_timestamp can be read an written by concurrent threads.

This was expected, but we need to annotate the race to avoid potential issues.

Following patch moves challenge_timestamp and challenge_count
to per-netns storage to provide better isolation.

Fixes: 354e4aa391ed ("tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e1d065ea5a158..0be9d5d3c032f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3468,11 +3468,11 @@ static void tcp_send_challenge_ack(struct sock *sk, const struct sk_buff *skb)
 
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
-	if (now != challenge_timestamp) {
+	if (now != READ_ONCE(challenge_timestamp)) {
 		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
-		challenge_timestamp = now;
+		WRITE_ONCE(challenge_timestamp, now);
 		WRITE_ONCE(challenge_count, half + prandom_u32_max(ack_limit));
 	}
 	count = READ_ONCE(challenge_count);
-- 
2.35.1



