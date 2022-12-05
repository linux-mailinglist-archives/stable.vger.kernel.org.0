Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5C64320F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiLETYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiLETXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:23:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB472A97A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A40ACE13A6
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E72C433D6;
        Mon,  5 Dec 2022 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267927;
        bh=jI84Pf+JECb3rH7o0BWyi5voV/0z+h+vV0EsZMh+aek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOKaJea9DRyXpSHbKKE2HOCJwM7pJ1KBaAdKSxaXnCEMfKlSNGyCxzBim3WnCTtep
         gkeOED7hg95qEgrBd69WPKO0eX8SEt9bLacWMG9RTpMdqJho6Q+NpUWk7vLs+0wQB9
         1oGVc23AZFkPBKOm3TC/Naa26TB4WlDOAvuCyRRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/105] tipc: add an extra conn_get in tipc_conn_alloc
Date:   Mon,  5 Dec 2022 20:08:56 +0100
Message-Id: <20221205190803.963395918@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a7b42969d63f47320853a802efd879fbdc4e010e ]

One extra conn_get() is needed in tipc_conn_alloc(), as after
tipc_conn_alloc() is called, tipc_conn_close() may free this
con before deferencing it in tipc_topsrv_accept():

   tipc_conn_alloc();
   newsk = newsock->sk;
                                 <---- tipc_conn_close();
   write_lock_bh(&sk->sk_callback_lock);
   newsk->sk_data_ready = tipc_conn_data_ready;

Then an uaf issue can be triggered:

  BUG: KASAN: use-after-free in tipc_topsrv_accept+0x1e7/0x370 [tipc]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   print_report+0x178/0x4b0
   kasan_report+0x8c/0x100
   kasan_check_range+0x179/0x1e0
   tipc_topsrv_accept+0x1e7/0x370 [tipc]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by holding it in tipc_conn_alloc(), then after
all accessing in tipc_topsrv_accept() releasing it. Note when does
this in tipc_topsrv_kern_subscr(), as tipc_conn_rcv_sub() returns
0 or -1 only, we don't need to check for "> 0".

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 8ac27bd786f3..d3bb19cd0ec0 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -214,6 +214,7 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *s
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
 	con->sock = sock;
+	conn_get(con);
 	spin_unlock_bh(&s->idr_lock);
 
 	return con;
@@ -491,6 +492,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 
 		/* Wake up receive process in case of 'SYN+' message */
 		newsk->sk_data_ready(newsk);
+		conn_put(con);
 	}
 }
 
@@ -590,10 +592,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 
 	*conid = con->conid;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
-	if (rc >= 0)
-		return true;
+	if (rc)
+		conn_put(con);
+
 	conn_put(con);
-	return false;
+	return !rc;
 }
 
 void tipc_topsrv_kern_unsubscr(struct net *net, int conid)
-- 
2.35.1



