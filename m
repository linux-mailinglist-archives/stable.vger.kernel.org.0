Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4A33CAA2B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241676AbhGOTMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243594AbhGOTJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6987261418;
        Thu, 15 Jul 2021 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375958;
        bh=+kTrYCl2x0xHEW9LPfjcjBWmOZuqBJz7h7U13wIdCis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xX6O1BAu5i1VlY0Ti150S792TpJEiwgQcdYh0mHn8U52EyVtd12Sy5n3+RK+hfHHI
         lEOMEPK1cLsRnPPKu7ulykp2Y73kK5oqy0EV3YLKpt1iDRA3ymsFyD7j8c660FCCoa
         byeaIwCB1gRl3XjxoecSYiLNinLBjd2aDpZgCipA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 029/266] net/sched: cls_api: increase max_reclassify_loop
Date:   Thu, 15 Jul 2021 20:36:24 +0200
Message-Id: <20210715182619.237236905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 05ff8435e50569a0a6b95e5ceaea43696e8827ab ]

modern userspace applications, like OVN, can configure the TC datapath to
"recirculate" packets several times. If more than 4 "recirculation" rules
are configured, packets can be dropped by __tcf_classify().
Changing the maximum number of reclassifications (from 4 to 16) should be
sufficient to prevent drops in most use cases, and guard against loops at
the same time.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 279f9e2a2319..d73b5c5514a9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1531,7 +1531,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	const int max_reclassify_loop = 4;
+	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
-- 
2.30.2



