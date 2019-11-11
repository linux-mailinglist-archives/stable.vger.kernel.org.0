Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F37F7C39
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfKKSoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbfKKSoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:44:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99080204FD;
        Mon, 11 Nov 2019 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497855;
        bh=7Zx5WexqxXUn4t1M1GCJrjMg/F094LVBD2rkt4QOsNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2apHosSV3GEGeSLjiqzIALJ0aoujvSy+1OIsHzPEHd+N5rvVc+0iDhik4Cbazn/S1
         GubWL/iViZdDzcegap8J9Osva+5NsXw69bxLqp8jhKzJ1DEshICcLnVyR/6OLMNKWz
         Pa3Dpo9XyYuuGXVBvZ9x9iXY8IktLXdb2hFi/iqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/125] iw_cxgb4: fix ECN check on the passive accept
Date:   Mon, 11 Nov 2019 19:28:34 +0100
Message-Id: <20191111181450.129063326@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
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
index 3be6405d9855e..566bfcc6add0d 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2380,20 +2380,6 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
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
@@ -2439,6 +2425,20 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
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



