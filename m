Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390E95869AD
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiHAMFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiHAMEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:04:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DE03D5A4;
        Mon,  1 Aug 2022 04:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9727CB81177;
        Mon,  1 Aug 2022 11:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB33C433C1;
        Mon,  1 Aug 2022 11:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354872;
        bh=kqzAiSw/ct00EXWfjflkwgRWQcWUPImEYu8EiAWgWrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJf4oWiWCraq3i2gv3sP6u91nhNnCfTTSySWCtJwMVv2Ty6bYagKzINLYUpkDFGHH
         v7jz1AOUVOJG9qFVhwiIjnEUK5Hnpq6q/dVsUMTSODsWuh8bjN3oGZ8RPrLyqhrzB1
         dlyyi2IZcBhPhnp7k7jjeOxEwS7ml1gaq/qT6ngk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/69] tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
Date:   Mon,  1 Aug 2022 13:47:15 +0200
Message-Id: <20220801114136.538559950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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

[ Upstream commit 79f55473bfc8ac51bd6572929a679eeb4da22251 ]

While reading sysctl_tcp_comp_sack_nr, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 9c21d2fc41c0 ("tcp: add tcp_comp_sack_nr sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7b593865b4ae..a33e6aa42a4c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5491,7 +5491,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	}
 
 	if (!tcp_is_sack(tp) ||
-	    tp->compressed_ack >= sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr)
+	    tp->compressed_ack >= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr))
 		goto send_now;
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
-- 
2.35.1



