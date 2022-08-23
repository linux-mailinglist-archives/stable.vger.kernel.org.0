Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE67D59DFFA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356003AbiHWKuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355912AbiHWKsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:48:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25F6275C2;
        Tue, 23 Aug 2022 02:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DDDC60DB4;
        Tue, 23 Aug 2022 09:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8758FC433C1;
        Tue, 23 Aug 2022 09:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245926;
        bh=1GQ/pb1NhWVt5bXl2j6hJBRaPk2HcFNi7s+o3/H3dws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6KIzF24LxSudk+we6Y8FQc4WprgEf+WWKLPra7SZtHgmFXaDMKkU/g5yrKGjyBcu
         8SWg0v+vWghUR2tL9olXTZC3gX1X9zLQxt4LM9asB0xe0AwtI1XPnureTcU1Ys6OS/
         s8rHnFjrtZNqThcvSiteIhu9WW5GzZ/blJvTcmas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 206/287] tcp: fix over estimation in sk_forced_mem_schedule()
Date:   Tue, 23 Aug 2022 10:26:15 +0200
Message-Id: <20220823080107.839297135@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -3079,11 +3079,12 @@ void tcp_xmit_retransmit_queue(struct so
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
 


