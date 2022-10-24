Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4760A603
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiJXMbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiJXM3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D001987FBD;
        Mon, 24 Oct 2022 05:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C10612D7;
        Mon, 24 Oct 2022 11:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B570C433C1;
        Mon, 24 Oct 2022 11:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612441;
        bh=1uEidU8QdesxzO/5otIAs5DQ7Dws8bVQHAz3M3ORzmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evQIM6SSs1whdlifhKMhQsS+SI4ObXY3BiVGy212LJjS+m3YA0aV2ULMISxy9zcx+
         QwHclamxWF/YuqhlECZM9b6jFjsIpqYEn7jRjYz7P8IAH+bu3VJLcjnZ5T5mdpwHgJ
         r7ak5SYKc13j1dI6yIf4ipJryx/zsg3/wgp2qn7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 170/210] tcp: annotate data-race around tcp_md5sig_pool_populated
Date:   Mon, 24 Oct 2022 13:31:27 +0200
Message-Id: <20221024113002.473610446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit aacd467c0a576e5e44d2de4205855dc0fe43f6fb ]

tcp_md5sig_pool_populated can be read while another thread
changes its value.

The race has no consequence because allocations
are protected with tcp_md5sig_mutex.

This patch adds READ_ONCE() and WRITE_ONCE() to document
the race and silence KCSAN.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 783d0cd4fcbd..3a5f5bcedb3b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3318,12 +3318,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool_populated = true;
+	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
+	 * and tcp_get_md5sig_pool().
+	*/
+	WRITE_ONCE(tcp_md5sig_pool_populated, true);
 }
 
 bool tcp_alloc_md5sig_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
 		mutex_lock(&tcp_md5sig_mutex);
 
 		if (!tcp_md5sig_pool_populated)
@@ -3331,7 +3335,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -3347,7 +3352,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (READ_ONCE(tcp_md5sig_pool_populated)) {
 		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
-- 
2.35.1



