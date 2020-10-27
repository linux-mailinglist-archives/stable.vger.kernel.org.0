Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECA529B95A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766431AbgJ0PsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794941AbgJ0PSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC882064B;
        Tue, 27 Oct 2020 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811931;
        bh=9BM9kMAapkeQfx1UEEjUi2sDNYGdZC3u89yTbh5MjBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ppk7TAxIhmZQNC5S1C1evv0riJ/tZ4Tl6mqPFONzHCpNJIk3YGaapbgBEJZ5UtxpU
         1aPe6sxR9k6sf6h+MJoOca1HDBcNGMecV84XmEOSwDETsAnsHw62V95pao93rugZpp
         eAJpvolOczKQwpBkRuMT0P+oXpw6LJ2fjEIYgzIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Ellapu <venkatesh.e@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 033/757] chelsio/chtls: fix panic when server is on ipv6
Date:   Tue, 27 Oct 2020 14:44:43 +0100
Message-Id: <20201027135452.079270485@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 86cdf9ca4409d997a391103e480b3f77b7ccc19b ]

Netdev is filled in egress_dev when connection is established,
If connection is closed before establishment, then egress_dev
is NULL, Fix it using ip_dev_find() rather then extracting from
egress_dev.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -736,14 +736,13 @@ void chtls_listen_stop(struct chtls_dev
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
-		struct chtls_sock *csk;
+		struct net_device *ndev = chtls_find_netdev(cdev, sk);
 		int addr_type = 0;
 
-		csk = rcu_dereference_sk_user_data(sk);
 		addr_type = ipv6_addr_type((const struct in6_addr *)
 					  &sk->sk_v6_rcv_saddr);
 		if (addr_type != IPV6_ADDR_ANY)
-			cxgb4_clip_release(csk->egress_dev, (const u32 *)
+			cxgb4_clip_release(ndev, (const u32 *)
 					   &sk->sk_v6_rcv_saddr, 1);
 	}
 #endif


