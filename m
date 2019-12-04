Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDC5113210
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfLDSF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbfLDSFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:05:23 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634F420659;
        Wed,  4 Dec 2019 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482722;
        bh=2fVdgC/fjirU6vo9EcK3UR87dC/f+jTse9YxNMAOxKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mj0jOfP87S98KaTy2D2NsWI8I6rlf1vmG0mr8cCi0naaU2r+TO2179xnmXlH6AsCH
         Ycd/AoQj8BnGlWmIj5kYS6qIL19qyui4vub34RNoP5ismqyIl2O6ZtGosnuTFK3Xno
         l49FWAuUOMhXgdM5f0OPpDRAktPL+g3STpRgM3i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/209] net/net_namespace: Check the return value of register_pernet_subsys()
Date:   Wed,  4 Dec 2019 18:55:22 +0100
Message-Id: <20191204175329.569679172@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index 60b88718b1d48..1af25d53f63ca 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -854,7 +854,8 @@ static int __init net_ns_init(void)
 
 	mutex_unlock(&net_mutex);
 
-	register_pernet_subsys(&net_ns_ops);
+	if (register_pernet_subsys(&net_ns_ops))
+		panic("Could not register network namespace subsystems");
 
 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net_newid, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-- 
2.20.1



