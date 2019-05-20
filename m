Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEC423710
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbfETMU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387995AbfETMU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD60220815;
        Mon, 20 May 2019 12:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354826;
        bh=TsPPkJYp+ZBdS1q8wsLMPm+8Niv0sOmwjalvpw3DW0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtBHMK2u1DnaR5Ocqm+HnOWbniux0V9xD1A6d0/pHMhca5WZltiE9QxPYTwBSy1H4
         MydbztGcK70c7JGvN422N95gYTKdcOgQoJsfaA2FVinF2Hiepgl3GxcLutBQZBsHvT
         FRtj0tRPJzWOTw8Wn1HiCtcJWv2fzhPHKkiMnhTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 55/63] fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")
Date:   Mon, 20 May 2019 14:14:34 +0200
Message-Id: <20190520115237.123078911@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When commit e9919a24d302 ("fib_rules: return 0 directly if an exactly
same rule exists when NLM_F_EXCL not supplied") was backported to 4.9.y,
it changed the logic a bit as err should have been reset before exiting
the test, like it happens in the original logic.

If this is not set, errors happen :(

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
Reported-by: Florian Westphal <fw@strlen.de>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bb26457e8c21..c03dd2104d33 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -430,6 +430,7 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh)
 		goto errout_free;
 
 	if (rule_exists(ops, frh, tb, rule)) {
+		err = 0;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			err = -EEXIST;
 		goto errout_free;
-- 
2.21.0



