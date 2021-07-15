Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DCE3CA86E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhGOTBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242093AbhGOS6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF00613CC;
        Thu, 15 Jul 2021 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375329;
        bh=nQS3t7wV/RZjdaFDVw4HYZ8B9wPxypO0wSp6Pk74WDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uemUXIxGO6jc1DuylHBKwQWj0PNmZt40XV/9DL6ydSWIcdEr0Hf2bXQqEYRpdyyTr
         n4dXmhgXIxapdf0LAHgEz3/zx+V0Ko5x7c84KuBQofffKS1PypnBC1HlrFhooxJWW+
         w1eJNW1gW4Dz++GK6dfdKnNUSXt0xMA9nPgB9iVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 023/242] net/sched: cls_api: increase max_reclassify_loop
Date:   Thu, 15 Jul 2021 20:36:25 +0200
Message-Id: <20210715182555.867969471@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
index 94f6942d7ec1..2f82ac7c0f93 100644
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



