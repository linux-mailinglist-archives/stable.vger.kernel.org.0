Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814534C56C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhC2IAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229762AbhC2H7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 03:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5726196B;
        Mon, 29 Mar 2021 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004795;
        bh=ELKO9Cy2wCXnBkRN3a+2su6DS9jpGee7xyY3YKS/PnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHZLNHdElddIhfZlqevYhA7sIjo2Tp31+neR3JW4Y4yPJr4KCZG7jRsYq53bkvk4d
         oHLCiz5sJts5PeOOCr/anacmMYUf0GLNmdaZBY1X7DWuw0IbPiA7ZsFkTz4xEvds6G
         GvX1s/JrTFmCkblzMRmje8gTcZ+agtt0xHMjtqiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Erhard F." <erhard_f@mailbox.org>,
        Sasha Levin <sashal@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 4.4 11/33] u64_stats,lockdep: Fix u64_stats_init() vs lockdep
Date:   Mon, 29 Mar 2021 09:57:56 +0200
Message-Id: <20210329075605.637799024@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
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
index df89c9bcba7d..7b38288dc239 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -68,12 +68,13 @@ struct u64_stats_sync {
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



