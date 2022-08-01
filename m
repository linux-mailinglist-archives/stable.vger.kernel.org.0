Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55D65868E3
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiHALyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiHALxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750432F38C;
        Mon,  1 Aug 2022 04:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCCB5B81163;
        Mon,  1 Aug 2022 11:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEA1C433C1;
        Mon,  1 Aug 2022 11:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354624;
        bh=ANJyZndjBVSoGi/HJZXgkuECWYmgAnEMr6t4G82Hlh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQXsgM9fBTL6PorhZWnGEDIjjy0RfoaR4GeYwrmRPcqVtYjFZvNhNiayh4un+3xOw
         dudBr/alst2Eox7M2SbF1b7RCEZTMUxz4TMpnpNlalvq+V5i7t4mMk0Hg05s0EXMFG
         ZyhrMQtjmQeLklo52EjbCUJIzx28c2cf57D7hwsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/65] tcp: Fix a data-race around sysctl_tcp_min_rtt_wlen.
Date:   Mon,  1 Aug 2022 13:46:44 +0200
Message-Id: <20220801114134.853372464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
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

[ Upstream commit 1330ffacd05fc9ac4159d19286ce119e22450ed2 ]

While reading sysctl_tcp_min_rtt_wlen, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: f672258391b4 ("tcp: track min RTT using windowed min-filter")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c31db58b93a6..79539ef5eb90 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3004,7 +3004,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 static void tcp_update_rtt_min(struct sock *sk, u32 rtt_us, const int flag)
 {
-	u32 wlen = sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen * HZ;
+	u32 wlen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_rtt_wlen) * HZ;
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if ((flag & FLAG_ACK_MAYBE_DELAYED) && rtt_us > tcp_min_rtt(tp)) {
-- 
2.35.1



