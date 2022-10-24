Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A560A302
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiJXLuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiJXLtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:49:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299591EEED;
        Mon, 24 Oct 2022 04:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB70B8117A;
        Mon, 24 Oct 2022 11:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E6EC433D6;
        Mon, 24 Oct 2022 11:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611833;
        bh=RwSqqccq5jb87gtkM0ArHecFwhThQMrjqBPPfIKVlKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7IWoNAQdI61cGbmY6MQbQPtX3z65BstWvaU5qM3UG2ZNS0ActKCh/9fo3xXNqOF8
         eFZllitCGzfbnlkV5Ib/h4YElpqFhurgB1Muw8wgVgl43mCPeH6RbRd9+umEDnYeCv
         ib0ITE+HdRQYH7a5g/D98Nv8X/yr0n/DiFj1CtMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 129/159] tcp: annotate data-race around tcp_md5sig_pool_populated
Date:   Mon, 24 Oct 2022 13:31:23 +0200
Message-Id: <20221024112954.216222112@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
index 7a75eb177878..4252aa0b5143 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3131,12 +3131,16 @@ static void __tcp_alloc_md5sig_pool(void)
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
@@ -3144,7 +3148,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -3160,7 +3165,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
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



