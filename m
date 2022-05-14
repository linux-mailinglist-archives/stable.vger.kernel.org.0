Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA09526F4E
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiENFfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiENFfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61B225D1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id g12-20020a170902740c00b0015d243ff163so5340249pll.19
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TvbCzBBvo15VRUBc/6ak0d8mhY7uSzRxncOCYNG60n0=;
        b=ZpWwbDbP+X/DGCnmKcpKBBG8A2iqIMkb+/b77fjL9BDepkrB0solslY09hbxB0GCcS
         l0L/WqwjZwadXUkpgOSq4mS+msQt49jzK5I+BZWpHvCxpqW+cd5nY3ogCaSedG9XdB7P
         9jbjTzXGh89CpFKJq2m9RH9Hnfa97ucAtz1O6TZJrUHZ+KpNQeLIu8bm8uCrbx/d7wJL
         j8/omK0M2mx4fBi9nmMwHUcev+5HFoYt4BepuErKq3QJU1MEeFQzDZL7MY2fxOwjOWvp
         NvIxzi3BzxXWbYR/ILR2IzOdwOaUZg5VUWpw/ZEoRBIMHpnBtduEbEA+7eQxA7axayyz
         toVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TvbCzBBvo15VRUBc/6ak0d8mhY7uSzRxncOCYNG60n0=;
        b=K7pNkicuNjDfk+SC+xzXdQ37FsAekNWk6wGsUrKEXg5SDyL4G2AwlcQNUF765xCrs0
         NvvVlNVpi21jTbHbyCrZlOcsWrNM6N6niYqQtTOObwAa93GMVVm+mHORTr2/6fcjvr+v
         Qv+5rhBpC0SdNjSDAPEYSIm0XuInJ0/a4m6OAEmGRckKS8LGdmJ7pJaXBq164O2tFPKU
         Pz7JIjF3d2WO14RyrdraWqAQmQrtJeMufKVsZNfHCLaXGL5n+zR4GD1p1iBlSIU8SUWF
         yTuI7ZaajguHal4CJ/yn0RJpqwNjAewAIlJbtcwxgzxAxvUZnU36anLFfo7KUBuxCGw2
         EGXw==
X-Gm-Message-State: AOAM5329zh/8e4DRHZh4f4TD+Mz02RhEXOamWCuPVxt2oCoqD2jUBHbF
        oc4BA7dklGSSmJhLE5lypK7NjsVzBR6Jyafj+GWsOA==
X-Google-Smtp-Source: ABdhPJxV98s95KfUzPC/9JuwlR6rmZrr+YcMUKdvkxX0r0g/PpFeNz0xoasNWYCBcK/LDrrbjrfPYG03evZPpw6yZsx+OQ==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with
 SMTP id c16-20020a056a000ad000b004e12d962ab0mr7741746pfl.3.1652506507386;
 Fri, 13 May 2022 22:35:07 -0700 (PDT)
Date:   Sat, 14 May 2022 05:34:50 +0000
In-Reply-To: <20220514053453.3277330-1-meenashanmugam@google.com>
Message-Id: <20220514053453.3277330-2-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com> <20220514053453.3277330-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 1/4] SUNRPC: Clean up scheduling of autoclose
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     enrico.scholz@sigma-chemnitz.de, meenashanmugam@google.com,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e26d9972720e2484f44cdd94ca4e31cc372ed2ed upstream.

Consolidate duplicated code in xprt_force_disconnect() and
xprt_conditional_disconnect().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/sunrpc/xprt.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 6bc225d64d23..a6bb957084f7 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -731,6 +731,20 @@ void xprt_disconnect_done(struct rpc_xprt *xprt)
 }
 EXPORT_SYMBOL_GPL(xprt_disconnect_done);
 
+/**
+ * xprt_schedule_autoclose_locked - Try to schedule an autoclose RPC call
+ * @xprt: transport to disconnect
+ */
+static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
+{
+	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
+		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
+	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
+		rpc_wake_up_queued_task_set_status(&xprt->pending,
+						   xprt->snd_task, -ENOTCONN);
+}
+
 /**
  * xprt_force_disconnect - force a transport to disconnect
  * @xprt: transport to disconnect
@@ -742,13 +756,7 @@ void xprt_force_disconnect(struct rpc_xprt *xprt)
 
 	/* Don't race with the test_bit() in xprt_clear_locked() */
 	spin_lock(&xprt->transport_lock);
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
-	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
-		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
-		rpc_wake_up_queued_task_set_status(&xprt->pending,
-						   xprt->snd_task, -ENOTCONN);
+	xprt_schedule_autoclose_locked(xprt);
 	spin_unlock(&xprt->transport_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_force_disconnect);
@@ -788,11 +796,7 @@ void xprt_conditional_disconnect(struct rpc_xprt *xprt, unsigned int cookie)
 		goto out;
 	if (test_bit(XPRT_CLOSING, &xprt->state))
 		goto out;
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
-	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
-		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	xprt_wake_pending_tasks(xprt, -EAGAIN);
+	xprt_schedule_autoclose_locked(xprt);
 out:
 	spin_unlock(&xprt->transport_lock);
 }
-- 
2.36.0.550.gb090851708-goog

