Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5355582EA4
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiG0RPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241688AbiG0ROP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8B45B79A;
        Wed, 27 Jul 2022 09:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E803CB821A6;
        Wed, 27 Jul 2022 16:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF1EC433D6;
        Wed, 27 Jul 2022 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940146;
        bh=d8KCOZQRtS3YyGHEzP8Y+vF/hcnKWbNeTEIuHdOAJqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtYDW0uL9E51Lbe6ygW8Jwe9rsSO0Kx+PGGCpseURFPlHVwjR6x5DCwN3kVo8XhtV
         FaM60i6xOXsdfRScQNSgRi0RCoI3uPQnMyMHA7N+N31T4JpZoX0rFJMQUTR/x62rJj
         oOPfbO52jvfJW8f7qu2MVJg5YS+Pf1KaUuQmjiBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/201] tcp: Fix a data-race around sysctl_tcp_early_retrans.
Date:   Wed, 27 Jul 2022 18:10:26 +0200
Message-Id: <20220727161032.815549109@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 52e65865deb6a36718a463030500f16530eaab74 ]

While reading sysctl_tcp_early_retrans, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: eed530b6c676 ("tcp: early retransmit")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a08fcf15372a..3b71d8735995 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2739,7 +2739,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (rcu_access_pointer(tp->fastopen_rsk))
 		return false;
 
-	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
+	early_retrans = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_early_retrans);
 	/* Schedule a loss probe in 2*RTT for SACK capable connections
 	 * not in loss recovery, that are either limited by cwnd or application.
 	 */
-- 
2.35.1



