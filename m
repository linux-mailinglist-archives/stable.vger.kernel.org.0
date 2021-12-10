Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA12646FEF1
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 11:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbhLJKvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 05:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbhLJKvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 05:51:20 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17987C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:45 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u1so14123599wru.13
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwRUFepWXi4yJWOEtvYtgfLkIyBFIXrHo8LOGwyevxA=;
        b=DJ0AdWDZ2SFmtQ/om7dAQ0c1LnejGkXH2eLsmKU8zZz7iCnAe+qrGbHsM5WUuwQ1J+
         fkbwgoIFVPn4rGPrY5WnOYXrknKa4aOnj0pPlaRiMr8cj8k1iZnvC5Az9xM4WpSD5Xog
         NgTULACjVAcOnHWvAIdwZiQ9TXkyawJoBQaLsh4S/RrDk7DEiuJ3OEFqVMNYl0ihC7wu
         3maMvzrhRTxJ+p61s+0SixPmER9J3tE+wv2xrjpLmGifmnSqWv0sBeWR9PfFWkvLEdLK
         5UhVLLfydZJkWZBEYDL6gm1M80bci0T0xg69ItTsrf0cVgjPmpCI9I6pl5VTq1TDp8J2
         ejsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BwRUFepWXi4yJWOEtvYtgfLkIyBFIXrHo8LOGwyevxA=;
        b=bYig0W2mWy1CCsp/+bp83WS6NDdprB+HFfxXE7GGE1zZ6ffxLYmg0P0Paas9lpRudk
         eJe0XPNQsGNF0jpML/pwTMmCjZWOUNv6tvlhlBdv8SP6uaX+icn5C4RpYdMo+HA/z+2v
         GV0G1u7GbHriIsooCz5o1codlH6zt++92qWFxy8DOVgUspQbOaCSunsnOvkEwS7F43lm
         6zXZVzBfwSpK43wPm3/iXDUkPRxZwPKT5EEEGqvYCUlUu3mScuenEDf0DTOpGf3UliDM
         QDDpjH2sVLg5RzTBVv8lCWhYMfVLI3Zez9LogZPLY3UKuzGvj24DvXhC5+20n+VaYiqs
         nSZA==
X-Gm-Message-State: AOAM531tAA+K5CVtoVZ9Io71dy/vTEeQCDYOwOEXSSOBfZ2gUwVrU2/A
        btgGPqlnL5cBcG1QtVP9wvhaIbo1NjAjfg==
X-Google-Smtp-Source: ABdhPJzzX7aa7ijPAbPbU0JUlmX++0ulmf1FuF0RMyQ1FKtUExECjKsj6el07Lj7twz+hcQ+aGcetQ==
X-Received: by 2002:adf:82d3:: with SMTP id 77mr12987477wrc.377.1639133263598;
        Fri, 10 Dec 2021 02:47:43 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id m3sm2159507wrv.95.2021.12.10.02.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:47:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19.y 1/5] net: core: netlink: add helper refcount dec and lock function
Date:   Fri, 10 Dec 2021 10:47:25 +0000
Message-Id: <20211210104729.582403-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
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
---
 include/linux/rtnetlink.h | 2 ++
 net/core/rtnetlink.c      | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 5225832bd6ff1..9cdd76348d9ab 100644
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
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 83de32e34bb55..907dd0c7e8a66 100644
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
-- 
2.34.1.173.g76aa8bc2d0-goog

