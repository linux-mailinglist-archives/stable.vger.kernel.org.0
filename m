Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A74111EA4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfLCWxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbfLCWxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E42D207DD;
        Tue,  3 Dec 2019 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413582;
        bh=su1n9rIFco9QybKw4v3E7bYzZ5i2FUYnqUp43IBNZ6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x96LpU1Gf9xJn3IP+ZnEVAPaxXan4Yj20Anq3P0N4SGOs+b3JUBBpVJuLRXNqMltG
         V1Y8MGu+xEOQsgnalSx15632dKshe9eyEYaTfe8N7odSzVyf+psKXl09arFbeXn7QY
         V1FbDm7OlgFVSYqvXmDOMwt/1W/PB+fwMUNnjZz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/321] net/net_namespace: Check the return value of register_pernet_subsys()
Date:   Tue,  3 Dec 2019 23:34:10 +0100
Message-Id: <20191203223436.695979889@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 0eb987c874dc93f9c9d85a6465dbde20fdd3884c ]

In net_ns_init(), register_pernet_subsys() could fail while registering
network namespace subsystems. The fix checks the return value and
sends a panic() on failure.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6dab186d4b8f6..c60123dff8039 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -913,7 +913,8 @@ static int __init net_ns_init(void)
 	init_net_initialized = true;
 	up_write(&pernet_ops_rwsem);
 
-	register_pernet_subsys(&net_ns_ops);
+	if (register_pernet_subsys(&net_ns_ops))
+		panic("Could not register network namespace subsystems");
 
 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net_newid, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-- 
2.20.1



