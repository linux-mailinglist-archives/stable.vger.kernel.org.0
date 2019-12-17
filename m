Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A20F1236F3
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfLQURQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbfLQURP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:17:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B4021D7D;
        Tue, 17 Dec 2019 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613835;
        bh=eSnrJ3ULyj/dIp5UshGbVzKSGuZxeQBMGCY5ozG3p0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnzdojYF3IPphkWlxtjfsqRtWQU9lkiKJtG/LsbGpezBacaLtJfc1vTW6UCEWaJLC
         fWC99UhmpDMnZwc1+dG8ubGoyR6gsCfO2StjzHyDQfDB1pueqlBc89HALHEHk0l3dv
         ZVxqqbTlwd44nalfFygUXYJDyKrEXgA5kGm4/ME4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 25/25] xdp: obtain the mem_id mutex before trying to remove an entry.
Date:   Tue, 17 Dec 2019 21:16:24 +0100
Message-Id: <20191217200913.325570261@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 86c76c09898332143be365c702cf8d586ed4ed21 ]

A lockdep splat was observed when trying to remove an xdp memory
model from the table since the mutex was obtained when trying to
remove the entry, but not before the table walk started:

Fix the splat by obtaining the lock before starting the table walk.

Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/xdp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -85,12 +85,8 @@ static void mem_xa_remove(struct xdp_mem
 {
 	trace_mem_disconnect(xa);
 
-	mutex_lock(&mem_id_lock);
-
 	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
-
-	mutex_unlock(&mem_id_lock);
 }
 
 static void mem_allocator_disconnect(void *allocator)
@@ -98,6 +94,8 @@ static void mem_allocator_disconnect(voi
 	struct xdp_mem_allocator *xa;
 	struct rhashtable_iter iter;
 
+	mutex_lock(&mem_id_lock);
+
 	rhashtable_walk_enter(mem_id_ht, &iter);
 	do {
 		rhashtable_walk_start(&iter);
@@ -111,6 +109,8 @@ static void mem_allocator_disconnect(voi
 
 	} while (xa == ERR_PTR(-EAGAIN));
 	rhashtable_walk_exit(&iter);
+
+	mutex_unlock(&mem_id_lock);
 }
 
 static void mem_id_disconnect(int id)


