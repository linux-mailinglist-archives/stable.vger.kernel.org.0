Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5579177EA8
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbgCCRpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730935AbgCCRpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C1A208C3;
        Tue,  3 Mar 2020 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257530;
        bh=Rqp/ARyYPO2zu40G6KAp2PLfdRwHjZ7O81/4Wjtotyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H78A7KgTSyLwzX1XPWrprnqSGRg+T+DlDTrXuR7lJRMVQHNUhKTAbP3ypijE8kPlh
         UH/aMWatdOVSyDdFgQoTgAFv6+rW4X+WIu5qfd9Iqs1BuXVb0ldwi6afKvRS4Pg0+q
         ZbsJvdSNJCo5ygNm3jsNNCjnUGrqhsVmWU9d0734=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 003/176] net: fib_rules: Correctly set table field when table number exceeds 8 bits
Date:   Tue,  3 Mar 2020 18:41:07 +0100
Message-Id: <20200303174304.979054909@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jethro Beekman <jethro@fortanix.com>

[ Upstream commit 540e585a79e9d643ede077b73bcc7aa2d7b4d919 ]

In 709772e6e06564ed94ba740de70185ac3d792773, RT_TABLE_COMPAT was added to
allow legacy software to deal with routing table numbers >= 256, but the
same change to FIB rule queries was overlooked.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -974,7 +974,7 @@ static int fib_nl_fill_rule(struct sk_bu
 
 	frh = nlmsg_data(nlh);
 	frh->family = ops->family;
-	frh->table = rule->table;
+	frh->table = rule->table < 256 ? rule->table : RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, FRA_TABLE, rule->table))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, FRA_SUPPRESS_PREFIXLEN, rule->suppress_prefixlen))


