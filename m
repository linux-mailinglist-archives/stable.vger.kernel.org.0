Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFC9206154
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392069AbgFWUjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392064AbgFWUji (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E99421531;
        Tue, 23 Jun 2020 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944778;
        bh=zALHqMiguNc+FwOzNshQCTuETpDJRuk1PqNXG/LKOjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G37DQPvd/peyjPM544MDuW2wJAjzfwYpISnYKCEA7n6q3ZT7ocq2YPWX+pBa090Nt
         DGvAL8+uc9qFIH6V5cDJkmdFZphDIMaNRkUggOOd9H8rgXH03WU9YkUy9mj/MGtoZP
         DZcYwYDfZxXYPl6XzzS8Ftm8bjB1mqklWQJiXcw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/206] of: Fix a refcounting bug in __of_attach_node_sysfs()
Date:   Tue, 23 Jun 2020 21:57:29 +0200
Message-Id: <20200623195322.910486024@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8a325dd06f2358ea0888e4ff1c9ca4bc23bd53f3 ]

The problem in this code is that if kobject_add() fails, then it should
call of_node_put(np) to drop the reference count.  I've actually moved
the of_node_get(np) later in the function to avoid needing to do clean
up.

Fixes: 5b2c2f5a0ea3 ("of: overlay: add missing of_node_get() in __of_attach_node_sysfs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kobj.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/of/kobj.c b/drivers/of/kobj.c
index c72eef9880417..a32e60b024b8d 100644
--- a/drivers/of/kobj.c
+++ b/drivers/of/kobj.c
@@ -134,8 +134,6 @@ int __of_attach_node_sysfs(struct device_node *np)
 	if (!name)
 		return -ENOMEM;
 
-	of_node_get(np);
-
 	rc = kobject_add(&np->kobj, parent, "%s", name);
 	kfree(name);
 	if (rc)
@@ -144,6 +142,7 @@ int __of_attach_node_sysfs(struct device_node *np)
 	for_each_property_of_node(np, pp)
 		__of_add_property_sysfs(np, pp);
 
+	of_node_get(np);
 	return 0;
 }
 
-- 
2.25.1



