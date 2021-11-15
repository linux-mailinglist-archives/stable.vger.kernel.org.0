Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83820450BAE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbhKOR1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237203AbhKORYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0261261BF8;
        Mon, 15 Nov 2021 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996562;
        bh=slqzTWivB4n+y3F8FdsgHC9WWTRP9fi4xGbZAmrBx3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktIjiUGPnygD0RriHRtBDLguGW/qWTh2BwLy5livqBP+9JXPMmzNnHmos1zT/NZuh
         B9ePgF5r/nYrESfBRClFytP2X1q/pcZNA2qybzTq5fXUSwGMy3D/Xk/4xgdNx460vd
         qECTMB7k7SjPkEUXqbIu3D0cw5Ctl1mLpQ/y98VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/355] net: net_namespace: Fix undefined member in key_remove_domain()
Date:   Mon, 15 Nov 2021 18:01:50 +0100
Message-Id: <20211115165319.791384048@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit aed0826b0cf2e488900ab92193893e803d65c070 ]

The key_domain member in struct net only exists if we define CONFIG_KEYS.
So we should add the define when we used key_domain.

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9bf15512601bf..cd1d40195e461 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -480,7 +480,9 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:
@@ -612,7 +614,9 @@ static void cleanup_net(struct work_struct *work)
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
 		dec_net_namespaces(net->ucounts);
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(net->user_ns);
 		net_drop_ns(net);
 	}
-- 
2.33.0



