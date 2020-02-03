Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70630150ADD
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgBCQVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgBCQVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:21:38 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB5E2082E;
        Mon,  3 Feb 2020 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746897;
        bh=oKZbqfKBVBd7S9Pmqqcf6tikz9KkfYkgak1xWOtGQwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9s2OJ7wEEQzXmX+heoTMtrLI0W+CBLkagWRIKa+jgJzxWUfAMjIgYL0kSg4gyITs
         d7+c6rMdGJ0s2e9zqTRCOxSxFY6Qr/GVt/laj7JFTPLjwY9lPItuzqn1yV8BEPbSRJ
         hiVp0ZwDjrqtb6/2TDDFIgIuvEabP8WhKwsQfNPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Praveen Chaudhary <pchaudhary@linkedin.com>,
        Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 53/53] net: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Mon,  3 Feb 2020 16:19:45 +0000
Message-Id: <20200203161912.092635285@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Praveen Chaudhary <praveen5582@gmail.com>

[ Upstream commit 189c9b1e94539b11c80636bc13e9cf47529e7bba ]

skb->csum is updated incorrectly, when manipulation for
NF_NAT_MANIP_SRC\DST is done on IPV6 packet.

Fix:
There is no need to update skb->csum in inet_proto_csum_replace16(),
because update in two fields a.) IPv6 src/dst address and b.) L4 header
checksum cancels each other for skb->csum calculation. Whereas
inet_proto_csum_replace4 function needs to update skb->csum, because
update in 3 fields a.) IPv4 src/dst address, b.) IPv4 Header checksum
and c.) L4 header checksum results in same diff as L4 Header checksum
for skb->csum calculation.

[ pablo@netfilter.org: a few comestic documentation edits ]
Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/utils.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 3d17ca8b47441..13eb3552de078 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -316,6 +316,23 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * inet_proto_csum_replace16 - update layer 4 header checksum field
+ * @sum: Layer 4 header checksum field
+ * @skb: sk_buff for the packet
+ * @from: old IPv6 address
+ * @to: new IPv6 address
+ * @pseudohdr: True if layer 4 header checksum includes pseudoheader
+ *
+ * Update layer 4 header as per the update in IPv6 src/dst address.
+ *
+ * There is no need to update skb->csum in this function, because update in two
+ * fields a.) IPv6 src/dst address and b.) L4 header checksum cancels each other
+ * for skb->csum calculation. Whereas inet_proto_csum_replace4 function needs to
+ * update skb->csum, because update in 3 fields a.) IPv4 src/dst address,
+ * b.) IPv4 Header checksum and c.) L4 header checksum results in same diff as
+ * L4 Header checksum for skb->csum calculation.
+ */
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr)
@@ -327,9 +344,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		*sum = csum_fold(csum_partial(diff, sizeof(diff),
 				 ~csum_unfold(*sum)));
-		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_partial(diff, sizeof(diff),
-						  ~skb->csum);
 	} else if (pseudohdr)
 		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
 				  csum_unfold(*sum)));
-- 
2.20.1



