Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1396F3DD885
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhHBNw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhHBNvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A5C3610FE;
        Mon,  2 Aug 2021 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912260;
        bh=2jn9FWGO1qoY5uU5T2PrJ4ffgaBkKIi44ZJygy7kA24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TSJA7g08YbZKBU07RDv9TkvXObzmwlYdL5s11CO73hzZ+GVVkf1LTsTV0fKUUe+x
         AdwckGcNvLSf7kivzXmGJoG9W35APr1KIouO4KF8i/fBrp8o0eDe5c54i60TI+paFk
         RkoGVAfVCZdO8JizGkKJXY1bkp0hgU/9Q6QAdD3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/40] netfilter: conntrack: adjust stop timestamp to real expiry value
Date:   Mon,  2 Aug 2021 15:45:00 +0200
Message-Id: <20210802134336.035104638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
index 9a40312b1f16..4a988ce4264c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -660,8 +660,13 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
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



