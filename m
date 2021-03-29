Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8705234C99F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhC2Ia3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232096AbhC2I3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 207CB61581;
        Mon, 29 Mar 2021 08:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006548;
        bh=gCSM7zXPV0rFpWt6rmRxAH+zhgyqSS6xO4K+3HZN9OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntHDY6hpJohXinEN/OiZ7A6fwNcnTQ9sb+1qszQlVvAxor4fZZF0rua2OI3ZbqHmg
         yKQGbB1UmHlgKOtbx9qe4F7RlxSx1ro264hBKzxj2msdS89pSLB3bGSEdd0wZW775g
         VMwtccmlkrY01UViS9H2GM3YKQRhMfAMC0dd3DS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        Sasha Levin <sashal@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 5.11 038/254] u64_stats,lockdep: Fix u64_stats_init() vs lockdep
Date:   Mon, 29 Mar 2021 09:55:54 +0200
Message-Id: <20210329075634.400656379@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



