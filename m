Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B253CA6E7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhGOSvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237917AbhGOSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA78613E0;
        Thu, 15 Jul 2021 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374861;
        bh=vC2jNN6lJLLT6eGljA0ccjhw4SGacE5QaRnNIflnTyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTlN8Kc3Cy7i/S1rT3AN5N20P9tZmQ5x5xNuDbPYhp2kEKJsR2zboJ0pqJfHvtFP5
         H/63pmqUuV3NCh24Or56fqOkTyItdLUpnaByAWULTpKcaO+YWJg1LTtGUCERX+CZGu
         TCVZHVcu5jBDVgfHN31jQleUZBqkPZKqY0xEnmdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/215] net/sched: cls_api: increase max_reclassify_loop
Date:   Thu, 15 Jul 2021 20:36:34 +0200
Message-Id: <20210715182602.772139924@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index a281da07bb1d..30090794b791 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1532,7 +1532,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	const int max_reclassify_loop = 4;
+	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
-- 
2.30.2



