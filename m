Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E14171F98
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgB0N7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732441AbgB0N7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E420D24691;
        Thu, 27 Feb 2020 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811963;
        bh=5h+kCb8bv4EXJk/g5n0d2NpkVD8AA6gYd/Gzzlzzdho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3zAoAasGfuDt+Ybyk6JSsYtMu5VwSQzEI8whH4xG8r5JhSh5pB+9t9EgytMwhXtR
         p7frm0rH8yhIJ1zCO1ZcCA5hl6cZd5fSpFzBOkILVy6peutRiWCa2Hj7kuR5y4EUq+
         Dw7Lr59U8gzndz9ALnmgpcgPoafBG1i5qM4BS0mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 170/237] net/sched: flower: add missing validation of TCA_FLOWER_FLAGS
Date:   Thu, 27 Feb 2020 14:36:24 +0100
Message-Id: <20200227132308.950159073@linuxfoundation.org>
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

[ Upstream commit e2debf0852c4d66ba1a8bde12869b196094c70a7 ]

unlike other classifiers that can be offloaded (i.e. users can set flags
like 'skip_hw' and 'skip_sw'), 'cls_flower' doesn't validate the size of
netlink attribute 'TCA_FLOWER_FLAGS' provided by user: add a proper entry
to fl_policy.

Fixes: 5b33f48842fa ("net/flower: Introduce hardware offload support")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -445,6 +445,7 @@ static const struct nla_policy fl_policy
 	[TCA_FLOWER_KEY_IP_TOS_MASK]	= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_IP_TTL]		= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_IP_TTL_MASK]	= { .type = NLA_U8 },
+	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
 };
 
 static void fl_set_key_val(struct nlattr **tb,


