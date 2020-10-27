Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DE29B171
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901940AbgJ0O3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759375AbgJ0O3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC2B22202;
        Tue, 27 Oct 2020 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808979;
        bh=ncTgAyadpEpWnpmCyZZ2DOBUM9msIpirBHCUFbUETvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjRxGwG52zL5GA5wxhmIGs2m0o9NA8gq++CpaJsvUTUoPdX+2xrXbYO2cICoawDV9
         vpHisl9XkUhiu8AfQSH+XxhTg1A8TsVfN8xr5YWHGj0aXbU6OalqezIPh1DYaCIB9D
         CkBjRdOc5Rs5yInDE/LYk6GdHTTKeTFR+O9Lqjl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ji Li <jli@akamai.com>,
        Ke Li <keli@akamai.com>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 032/408] net: Properly typecast int values to set sk_max_pacing_rate
Date:   Tue, 27 Oct 2020 14:49:30 +0100
Message-Id: <20201027135456.562135874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ke Li <keli@akamai.com>

[ Upstream commit 700465fd338fe5df08a1b2e27fa16981f562547f ]

In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_rate,
after extended from 'u32' to 'unsigned long', takes unintentionally
hiked value whenever assigned from an 'int' value with MSB=1, due to
binary sign extension in promoting s32 to u64, e.g. 0x80000000 becomes
0xFFFFFFFF80000000.

Thus inflated sk_max_pacing_rate causes subsequent getsockopt to return
~0U unexpectedly. It may also result in increased pacing rate.

Fix by explicitly casting the 'int' value to 'unsigned int' before
assigning it to sk_max_pacing_rate, for zero extension to happen.

Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
Signed-off-by: Ji Li <jli@akamai.com>
Signed-off-by: Ke Li <keli@akamai.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201022064146.79873-1-keli@akamai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    3 ++-
 net/core/sock.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4270,7 +4270,8 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_so
 				cmpxchg(&sk->sk_pacing_status,
 					SK_PACING_NONE,
 					SK_PACING_NEEDED);
-			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : val;
+			sk->sk_max_pacing_rate = (val == ~0U) ?
+						 ~0UL : (unsigned int)val;
 			sk->sk_pacing_rate = min(sk->sk_pacing_rate,
 						 sk->sk_max_pacing_rate);
 			break;
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1106,7 +1106,7 @@ set_rcvbuf:
 
 	case SO_MAX_PACING_RATE:
 		{
-		unsigned long ulval = (val == ~0U) ? ~0UL : val;
+		unsigned long ulval = (val == ~0U) ? ~0UL : (unsigned int)val;
 
 		if (sizeof(ulval) != sizeof(val) &&
 		    optlen >= sizeof(ulval) &&


