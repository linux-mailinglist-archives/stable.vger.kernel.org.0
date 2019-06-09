Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B4E3A8AD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbfFIRDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732837AbfFIRDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A836220843;
        Sun,  9 Jun 2019 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099783;
        bh=v8jViTz1Qm/qg5OtQF+8F/At7QLvjzJgBcP9xOl6joc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jche9IaP6For1VhF8Wgz3KT/TDyCPUqymMMMQC9177ffj3tM1lCl1KULJUay2CECC
         aBRRQaGi36uW5hhqnhOoGgPPpq6/4R6Xj6QohCrvDGB3Ab3DEj61ntuNn5ejGJCdbm
         szsb5p4vD60sMBaAUQXlGFojl/Y4pOgU4TXpMxAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 164/241] cxgb3/l2t: Fix undefined behaviour
Date:   Sun,  9 Jun 2019 18:41:46 +0200
Message-Id: <20190609164152.508267997@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 76497732932f15e7323dc805e8ea8dc11bb587cf ]

The use of zero-sized array causes undefined behaviour when it is not
the last member in a structure. As it happens to be in this case.

Also, the current code makes use of a language extension to the C90
standard, but the preferred mechanism to declare variable-length
types such as this one is a flexible array member, introduced in
C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last. Which is beneficial
to cultivate a high-quality code.

Fixes: e48f129c2f20 ("[SCSI] cxgb3i: convert cdev->l2opt to use rcu to prevent NULL dereference")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb3/l2t.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/l2t.h b/drivers/net/ethernet/chelsio/cxgb3/l2t.h
index 8cffcdfd56782..38b5858c335a9 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/l2t.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/l2t.h
@@ -75,8 +75,8 @@ struct l2t_data {
 	struct l2t_entry *rover;	/* starting point for next allocation */
 	atomic_t nfree;		/* number of free entries */
 	rwlock_t lock;
-	struct l2t_entry l2tab[0];
 	struct rcu_head rcu_head;	/* to handle rcu cleanup */
+	struct l2t_entry l2tab[];
 };
 
 typedef void (*arp_failure_handler_func)(struct t3cdev * dev,
-- 
2.20.1



