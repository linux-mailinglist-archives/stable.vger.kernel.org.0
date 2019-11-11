Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB65F7D16
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfKKSw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbfKKSwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:52:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060DC20818;
        Mon, 11 Nov 2019 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498373;
        bh=N1fXnElCxnJo7SUkIASvC5jDqYqX/TV4zRbeym2fMSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr12KgQnkzwq5HrLuu+An/EHRsdzKxNvgnvD0qdCYK5jhv9whxCEnwdEThe9SJrC6
         8N4GhLF6Gj4Vuws5p+khM0/jQpSDbqoI7gMIsbjbsC3POoPLlX5Jvv4WLnzKp7cj40
         chGwC3OLtuvt/jZn1DZXSr1sCiXSZPDyStKEIBIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 100/193] iw_cxgb4: fix ECN check on the passive accept
Date:   Mon, 11 Nov 2019 19:28:02 +0100
Message-Id: <20191111181508.514147291@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

[ Upstream commit 612e0486ad0845c41ac10492e78144f99e326375 ]

pass_accept_req() is using the same skb for handling accept request and
sending accept reply to HW. Here req and rpl structures are pointing to
same skb->data which is over written by INIT_TP_WR() and leads to
accessing corrupt req fields in accept_cr() while checking for ECN flags.
Reordered code in accept_cr() to fetch correct req fields.

Fixes: 92e7ae7172 ("iw_cxgb4: Choose appropriate hw mtu index and ISS for iWARP connections")
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://lore.kernel.org/r/20191003104353.11590-1-bharat@chelsio.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e87fc04084704..9e8eca7b613c0 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2424,20 +2424,6 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
 
 	pr_debug("ep %p tid %u\n", ep, ep->hwtid);
-
-	skb_get(skb);
-	rpl = cplhdr(skb);
-	if (!is_t4(adapter_type)) {
-		skb_trim(skb, roundup(sizeof(*rpl5), 16));
-		rpl5 = (void *)rpl;
-		INIT_TP_WR(rpl5, ep->hwtid);
-	} else {
-		skb_trim(skb, sizeof(*rpl));
-		INIT_TP_WR(rpl, ep->hwtid);
-	}
-	OPCODE_TID(rpl) = cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
-						    ep->hwtid));
-
 	cxgb_best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx,
 		      enable_tcp_timestamps && req->tcpopt.tstamp,
 		      (ep->com.remote_addr.ss_family == AF_INET) ? 0 : 1);
@@ -2483,6 +2469,20 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 		if (tcph->ece && tcph->cwr)
 			opt2 |= CCTRL_ECN_V(1);
 	}
+
+	skb_get(skb);
+	rpl = cplhdr(skb);
+	if (!is_t4(adapter_type)) {
+		skb_trim(skb, roundup(sizeof(*rpl5), 16));
+		rpl5 = (void *)rpl;
+		INIT_TP_WR(rpl5, ep->hwtid);
+	} else {
+		skb_trim(skb, sizeof(*rpl));
+		INIT_TP_WR(rpl, ep->hwtid);
+	}
+	OPCODE_TID(rpl) = cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
+						    ep->hwtid));
+
 	if (CHELSIO_CHIP_VERSION(adapter_type) > CHELSIO_T4) {
 		u32 isn = (prandom_u32() & ~7UL) - 1;
 		opt2 |= T5_OPT_2_VALID_F;
-- 
2.20.1



