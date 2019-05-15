Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E831EF25
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbfEOLac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732730AbfEOLa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCF92084A;
        Wed, 15 May 2019 11:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919828;
        bh=kndu8SAtUtlE6O5XFX8Lvk1NrcXtcxLc7hvEAE7f7uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiUlz/Y0lVSpQts8FqofY6rb3OhjvAs18FMoDWpGhwN8nYb8CEtTovd6t5HnjbHro
         ccMaROoMjaI7TsSgkEmaxvS9anewdNwK0UfXF4G5x2PnwyXbKTT57GMHQwhBjB+AMn
         nPE6HLOAwa3xWl1ypzG43nd/U/+c4+r8FUbh2Eh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 108/137] fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied
Date:   Wed, 15 May 2019 12:56:29 +0200
Message-Id: <20190515090701.414733828@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e9919a24d3022f72bcadc407e73a6ef17093a849 ]

With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
fib_nl_newrule") we now able to check if a rule already exists. But this
only works with iproute2. For other tools like libnl, NetworkManager,
it still could add duplicate rules with only NLM_F_CREATE flag, like

[localhost ~ ]# ip rule
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default
100000: from 192.168.7.5 lookup 5
100000: from 192.168.7.5 lookup 5

As it doesn't make sense to create two duplicate rules, let's just return
0 if the rule exists.

Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
Reported-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -756,9 +756,9 @@ int fib_nl_newrule(struct sk_buff *skb,
 	if (err)
 		goto errout;
 
-	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
-	    rule_exists(ops, frh, tb, rule)) {
-		err = -EEXIST;
+	if (rule_exists(ops, frh, tb, rule)) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			err = -EEXIST;
 		goto errout_free;
 	}
 


