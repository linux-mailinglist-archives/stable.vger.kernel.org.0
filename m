Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C73D27FA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhGVPyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhGVPyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AA261363;
        Thu, 22 Jul 2021 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971675;
        bh=/aOm63D165gNBSlu0Y0NQNDl3CrxydhCFx+o6586obc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIVLRoFEq3jGrX2dh/eC6eSYPRryKDN3YvKQXGII4MZ3OFhfWeZK0jE35ID+uN08e
         i6i2U2WS8pUjrwdaLPUUJmxhArN4dc7pl/45A6lUAElDcmXln02cd0sHjBtAp5dxar
         HY4nkkomxLCICBEAN2zPmFdY2zHTO0bjleYZWSt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 56/71] net/sched: act_ct: fix err check for nf_conntrack_confirm
Date:   Thu, 22 Jul 2021 18:31:31 +0200
Message-Id: <20210722155619.765430454@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
@@ -474,7 +474,8 @@ static int tcf_ct_act(struct sk_buff *sk
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
-		nf_conntrack_confirm(skb);
+		if (nf_conntrack_confirm(skb) != NF_ACCEPT)
+			goto drop;
 	}
 
 out_push:


