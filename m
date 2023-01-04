Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A731165D833
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbjADQMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbjADQL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:11:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED1F6327
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A21661785
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F254FC433F0;
        Wed,  4 Jan 2023 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848689;
        bh=d6OhcyYazqXyzw+qHsFSWFxAiQjtxXvb0Gx7abt1C5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QK8RI6T5v84qs/TOam7nTZyLMTMfBT21srKLfaiI1j9uqA28d+STsGZXwf2qCpXB9
         kdHOBIFEGIygxTX+rAhZe+W6m/84CBJsRIX+pQSk+mCbIi4FKllYeTyiq+zgjIaoKx
         xCRePZXGymspNDgiqpKMCYY5VgEjsh+0JV/fgRaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 065/207] mptcp: use proper req destructor for IPv6
Date:   Wed,  4 Jan 2023 17:05:23 +0100
Message-Id: <20230104160513.981654833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit d3295fee3c756ece33ac0d935e172e68c0a4161b upstream.

Before, only the destructor from TCP request sock in IPv4 was called
even if the subflow was IPv6.

It is important to use the right destructor to avoid memory leaks with
some advanced IPv6 features, e.g. when the request socks contain
specific IPv6 options.

Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -45,7 +45,6 @@ static void subflow_req_destructor(struc
 		sock_put((struct sock *)subflow_req->msk);
 
 	mptcp_token_destroy_request(req);
-	tcp_request_sock_ops.destructor(req);
 }
 
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
@@ -550,6 +549,12 @@ drop:
 	return 0;
 }
 
+static void subflow_v4_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp_request_sock_ops.destructor(req);
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
@@ -581,6 +586,12 @@ drop:
 	tcp_listendrop(sk);
 	return 0; /* don't send reset */
 }
+
+static void subflow_v6_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp6_request_sock_ops.destructor(req);
+}
 #endif
 
 struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
@@ -1929,8 +1940,6 @@ static int subflow_ops_init(struct reque
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
-	subflow_ops->destructor = subflow_req_destructor;
-
 	return 0;
 }
 
@@ -1938,6 +1947,8 @@ void __init mptcp_subflow_init(void)
 {
 	mptcp_subflow_v4_request_sock_ops = tcp_request_sock_ops;
 	mptcp_subflow_v4_request_sock_ops.slab_name = "request_sock_subflow_v4";
+	mptcp_subflow_v4_request_sock_ops.destructor = subflow_v4_req_destructor;
+
 	if (subflow_ops_init(&mptcp_subflow_v4_request_sock_ops) != 0)
 		panic("MPTCP: failed to init subflow v4 request sock ops\n");
 
@@ -1963,6 +1974,8 @@ void __init mptcp_subflow_init(void)
 
 	mptcp_subflow_v6_request_sock_ops = tcp6_request_sock_ops;
 	mptcp_subflow_v6_request_sock_ops.slab_name = "request_sock_subflow_v6";
+	mptcp_subflow_v6_request_sock_ops.destructor = subflow_v6_req_destructor;
+
 	if (subflow_ops_init(&mptcp_subflow_v6_request_sock_ops) != 0)
 		panic("MPTCP: failed to init subflow v6 request sock ops\n");
 


