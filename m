Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABFA526F52
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiENFfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiENFfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B510C0
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:10 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x190-20020a6386c7000000b003d82199c4fdso5154779pgd.16
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pQ3/2wWEXIEp31+Th9Fv52M8A6U+DB7IXsH9VispyAE=;
        b=h2zwPrO7yfmI1kLWQ5G5Rag/gvBZcgWFfRt1yjeRbZb+u5Y73AWdHkSIEp8e7EnMcL
         djfq63gEE6tWA2qKh7VYuYLgZFy+Dy4MIkxBl3g4IYgJDUK9slcuaceUeSpf6Eb1hwGz
         Rdvo9JtcXbEjltanGIfIWdnjgiwYrlIsosoHgDKBM1GL2iHiUwuyYNEydNmcRdzsYAFb
         7qa9XcVhFqjr34W0H9wU2BAik2/Rf9tfIOpVXY6nnzdfR/cxb1eJDXERpo3S8pt2nKfJ
         CwJAvzNsCBfP9kJHc3rQj6I/ACdbxZewiJu2gwOERg2g72p5hXdLrrgmdsI76fWP7oqk
         vTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pQ3/2wWEXIEp31+Th9Fv52M8A6U+DB7IXsH9VispyAE=;
        b=JZiG4e5rYCmPB8ZtDBWTadWqOimj0uGoiTUkNqcTatsI9tjpCv3SZNHZtJdcDPJlSA
         4reROiUrGnqwppbtEig+kFJsyt+0aB+SIpqJw4qWpQNe9SAIa5rCG2iabN5Xr/zkH3Zg
         KQSKZp/A66TrYcbwTCOHFFwncjZfFThAq6oRlumzlvW6EyrXkw4snc1yxt2LQ7Rj+SVt
         mhUg//AIdLn9Ol8c1yjxjO15f/fLdg34WU0fKVlGQBqgjAOTTv5wSLbAMJSaWvwwvctF
         LFapa7vcumBElaTCgw6R5fhVwHDRd/rOo1bra7Hjrl0wjuIpm05hP+TI3n1upwR/vG9j
         QfBA==
X-Gm-Message-State: AOAM533EbEN8Q/uiRk2SawmzI9wP3ZMscUhEQZ5Y3u4MSoQFwzz2u3mN
        EpFyr0EJbhZyk1KuxjDf2h/IXITEzcEsxXfuati47Q==
X-Google-Smtp-Source: ABdhPJyVXMDFbSACO7sLYmDqCGSLYkzNYvDmhZfuP332EuIl8LYPHLxwM5EGIXrEXhQu7SriApCZsCLGkEY5+e5t7XrT5g==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:90a:e7d2:b0:1dc:e6c6:604b with
 SMTP id kb18-20020a17090ae7d200b001dce6c6604bmr19616414pjb.183.1652506510368;
 Fri, 13 May 2022 22:35:10 -0700 (PDT)
Date:   Sat, 14 May 2022 05:34:51 +0000
In-Reply-To: <20220514053453.3277330-1-meenashanmugam@google.com>
Message-Id: <20220514053453.3277330-3-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com> <20220514053453.3277330-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 2/4] SUNRPC: Prevent immediate close+reconnect
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     enrico.scholz@sigma-chemnitz.de, meenashanmugam@google.com,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com
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

commit 3be232f11a3cc9b0ef0795e39fa11bdb8e422a06 upstream.

If we have already set up the socket and are waiting for it to connect,
then don't immediately close and retry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 net/sunrpc/xprt.c     | 3 ++-
 net/sunrpc/xprtsock.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index a6bb957084f7..af0159459c75 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -737,7 +737,8 @@ EXPORT_SYMBOL_GPL(xprt_disconnect_done);
  */
 static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_CLOSE_WAIT, &xprt->state))
+		return;
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index bd123f1d0923..60c58eb9a456 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2345,7 +2345,7 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL) {
+	if (transport->sock != NULL && !xprt_connecting(xprt)) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
 				"seconds\n",
 				xprt, xprt->reestablish_timeout / HZ);
-- 
2.36.0.550.gb090851708-goog

