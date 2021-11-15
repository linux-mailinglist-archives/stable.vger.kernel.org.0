Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B34526CE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhKPCKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239321AbhKOSAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E4D6333A;
        Mon, 15 Nov 2021 17:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997778;
        bh=QkbMNHLS6JZCxXMOvzeXAIPDQ+k5McXIovFYYhzs+ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cckKU1Xez5YcTbJVOhDP3IGfQ7OTFra67ivEXtBFhQyRrOwXdCb/uv4cZ2+jkVLxf
         i5PXhqFCS3tDxUTqtmUDrVoMZL7a8skogNtkO77KJROVqOjF7iFQcHtbywuR7FE0SF
         Gzgicd26mejyOAzYBkzJX2qRT1UUPZog2tNWVf0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/575] net: net_namespace: Fix undefined member in key_remove_domain()
Date:   Mon, 15 Nov 2021 17:59:56 +0100
Message-Id: <20211115165353.138984103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 5c9d95f30be60..ac852db83de9f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -486,7 +486,9 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:
@@ -618,7 +620,9 @@ static void cleanup_net(struct work_struct *work)
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



