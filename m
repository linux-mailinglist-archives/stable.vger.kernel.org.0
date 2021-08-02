Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAFB3DD98F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhHBOB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236493AbhHBN7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3036661178;
        Mon,  2 Aug 2021 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912550;
        bh=aVv69bOH2TtShIyhTj773uLwMnJXJi6e8yAXHGAmDkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIvEkgwpNdmcV5vpNL58JgkN04sjWwYnxMeOwjHTWJtI6Sp3CqRLhxi9U/cKWv/Oa
         3oG7wnS7zJfA+Ozqyhs2g8Etm+U7dyHXC2QbcKAKiXRccKGmp44SynIoBX9c9Xcf5F
         tSO6477KzCW9hEFgBr00vDnC4aA+rW2+AVsI5EQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/104] netfilter: conntrack: adjust stop timestamp to real expiry value
Date:   Mon,  2 Aug 2021 15:44:40 +0200
Message-Id: <20210802134345.440503465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 30a56a2b881821625f79837d4d968c679852444e ]

In case the entry is evicted via garbage collection there is
delay between the timeout value and the eviction event.

This adjusts the stop value based on how much time has passed.

Fixes: b87a2f9199ea82 ("netfilter: conntrack: add gc worker to remove timed-out entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0befcf8113a..69079a382d3a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -666,8 +666,13 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 		return false;
 
 	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp && tstamp->stop == 0)
+	if (tstamp) {
+		s32 timeout = ct->timeout - nfct_time_stamp;
+
 		tstamp->stop = ktime_get_real_ns();
+		if (timeout < 0)
+			tstamp->stop -= jiffies_to_nsecs(-timeout);
+	}
 
 	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
 				    portid, report) < 0) {
-- 
2.30.2



