Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00325579E30
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242490AbiGSM6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242427AbiGSM6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70734F1B2;
        Tue, 19 Jul 2022 05:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5790B618EE;
        Tue, 19 Jul 2022 12:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363DFC341C6;
        Tue, 19 Jul 2022 12:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233405;
        bh=1O4YvpPOVTcmd9SUcxf3I9CNQViboW+x42n9Xo73vWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xt8TGTOxwmZyBPYH2kcHCcqZe2DyuVcm6Vms8PQDg3yqZIkPb4mHi0pJH4M0aHqoi
         0Q0EpPypKk3tlYcHjWXqs8HrykN9ILDL7kht+TE5gZ7TEJGkosq/T1rOd9r8AApkqP
         ykXI55WFAtw0Ax+VoQLr0vZaYt2qL0eiSinUaiyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 111/231] tcp: Fix a data-race around sysctl_max_tw_buckets.
Date:   Tue, 19 Jul 2022 13:53:16 +0200
Message-Id: <20220719114723.910459435@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6f605b57f3782114e330e108ce1903ede22ec675 ]

While reading sysctl_max_tw_buckets, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_timewait_sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 0ec501845cb3..47ccc343c9fb 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -156,7 +156,8 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 {
 	struct inet_timewait_sock *tw;
 
-	if (refcount_read(&dr->tw_refcount) - 1 >= dr->sysctl_max_tw_buckets)
+	if (refcount_read(&dr->tw_refcount) - 1 >=
+	    READ_ONCE(dr->sysctl_max_tw_buckets))
 		return NULL;
 
 	tw = kmem_cache_alloc(sk->sk_prot_creator->twsk_prot->twsk_slab,
-- 
2.35.1



