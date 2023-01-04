Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2744E65D465
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjADNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239568AbjADNgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:36:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718503AF1B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CDA5B8163A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B714C433EF;
        Wed,  4 Jan 2023 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672839299;
        bh=3PeMlppV0QzZPDusyAkehKYbxFy7Pc8O0tLSIk4cmTI=;
        h=Subject:To:Cc:From:Date:From;
        b=gMSB9q75IdbZL8/AwyGz1YKTtJU0NBmYten1Pf9Y0bbXo2GVrpq5VGeGe5yVl3AFg
         JKm1xWLRI4LFWgZNUu1C0fnHzIGSUrUSmWwx2g22cXyeumNs+/ZTcVziV36T6fQRV4
         mcDXlkQEB4XqeLEHDueQt7LmeMcTBdSqIQHPQmQ4=
Subject: FAILED: patch "[PATCH] mptcp: use proper req destructor for IPv6" failed to apply to 5.15-stable tree
To:     matthieu.baerts@tessares.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:34:56 +0100
Message-ID: <167283929624480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d3295fee3c75 ("mptcp: use proper req destructor for IPv6")
34b21d1ddc8a ("mptcp: dedicated request sock for subflow in v6")
3fff88186f04 ("mptcp: remove MPTCP 'ifdef' in TCP SYN cookies")
4cf86ae84c71 ("mptcp: strict local address ID selection")
51fa7f8ebf0e ("mptcp: mark ops structures as ro_after_init")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3295fee3c756ece33ac0d935e172e68c0a4161b Mon Sep 17 00:00:00 2001
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Fri, 9 Dec 2022 16:28:10 -0800
Subject: [PATCH] mptcp: use proper req destructor for IPv6

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

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 30524dd7d0ec..613f515fedf0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -45,7 +45,6 @@ static void subflow_req_destructor(struct request_sock *req)
 		sock_put((struct sock *)subflow_req->msk);
 
 	mptcp_token_destroy_request(req);
-	tcp_request_sock_ops.destructor(req);
 }
 
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
@@ -550,6 +549,12 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
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
@@ -581,6 +586,12 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
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
@@ -1929,8 +1940,6 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
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
 

