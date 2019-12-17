Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC591236EC
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfLQURC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbfLQURB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:17:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D8D21775;
        Tue, 17 Dec 2019 20:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613820;
        bh=Rbxn+mhz5nZooNXEHWaE4uC+r8lmHz35r1FEl8qsTw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd3lAt0cn/Mt5teTJum/fBVpwY7V2NKyCy6ooQbRKd0jeoXU2j3zy31oDJRtz8rv2
         RJnOPPd1EDjESKd/+S82VW6AscebXBwnPiNZlb/t9hn5ip/f03GZEZtGQYxYx7kqhz
         UtVrgpz5792meR7V5PFdY6+WavpW1fuCkbPDLWpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 02/25] mqprio: Fix out-of-bounds access in mqprio_dump
Date:   Tue, 17 Dec 2019 21:16:01 +0100
Message-Id: <20191217200904.475066246@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
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
@@ -433,7 +433,7 @@ static int mqprio_dump(struct Qdisc *sch
 		opt.offset[tc] = dev->tc_to_txq[tc].offset;
 	}
 
-	if (nla_put(skb, TCA_OPTIONS, NLA_ALIGN(sizeof(opt)), &opt))
+	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
 	if ((priv->flags & TC_MQPRIO_F_MODE) &&


