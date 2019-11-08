Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4982EF4945
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390334AbfKHLnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390287AbfKHLnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF3521D82;
        Fri,  8 Nov 2019 11:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213381;
        bh=E19oXiWamBZ3jQIs/It2J/lNITsNHRyrUBJ4VSnzC/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfhXFwt3JoN63+GbRK9PJ06wEHeYGDe8UuNaMt9NzwNd9VwKTguVjs+5yjI2a2V7J
         aJPRXZJ8nvK2SX+7oHDc5bYT+7KKPUUWeiyLxi3E5KtAQTtSReugeC3fwYSJfrlExw
         sw5FkDu2qpk4bw0pAX3efFTwVcVKQZ7Ahq6Vfm/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 204/205] s390/qeth: limit csum offload erratum to L3 devices
Date:   Fri,  8 Nov 2019 06:37:51 -0500
Message-Id: <20191108113752.12502-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit f231dc9dbd789b0f98a15941e3cebedb4ad72ad5 ]

Combined L3+L4 csum offload is only required for some L3 HW. So for
L2 devices, don't offload the IP header csum calculation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reference-ID: JUP 394553
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h    | 5 -----
 drivers/s390/net/qeth_l3_main.c | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index b2657582cfcfd..41a2f901ccee5 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -902,11 +902,6 @@ static inline void qeth_tx_csum(struct sk_buff *skb, u8 *flags, int ipv)
 	if ((ipv == 4 && ip_hdr(skb)->protocol == IPPROTO_UDP) ||
 	    (ipv == 6 && ipv6_hdr(skb)->nexthdr == IPPROTO_UDP))
 		*flags |= QETH_HDR_EXT_UDP;
-	if (ipv == 4) {
-		/* some HW requires combined L3+L4 csum offload: */
-		*flags |= QETH_HDR_EXT_CSUM_HDR_REQ;
-		ip_hdr(skb)->check = 0;
-	}
 }
 
 static inline void qeth_put_buffer_pool_entry(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 9c5e801b3f6cb..c60660cb5a031 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2054,6 +2054,11 @@ static void qeth_l3_fill_header(struct qeth_card *card, struct qeth_hdr *hdr,
 
 	if (!skb_is_gso(skb) && skb->ip_summed == CHECKSUM_PARTIAL) {
 		qeth_tx_csum(skb, &hdr->hdr.l3.ext_flags, ipv);
+		/* some HW requires combined L3+L4 csum offload: */
+		if (ipv == 4) {
+			hdr->hdr.l3.ext_flags |= QETH_HDR_EXT_CSUM_HDR_REQ;
+			ip_hdr(skb)->check = 0;
+		}
 		if (card->options.performance_stats)
 			card->perf_stats.tx_csum++;
 	}
-- 
2.20.1

