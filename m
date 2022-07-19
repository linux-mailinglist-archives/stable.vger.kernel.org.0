Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2332F579A4B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbiGSMM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238686AbiGSMMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92C652DD6;
        Tue, 19 Jul 2022 05:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C11DB81B36;
        Tue, 19 Jul 2022 12:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2E8C341C6;
        Tue, 19 Jul 2022 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232221;
        bh=yJT4AGrYVkl2W4HhG4rIo5aF+ladrJDpp65393K88Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXnxGObvIH1kaeeKqfzPBzrPz0UkPfiG5jnLmsaRL76X0umxp4UdZfGMonqSuJc8V
         zgAKY5dd1Kx91h9t8AoSzIJuM7+yfWffL8+B2K7MPaBzE3keWQNq4bI3qwVYCczrGA
         4YEXJ+44R22uIFiFWKn3foRvvQpOYgg2a4H6bqEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/71] net: Fix data-races around sysctl_mem.
Date:   Tue, 19 Jul 2022 13:53:50 +0200
Message-Id: <20220719114554.924609762@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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

[ Upstream commit 310731e2f1611d1d13aae237abcf8e66d33345d5 ]

While reading .sysctl_mem, it can be changed concurrently.
So, we need to add READ_ONCE() to avoid data-races.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7f213cfcb3cc..9d687070d272 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1400,7 +1400,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
-- 
2.35.1



