Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9234A4501
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiAaLfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376814AbiAaLct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAD8C0610FE;
        Mon, 31 Jan 2022 03:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B674B82A6E;
        Mon, 31 Jan 2022 11:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C85AC340E8;
        Mon, 31 Jan 2022 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628108;
        bh=SgGumDnicN2QeEZGwfbrCV7bTVD6rS+dcb6bMzFZ8yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idW2t3KyKnydgTTmzZY9/c51VwrT9mteqYwiCXYeeyG784Q8ztpPWTrpuBQQCLGko
         0FtkAFPs9/Hhlro8wME/ajsEOeHuHsuC3/pbtOYjn4Dvo1pDVKbkd/BL6QE9335vvH
         0xlKNdgt4ISwLRPYResOdt6chhvo3qZZ2rorp16A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 126/200] netfilter: conntrack: dont increment invalid counter on NF_REPEAT
Date:   Mon, 31 Jan 2022 11:56:29 +0100
Message-Id: <20220131105237.798868727@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 830af2eba40327abec64325a5b08b1e85c37a2e0 ]

The packet isn't invalid, REPEAT means we're trying again after cleaning
out a stale connection, e.g. via tcp tracker.

This caused increases of invalid stat counter in a test case involving
frequent connection reuse, even though no packet is actually invalid.

Fixes: 56a62e2218f5 ("netfilter: conntrack: fix NF_REPEAT handling")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4712a90a1820c..7f79974607643 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1922,15 +1922,17 @@ repeat:
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put(&ct->ct_general);
 		skb->_nfct = 0;
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
-			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 		/* Special case: TCP tracker reports an attempt to reopen a
 		 * closed/aborted connection. We have to go back and create a
 		 * fresh conntrack.
 		 */
 		if (ret == -NF_REPEAT)
 			goto repeat;
+
+		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
+		if (ret == -NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+
 		ret = -ret;
 		goto out;
 	}
-- 
2.34.1



