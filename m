Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65516171F97
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgB0N7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgB0N7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E6820801;
        Thu, 27 Feb 2020 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811960;
        bh=UNjkvXfQWWXq/yhRlv52KlW+Vqgo0EflO9SgIZ6VtPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBgidTsWBarGk8ubo7gxGQD9Ppb16gEj6Pv+Wq9nzl+4iXIOulRo2ZvW85XUvEFMd
         n9GnQFF9u9AG1b1h+0i+sYu4pvntAKGig7vl6AopZ4SWYafyFEgBraoQQHirfILueG
         k4+fiduBVmGqOjQJQaMemNtjKaC+Q5aMePICMQU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 169/237] net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
Date:   Thu, 27 Feb 2020 14:36:23 +0100
Message-Id: <20200227132308.883193159@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 1afa3cc90f8fb745c777884d79eaa1001d6927a6 ]

unlike other classifiers that can be offloaded (i.e. users can set flags
like 'skip_hw' and 'skip_sw'), 'cls_matchall' doesn't validate the size
of netlink attribute 'TCA_MATCHALL_FLAGS' provided by user: add a proper
entry to mall_policy.

Fixes: b87f7936a932 ("net/sched: Add match-all classifier hw offloading.")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_matchall.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -136,6 +136,7 @@ static void *mall_get(struct tcf_proto *
 static const struct nla_policy mall_policy[TCA_MATCHALL_MAX + 1] = {
 	[TCA_MATCHALL_UNSPEC]		= { .type = NLA_UNSPEC },
 	[TCA_MATCHALL_CLASSID]		= { .type = NLA_U32 },
+	[TCA_MATCHALL_FLAGS]		= { .type = NLA_U32 },
 };
 
 static int mall_set_parms(struct net *net, struct tcf_proto *tp,


