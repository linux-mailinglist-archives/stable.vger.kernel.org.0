Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144662D6504
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390802AbgLJOeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390796AbgLJOeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:34:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 38/39] netfilter: nf_tables: avoid false-postive lockdep splat
Date:   Thu, 10 Dec 2020 15:27:17 +0100
Message-Id: <20201210142604.165606801@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit c0700dfa2cae44c033ed97dade8a2679c7d22a9d upstream.

There are reports wrt lockdep splat in nftables, e.g.:
------------[ cut here ]------------
WARNING: CPU: 2 PID: 31416 at net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x28/0x38 [nf_tables]
...

These are caused by an earlier, unrelated bug such as a n ABBA deadlock
in a different subsystem.
In such an event, lockdep is disabled and lockdep_is_held returns true
unconditionally.  This then causes the WARN() in nf_tables.

Make the WARN conditional on lockdep still active to avoid this.

Fixes: f102d66b335a417 ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Link: https://lore.kernel.org/linux-kselftest/CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -532,7 +532,8 @@ static void nft_request_module(struct ne
 static void lockdep_nfnl_nft_mutex_not_held(void)
 {
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+	if (debug_locks)
+		WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
 #endif
 }
 


