Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A7C3A9F58
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbhFPPhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234812AbhFPPg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCECA61076;
        Wed, 16 Jun 2021 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857693;
        bh=N/BE7GtDqvu+uufHGwdQ88erRMq5v+dgNydEAiXnRkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgzzS9aOcdjsFlPY+05IiROsxm8Zv/YOC7nAoQ7iu72U7a7+MtByLXlgwkwjJXDjT
         mTOfTUGpe0kk3qpM1lumgSvhWL52zFy9Mgmf576uIAGDp7D0DSfBSk4fJj43dTEXZJ
         z8/THH5CsxgTLZ2wmHsya60nU0YOHHE9wCMgq8t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/28] fib: Return the correct errno code
Date:   Wed, 16 Jun 2021 17:33:39 +0200
Message-Id: <20210616152835.040788722@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 59607863c54e9eb3f69afc5257dfe71c38bb751e ]

When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bb11fc87bbae..675f27ef6872 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1138,7 +1138,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 {
 	struct net *net;
 	struct sk_buff *skb;
-	int err = -ENOBUFS;
+	int err = -ENOMEM;
 
 	net = ops->fro_net;
 	skb = nlmsg_new(fib_rule_nlmsg_size(ops, rule), GFP_KERNEL);
-- 
2.30.2



