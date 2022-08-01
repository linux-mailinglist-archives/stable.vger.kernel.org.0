Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D815868C4
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiHALxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiHALwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79CA3F325;
        Mon,  1 Aug 2022 04:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C77D61166;
        Mon,  1 Aug 2022 11:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438A7C433D6;
        Mon,  1 Aug 2022 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354599;
        bh=4IsUzcnAsgx5FRNBKlxQbSIpzHqllQuKMQDhAlCFyw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfOi2NP12euyoONB3H/QU7nPD7N5Anqq41gU2X/VrwK+/WXNXa9xIDcJYCMRzGGCS
         0w1wT4fvSNQDadVwTisXmzcrK//yTWHtFhnXQsGaQGLxF96lT/Web1cCZwIG1t++UL
         efk/7qqhuDeIKicswbglX/ABiUAEpje4AbmTgfkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 19/65] tcp: Fix a data-race around sysctl_tcp_limit_output_bytes.
Date:   Mon,  1 Aug 2022 13:46:36 +0200
Message-Id: <20220801114134.508225349@linuxfoundation.org>
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

commit 9fb90193fbd66b4c5409ef729fd081861f8b6351 upstream.

While reading sysctl_tcp_limit_output_bytes, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 46d3ceabd8d9 ("tcp: TCP Small Queues")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2499,7 +2499,7 @@ static bool tcp_small_queue_check(struct
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
-			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
+			      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes));
 	limit <<= factor;
 
 	if (static_branch_unlikely(&tcp_tx_delay_enabled) &&


