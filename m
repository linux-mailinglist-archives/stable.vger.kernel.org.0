Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540C629C116
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368511AbgJ0Oy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766449AbgJ0OtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 040A8206E5;
        Tue, 27 Oct 2020 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810142;
        bh=l6PdRIk2q9kQkm+pHSYC9bMdJ4FHIN5XHDF1uNwVZbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHKQBxC5W22PXXrs7Tg4DP0CX1VmVQMjw7oFYkkegEr5WbITIIHzbjJPW0wSqUM/N
         xNVDii/IZlmG6V+TwVwIPQ/sWZSrlhBGgNz/qE/Om+5IzSA0vJoKSYrZhxjKo/EuJ2
         o230SHaGNdL4jatjNT/6KQGQhFebZkVEKGSkTQ9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Venkatesh Ellapu <venkatesh.e@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 035/633] chelsio/chtls: Fix panic when listen on multiadapter
Date:   Tue, 27 Oct 2020 14:46:18 +0100
Message-Id: <20201027135524.343801775@linuxfoundation.org>
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

[ Upstream commit 9819f22c410b4bf6589d3126e8bc3952db507cbf ]

Add the logic to compare net_device returned by ip_dev_find()
with the net_device list in cdev->ports[] array and return
net_device if matched else NULL.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -92,11 +92,13 @@ static void chtls_sock_release(struct kr
 static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
+	struct adapter *adap = pci_get_drvdata(cdev->pdev);
 	struct net_device *ndev = cdev->ports[0];
 #if IS_ENABLED(CONFIG_IPV6)
 	struct net_device *temp;
 	int addr_type;
 #endif
+	int i;
 
 	switch (sk->sk_family) {
 	case PF_INET:
@@ -127,8 +129,12 @@ static struct net_device *chtls_find_net
 		return NULL;
 
 	if (is_vlan_dev(ndev))
-		return vlan_dev_real_dev(ndev);
-	return ndev;
+		ndev = vlan_dev_real_dev(ndev);
+
+	for_each_port(adap, i)
+		if (cdev->ports[i] == ndev)
+			return ndev;
+	return NULL;
 }
 
 static void assign_rxopt(struct sock *sk, unsigned int opt)


