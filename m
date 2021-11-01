Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1419E441875
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhKAJrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhKAJpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BCD61220;
        Mon,  1 Nov 2021 09:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759010;
        bh=EJeA18QhPeJb4Gw47p0XCcIvBZ1ofkDlpGZQZV00N/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvvSJbWYxWRZ+kaovWNzMi7PZhbTslqrf5MeqW32PIK0vR/Mi73PjAXuzIHUx/FiY
         1EAy1ZjLFhIIEbEZHZv1/B/K9SgrXpi3MCCydbOLdvyh5zB9KKiTroAIugCF7eujX3
         Hml7r5NA8+fIrehjVSiIF7V6ufbFREJGli/j0W1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 077/125] net-sysfs: initialize uid and gid before calling net_ns_get_ownership
Date:   Mon,  1 Nov 2021 10:17:30 +0100
Message-Id: <20211101082547.817430627@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit f7a1e76d0f608961cc2fc681f867a834f2746bce upstream.

Currently in net_ns_get_ownership() it may not be able to set uid or gid
if make_kuid or make_kgid returns an invalid value, and an uninit-value
issue can be triggered by this.

This patch is to fix it by initializing the uid and gid before calling
net_ns_get_ownership(), as it does in kobject_get_ownership()

Fixes: e6dee9f3893c ("net-sysfs: add netdev_change_owner()")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1973,9 +1973,9 @@ int netdev_register_kobject(struct net_d
 int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
 			const struct net *net_new)
 {
+	kuid_t old_uid = GLOBAL_ROOT_UID, new_uid = GLOBAL_ROOT_UID;
+	kgid_t old_gid = GLOBAL_ROOT_GID, new_gid = GLOBAL_ROOT_GID;
 	struct device *dev = &ndev->dev;
-	kuid_t old_uid, new_uid;
-	kgid_t old_gid, new_gid;
 	int error;
 
 	net_ns_get_ownership(net_old, &old_uid, &old_gid);


