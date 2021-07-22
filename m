Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADD3D2A40
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhGVQKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235372AbhGVQJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0421D6144E;
        Thu, 22 Jul 2021 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972549;
        bh=wd0kcYhS055mgTyDWjPC6MrO7BGEMTWWdtMyV0nsNX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGztqBIAnv1lxtXIQ0VL98TBeMNQ2KM3ctPbIK79OzfnLy+7ldpMmyXGEn4PLvKH9
         01+ZUlZIMyNfzsH1dPbAc7JLn1x3J0X9Cx8BwGQOyGEei4QG9PghxFGkSuhPJ85TNt
         HLMz2YGqe2jT7zkjWeo3rEhhZ0rB7XGNLMMjGg/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 117/156] net/sched: act_ct: fix err check for nf_conntrack_confirm
Date:   Thu, 22 Jul 2021 18:31:32 +0200
Message-Id: <20210722155632.151842910@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

commit 8955b90c3cdad199137809aac8ccbbb585355913 upstream.

The confirm operation should be checked. If there are any failed,
the packet should be dropped like in ovs and netfilter.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1026,7 +1026,8 @@ do_nat:
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-		nf_conntrack_confirm(skb);
+		if (nf_conntrack_confirm(skb) != NF_ACCEPT)
+			goto drop;
 	}
 
 	if (!skip_add)


