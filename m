Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6594B4B56
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348165AbiBNKfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348171AbiBNKel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E51CE5;
        Mon, 14 Feb 2022 02:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84161B80DCD;
        Mon, 14 Feb 2022 10:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B693BC340F0;
        Mon, 14 Feb 2022 10:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832877;
        bh=GNEWetQrwebJFihNGopC2dg0VX/rGux39dWCMrIO/Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTcFPptOUNwvWQHVhJSc70hl2zOpuJlW0aUz3EKVj+OxxagDC6vnLAKY18q5ksoGV
         QEwzMOW8uzQVso60xfsVp5jSzg+QGmtDAFrFEJ1CXNT+tZvJiKDNW2lxszVCWNZQTA
         3mSETLB1kmaalOL+zxHR1LPP1drNzmpxhJc1v6tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Kishen Maloor <kishen.maloor@intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 154/203] mptcp: netlink: process IPv6 addrs in creating listening sockets
Date:   Mon, 14 Feb 2022 10:26:38 +0100
Message-Id: <20220214092515.484395190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

[ Upstream commit 029744cd4bc6e9eb3bd833b4a033348296d34645 ]

This change updates mptcp_pm_nl_create_listen_socket() to create
listening sockets bound to IPv6 addresses (where IPv6 is supported).

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Acked-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5d305fafd0e99..5eada95dd76b3 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -878,6 +878,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct mptcp_sock *msk;
 	struct socket *ssock;
@@ -902,8 +903,11 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	}
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
-	err = kernel_bind(ssock, (struct sockaddr *)&addr,
-			  sizeof(struct sockaddr_in));
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (entry->addr.family == AF_INET6)
+		addrlen = sizeof(struct sockaddr_in6);
+#endif
+	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
 		goto out;
-- 
2.34.1



