Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4E150C87
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgBCQhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbgBCQhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:18 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DA72082E;
        Mon,  3 Feb 2020 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747837;
        bh=gGP/SfIH4lkKGzcbPEvojIacfy9rHxQn6f0FxjI501g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ronKaj2bOCCQGSTG+XuEEQs1BMa/DhSyIYy38gNL3cL3khPh8xEThRm+bCgBN9pm+
         i8N451lsZ6DUzV3Ddlv5eekIRfEyIZh2+POS5UnF4bfwj4a0IRA3WXEeE8DwiMyfa1
         +uwCAMN9uNOAGFIZa/+0/kQkeu9XjktWR8TNNpXU=
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
Subject: [PATCH 5.4 90/90] net: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Mon,  3 Feb 2020 16:20:33 +0000
Message-Id: <20200203161927.937714547@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
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
index 6b6e51db9f3b9..1f31a39236d52 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,23 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
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
@@ -449,9 +466,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
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



