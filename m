Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FE7451FC7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351714AbhKPApU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343781AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5BE0635EE;
        Mon, 15 Nov 2021 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001956;
        bh=NI7zBScXgUn1dJYUmrMvAMBwb7QS3r40QQ1IwAkOqc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDFuKsIlYnu3mPmHUSlPFrBC203B2+rYUR86IUi045JvuquRj4pbuALcbNw+YImyQ
         MR6gWxpLyi95l46RzLWeHbRZgcrKzk1nwaYHWxBoUbJbZvqeoOwznoTJAtO0GAurCU
         YlFFLVZG80IZg/whSOSGt15rL/TAXLtp5ecp97VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/917] net: net_namespace: Fix undefined member in key_remove_domain()
Date:   Mon, 15 Nov 2021 17:57:16 +0100
Message-Id: <20211115165440.313689142@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index a448a9b5bb2d6..202fa5eacd0f9 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -473,7 +473,9 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(user_ns);
 		net_free(net);
 dec_ucounts:
@@ -605,7 +607,9 @@ static void cleanup_net(struct work_struct *work)
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
 		dec_net_namespaces(net->ucounts);
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(net->user_ns);
 		net_free(net);
 	}
-- 
2.33.0



