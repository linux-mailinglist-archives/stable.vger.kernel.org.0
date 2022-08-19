Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8959A403
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354163AbiHSQwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354050AbiHSQs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7496FEE30;
        Fri, 19 Aug 2022 09:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45550B82823;
        Fri, 19 Aug 2022 16:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92857C433C1;
        Fri, 19 Aug 2022 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925569;
        bh=lO4agyz0ZSzI8UkHKUsysasIuHutY5jQ8FqjF1ZH5tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKRBjTzDIp3ApdSBrgQ/iCN5ouDqvnlUuMXd6/G2bkOH7URQHme9iPsQBvT1k/Ilr
         /lEfovvfDTJCr2X+sU1izVc01se2nePTBRwlqJP1dBm+rn6dX8isCerTpSN8jsez/n
         7gfg9LQN+CaSpgr9+zaaEV+4rziUgjyYh/Fd4ii0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 532/545] tcp: fix over estimation in sk_forced_mem_schedule()
Date:   Fri, 19 Aug 2022 17:45:02 +0200
Message-Id: <20220819153853.386866633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

commit c4ee118561a0f74442439b7b5b486db1ac1ddfeb upstream.

sk_forced_mem_schedule() has a bug similar to ones fixed
in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
sk_rmem_schedule() errors")

While this bug has little chance to trigger in old kernels,
we need to fix it before the following patch.

Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3372,11 +3372,12 @@ void tcp_xmit_retransmit_queue(struct so
  */
 void sk_forced_mem_schedule(struct sock *sk, int size)
 {
-	int amt;
+	int delta, amt;
 
-	if (size <= sk->sk_forward_alloc)
+	delta = size - sk->sk_forward_alloc;
+	if (delta <= 0)
 		return;
-	amt = sk_mem_pages(size);
+	amt = sk_mem_pages(delta);
 	sk->sk_forward_alloc += amt * SK_MEM_QUANTUM;
 	sk_memory_allocated_add(sk, amt);
 


