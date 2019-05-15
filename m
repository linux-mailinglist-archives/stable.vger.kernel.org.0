Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47ED01F232
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfEOLPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729987AbfEOLOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:14:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B70C2084F;
        Wed, 15 May 2019 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918894;
        bh=WbgY9iauJgkuWAinSK5vM4iwwUeS6JA0kV3PEpjh3tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLlYG+Ewi30dPcyGcGn7ZASybXzxoa2BxnTA3zk0/EV1uyua8lSXVX/EuTAhqN3OW
         6iEF38kN6IvM0GE07G5cE3kqlh6KgWOXWVx0pXoF7/DOesIl2PJip6x3l0X28wYstH
         uXv/Q1w9egQXgKAn7ZZxW/8/gPOIli7C3Uy+ziXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied
Date:   Wed, 15 May 2019 12:56:16 +0200
Message-Id: <20190515090628.066392616@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
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
@@ -429,9 +429,9 @@ int fib_nl_newrule(struct sk_buff *skb,
 	if (rule->l3mdev && rule->table)
 		goto errout_free;
 
-	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
-	    rule_exists(ops, frh, tb, rule)) {
-		err = -EEXIST;
+	if (rule_exists(ops, frh, tb, rule)) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			err = -EEXIST;
 		goto errout_free;
 	}
 


