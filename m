Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CE579BF4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiGSMfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237680AbiGSMdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:33:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD774DCB;
        Tue, 19 Jul 2022 05:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E0B617D7;
        Tue, 19 Jul 2022 12:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE751C341C6;
        Tue, 19 Jul 2022 12:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232768;
        bh=iGY6+4NQhgxeOQ6cZCMCN2ShvVFXM5f2V4BRGzzkiAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMTJdSF14IAZmf75tkqFsK2EnnaNTbo/geDJ7ehBWc4/gRVB6s//YwVnGtB4lPSH+
         y4iTsDZL5OIX/UxHDNSVmxEjLYeK4WYtkQxIJBRPSNuXCOtoOE6TBsDTGjP4QZXmVK
         7XR6cfWIsCQFreHgVm9s/9Jd+8eKj59AjYhdSIQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/167] net: Fix data-races around sysctl_mem.
Date:   Tue, 19 Jul 2022 13:53:11 +0200
Message-Id: <20220719114702.270186209@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 7d49196a3880..96f51d4b1649 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1484,7 +1484,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
-- 
2.35.1



