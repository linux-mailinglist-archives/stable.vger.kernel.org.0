Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D1E34C62B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhC2IFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhC2IEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD1A6196F;
        Mon, 29 Mar 2021 08:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005076;
        bh=Mezd5IsWSGg9kjEJcYPEX04+99/OxMusHKruQU9CGVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9YNCl9QgrY66Ord8cGfagS9cjh0dog2ECx3FhVbkB9C2+XpD4qCZUHXH5HQFtAaL
         uq2GQELRj98LfGaPO0fzNoTychDG4jiKtSCj5IYmy3XeGqcO21cR3zbG5Ljg7V5U1/
         5R+SrzWwppt2pp55cAP6/Ar8LEEGOEHdHUG8vCR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        Sasha Levin <sashal@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 4.14 17/59] u64_stats,lockdep: Fix u64_stats_init() vs lockdep
Date:   Mon, 29 Mar 2021 09:57:57 +0200
Message-Id: <20210329075609.449789479@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
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
index 07ee0f84a46c..eb0a2532eb6f 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -69,12 +69,13 @@ struct u64_stats_sync {
 };
 
 
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



