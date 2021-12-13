Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC4472541
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhLMJnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbhLMJk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12966C07E5F2;
        Mon, 13 Dec 2021 01:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B268DB80E20;
        Mon, 13 Dec 2021 09:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07094C341C5;
        Mon, 13 Dec 2021 09:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388323;
        bh=RV0sIzQUzGAprjecvzayc1JtvqHJ8V6C/e+CUN1OEgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEw98BIMqim7ofDE7WUbUSR5qZz9NVDhyAJXbe91Mqp7/1VyE51G9HYngTbranhmU
         V05Bg+B+p+2rqWada97gUzZ1N0RQYY59wrI7KGzqRLuw1dJRDZI1o9Iv9yP6qrKylv
         qt3Fv3Eml5vzGaRwf5TBubx/HclOdz6kBNAAt9Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 10/74] net: core: netlink: add helper refcount dec and lock function
Date:   Mon, 13 Dec 2021 10:29:41 +0100
Message-Id: <20211213092931.123743352@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 6f99528e9797794b91b43321fbbc93fe772b0803 ]

Rtnl lock is encapsulated in netlink and cannot be accessed by other
modules directly. This means that reference counted objects that rely on
rtnl lock cannot use it with refcounter helper function that atomically
releases decrements reference and obtains mutex.

This patch implements simple wrapper function around refcount_dec_and_lock
that obtains rtnl lock if reference counter value reached 0.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rtnetlink.h |    2 ++
 net/core/rtnetlink.c      |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -6,6 +6,7 @@
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/wait.h>
+#include <linux/refcount.h>
 #include <uapi/linux/rtnetlink.h>
 
 extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
@@ -34,6 +35,7 @@ extern void rtnl_unlock(void);
 extern int rtnl_trylock(void);
 extern int rtnl_is_locked(void);
 extern int rtnl_lock_killable(void);
+extern bool refcount_dec_and_rtnl_lock(refcount_t *r);
 
 extern wait_queue_head_t netdev_unregistering_wq;
 extern struct rw_semaphore pernet_ops_rwsem;
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -130,6 +130,12 @@ int rtnl_is_locked(void)
 }
 EXPORT_SYMBOL(rtnl_is_locked);
 
+bool refcount_dec_and_rtnl_lock(refcount_t *r)
+{
+	return refcount_dec_and_mutex_lock(r, &rtnl_mutex);
+}
+EXPORT_SYMBOL(refcount_dec_and_rtnl_lock);
+
 #ifdef CONFIG_PROVE_LOCKING
 bool lockdep_rtnl_is_held(void)
 {


