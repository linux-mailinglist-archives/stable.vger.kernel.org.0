Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FB82D03F0
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLFLlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728851AbgLFLli (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:41:38 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 12/39] staging/octeon: fix up merge error
Date:   Sun,  6 Dec 2020 12:17:16 +0100
Message-Id: <20201206111555.264456188@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 673b41e04a035d760bc0aff83fa9ee24fd9c2779 upstream.

There's a semantic conflict in the Octeon staging network driver, which
used the skb_reset_tc() function to reset skb state when re-using an
skb.  But that inline helper function was removed in mainline by commit
2c64605b590e ("net: Fix CONFIG_NET_CLS_ACT=n and
CONFIG_NFT_FWD_NETDEV={y, m} build").

Fix it by using skb_reset_redirect() instead.  Also move it out of the

This code path only ends up triggering if REUSE_SKBUFFS_WITHOUT_FREE is
enabled, which in turn only happens if you don't have CONFIG_NETFILTER
configured.  Which was how this wasn't caught by the usual allmodconfig
builds.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/octeon/ethernet-tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -352,10 +352,10 @@ int cvm_oct_xmit(struct sk_buff *skb, st
 	skb_dst_set(skb, NULL);
 	skb_ext_reset(skb);
 	nf_reset_ct(skb);
+	skb_reset_redirect(skb);
 
 #ifdef CONFIG_NET_SCHED
 	skb->tc_index = 0;
-	skb_reset_tc(skb);
 #endif /* CONFIG_NET_SCHED */
 #endif /* REUSE_SKBUFFS_WITHOUT_FREE */
 


