Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFED126BF3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfLSSwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbfLSSwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F29024682;
        Thu, 19 Dec 2019 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781522;
        bh=gKp0kLwEZtfoMIRyilffqiIiy8JnWwnaPbDGjIDGXFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEAhJTtmmUsOn05EJ6Hx8zxjjgWgivS+uyQ6RRPj3qPo09Ie1dM6oe8nxcxP/iGLm
         Nuwy0vJqW8qTrYoBXQrJPgrOYmymYzIpi/fNrgyqkilO8c1yPNjbrMOuWIGDoKq55Q
         73PM1Fs24vKMs49wMQMLn4BUVePY4dYyOQvvc0cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/47] mqprio: Fix out-of-bounds access in mqprio_dump
Date:   Thu, 19 Dec 2019 19:34:16 +0100
Message-Id: <20191219182859.277595108@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

[ Upstream commit 9f104c7736904ac72385bbb48669e0c923ca879b ]

When user runs a command like
tc qdisc add dev eth1 root mqprio
KASAN stack-out-of-bounds warning is emitted.
Currently, NLA_ALIGN macro used in mqprio_dump provides too large
buffer size as argument for nla_put and memcpy down the call stack.
The flow looks like this:
1. nla_put expects exact object size as an argument;
2. Later it provides this size to memcpy;
3. To calculate correct padding for SKB, nla_put applies NLA_ALIGN
   macro itself.

Therefore, NLA_ALIGN should not be applied to the nla_put parameter.
Otherwise it will lead to out-of-bounds memory access in memcpy.

Fixes: 4e8b86c06269 ("mqprio: Introduce new hardware offload mode and shaper in mqprio")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_mqprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -435,7 +435,7 @@ static int mqprio_dump(struct Qdisc *sch
 		opt.offset[tc] = dev->tc_to_txq[tc].offset;
 	}
 
-	if (nla_put(skb, TCA_OPTIONS, NLA_ALIGN(sizeof(opt)), &opt))
+	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
 	if ((priv->flags & TC_MQPRIO_F_MODE) &&


