Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA49A33E41F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCQA6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhCQA5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFEF64FDC;
        Wed, 17 Mar 2021 00:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942658;
        bh=gCSM7zXPV0rFpWt6rmRxAH+zhgyqSS6xO4K+3HZN9OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUcGTNavh9sOVTb5LK4XqlycSoXekmhfkDLyO+F1zTIKjKR9lWK34jE/6nTNs8myi
         FxovtXNG4uji1xDNFUUapbqSngs+GQB86NEZNsXNfpJclfJ9nJUhXFMifBaDOx1/z2
         SHK1oww+XELs0BxZRetLuosggTUstJ9sGIpFp03+1d8P9B9ACSeN66ZYODA4e6tH/R
         VUGPULzyNmqOS/pbnWccSgAWbrLrbP/di0cy0TgUtE9xop6jo3l6D/1/KCAkto41ou
         AiN91gZ+c0uk8ohjKlbYvi0d6Y8ClfRreGptwpAy4jfhYK8oCP1B33RJ7MnOPXH/TO
         ac8XfirCCio9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Erhard F." <erhard_f@mailbox.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 36/54] u64_stats,lockdep: Fix u64_stats_init() vs lockdep
Date:   Tue, 16 Mar 2021 20:56:35 -0400
Message-Id: <20210317005654.724862-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d5b0e0677bfd5efd17c5bbb00156931f0d41cb85 ]

Jakub reported that:

    static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
    {
	    ...
	    u64_stats_init(&tp->rx_stats.syncp);
	    u64_stats_init(&tp->tx_stats.syncp);
	    ...
    }

results in lockdep getting confused between the RX and TX stats lock.
This is because u64_stats_init() is an inline calling seqcount_init(),
which is a macro using a static variable to generate a lockdep class.

By wrapping that in an inline, we negate the effect of the macro and
fold the static key variable, hence the confusion.

Fix by also making u64_stats_init() a macro for the case where it
matters, leaving the other case an inline for argument validation
etc.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Debugged-by: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Erhard F." <erhard_f@mailbox.org>
Link: https://lkml.kernel.org/r/YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/u64_stats_sync.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index c6abb79501b3..e81856c0ba13 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -115,12 +115,13 @@ static inline void u64_stats_inc(u64_stats_t *p)
 }
 #endif
 
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
+#else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	seqcount_init(&syncp->seq);
-#endif
 }
+#endif
 
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-- 
2.30.1

