Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A130B59A0B0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351070AbiHSQD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351704AbiHSQCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F292CED035;
        Fri, 19 Aug 2022 08:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63466615E9;
        Fri, 19 Aug 2022 15:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7007DC433C1;
        Fri, 19 Aug 2022 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924453;
        bh=PU3gDOfrBxWYveT2aEubf0AB0X2JOTlTEsYa3cruYcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afy+ff4xEWHNNFdHwRSholKzNmJvWuE/q/GQsVcWXgpmeajh/mo3B9GCFdL5+52J1
         Sy0IOXmlYitukiWZ+Pse9Sx8Enk+E/ikqZ7juYujhUedwixQx96LZ7EEcGs+y40sDH
         /VVhkta1fqzYAe9EA78cgYkR5paGmV8hkuBC+eQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/545] net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
Date:   Fri, 19 Aug 2022 17:39:05 +0200
Message-Id: <20220819153837.178590948@linuxfoundation.org>
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

[ Upstream commit 7c80b038d23e1f4c7fcc311f43f83b8c60e7fb80 ]

If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
we want to allocate 1 byte more (rounded up to one page),
instead of 150001 :/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 83854cec4a47..c72b0fc4c752 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1468,19 +1468,23 @@ static inline bool sk_has_account(struct sock *sk)
 
 static inline bool sk_wmem_schedule(struct sock *sk, int size)
 {
+	int delta;
+
 	if (!sk_has_account(sk))
 		return true;
-	return size <= sk->sk_forward_alloc ||
-		__sk_mem_schedule(sk, size, SK_MEM_SEND);
+	delta = size - sk->sk_forward_alloc;
+	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_SEND);
 }
 
 static inline bool
 sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 {
+	int delta;
+
 	if (!sk_has_account(sk))
 		return true;
-	return size <= sk->sk_forward_alloc ||
-		__sk_mem_schedule(sk, size, SK_MEM_RECV) ||
+	delta = size - sk->sk_forward_alloc;
+	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_RECV) ||
 		skb_pfmemalloc(skb);
 }
 
-- 
2.35.1



