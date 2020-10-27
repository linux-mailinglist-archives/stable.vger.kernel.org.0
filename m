Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34B629C16C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766643AbgJ0Owb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766480AbgJ0OtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 569BD21556;
        Tue, 27 Oct 2020 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810139;
        bh=9BM9kMAapkeQfx1UEEjUi2sDNYGdZC3u89yTbh5MjBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flawbSnYonydYpJ92h0zNpVI5ECNYRRNPpXis24lCOz1pN2wc85m2H76uBj7UrLFt
         gCe15Zoetg5O0cWTR+5BTobAdC21JU2Gc+mAbha6K6anYHRf6SowjYTz65BPkOpo8F
         r7YHiFcekjpWQncdDQLrHQNjJNj6n1A3c5ulPcOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Ellapu <venkatesh.e@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 034/633] chelsio/chtls: fix panic when server is on ipv6
Date:   Tue, 27 Oct 2020 14:46:17 +0100
Message-Id: <20201027135524.300523514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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


