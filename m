Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DDB59D462
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbiHWIW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbiHWIVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE76D6F553;
        Tue, 23 Aug 2022 01:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DF5DB81C36;
        Tue, 23 Aug 2022 08:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAEDC43144;
        Tue, 23 Aug 2022 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242355;
        bh=exLWc5wfuhzLstDPxiLLQ/227evYWkphKy8CKnPSkFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TroV75M1an1zq5WHYxrk76CQgec1eeUUAJXmxvV5q7y2cZa6FjGoPmZccNTu+ZphW
         Y7N4ZxupZKFsUSRqSHeBlk+59w3CLnET7HX+F/+MwdwQhaLBxxRLQQMYv1KrlUwUjq
         5kj/AhubztSq9RhbLZ40Al7nPcmR1cKLyWC9jcvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 059/101] tcp: fix over estimation in sk_forced_mem_schedule()
Date:   Tue, 23 Aug 2022 10:03:32 +0200
Message-Id: <20220823080036.832741502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -2986,11 +2986,12 @@ begin_fwd:
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
 


