Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02852F7A38
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733029AbhAOMrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388026AbhAOMhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC9A221FA;
        Fri, 15 Jan 2021 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714244;
        bh=5JbJHYFAk1BTNHTKPNGGzIAMov3p9Xv2pQrrQ257lVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkfMrtBrPoUnCHm6LRGbQSd/m9mKk3hA8cFBqDv5QRnBegZ7amtPwrFQBo1ZkGz01
         blBdL8afMJ5NFMRkWpXZQ8+b08IBAo/GF8YmVjLPysNpakRrGRT4vz/D4Hbxitv6KF
         Fl4iJ+ushZF73fmvWmGBKuy6Tz3SL3dEGR1/SmSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 031/103] chtls: Fix panic when route to peer not configured
Date:   Fri, 15 Jan 2021 13:27:24 +0100
Message-Id: <20210115122007.565120904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 5a5fac9966bb6d513198634b0b1357be7e8447d2 ]

If route to peer is not configured, we might get non tls
devices from dst_neigh_lookup() which is invalid, adding a
check to avoid it.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |   14 ++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1109,6 +1109,7 @@ static struct sock *chtls_recv_sock(stru
 				    const struct cpl_pass_accept_req *req,
 				    struct chtls_dev *cdev)
 {
+	struct adapter *adap = pci_get_drvdata(cdev->pdev);
 	struct neighbour *n = NULL;
 	struct inet_sock *newinet;
 	const struct iphdr *iph;
@@ -1118,9 +1119,10 @@ static struct sock *chtls_recv_sock(stru
 	struct dst_entry *dst;
 	struct tcp_sock *tp;
 	struct sock *newsk;
+	bool found = false;
 	u16 port_id;
 	int rxq_idx;
-	int step;
+	int step, i;
 
 	iph = (const struct iphdr *)network_hdr;
 	newsk = tcp_create_openreq_child(lsk, oreq, cdev->askb);
@@ -1152,7 +1154,7 @@ static struct sock *chtls_recv_sock(stru
 		n = dst_neigh_lookup(dst, &ip6h->saddr);
 #endif
 	}
-	if (!n)
+	if (!n || !n->dev)
 		goto free_sk;
 
 	ndev = n->dev;
@@ -1161,6 +1163,13 @@ static struct sock *chtls_recv_sock(stru
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
+	for_each_port(adap, i)
+		if (cdev->ports[i] == ndev)
+			found = true;
+
+	if (!found)
+		goto free_dst;
+
 	port_id = cxgb4_port_idx(ndev);
 
 	csk = chtls_sock_create(cdev);
@@ -1237,6 +1246,7 @@ static struct sock *chtls_recv_sock(stru
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
+	neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);


