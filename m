Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF50B664B58
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbjAJSm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbjAJSli (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AFB5EC3B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:35:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3E87B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2123CC433D2;
        Tue, 10 Jan 2023 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375721;
        bh=aSxKSlixLICdXBcetFSU0kxKNuQhscK+NN3eLJVHMME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIt6wJmOzyfG9ZgnMI5vaP+FBulRYgLRhF37po0RvJEKy5L0139BSHBHFSJhCEKD6
         o8ljwr/aQktprC/hWNX2CC8hih/AQgt0ZEV1v4iP8b60MGLwl2WoozHBvqZ/L7jTUN
         WOR78hcEsiL+i4BdgsmogRKBtI+SbdBo9nBYcGpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 281/290] mptcp: dedicated request sock for subflow in v6
Date:   Tue, 10 Jan 2023 19:06:13 +0100
Message-Id: <20230110180041.609122124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

commit 34b21d1ddc8ace77a8fa35c1b1e06377209e0dae upstream.

tcp_request_sock_ops structure is specific to IPv4. It should then not
be used with MPTCP subflows on top of IPv6.

For example, it contains the 'family' field, initialised to AF_INET.
This 'family' field is used by TCP FastOpen code to generate the cookie
but also by TCP Metrics, SELinux and SYN Cookies. Using the wrong family
will not lead to crashes but displaying/using/checking wrong things.

Note that 'send_reset' callback from request_sock_ops structure is used
in some error paths. It is then also important to use the correct one
for IPv4 or IPv6.

The slab name can also be different in IPv4 and IPv6, it will be used
when printing some log messages. The slab pointer will anyway be the
same because the object size is the same for both v4 and v6. A
BUILD_BUG_ON() has also been added to make sure this size is the same.

Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -483,7 +483,7 @@ do_reset:
 	mptcp_subflow_reset(sk);
 }
 
-static struct request_sock_ops mptcp_subflow_request_sock_ops __ro_after_init;
+static struct request_sock_ops mptcp_subflow_v4_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -496,7 +496,7 @@ static int subflow_v4_conn_request(struc
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v4_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -505,6 +505,7 @@ drop:
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
@@ -527,7 +528,7 @@ static int subflow_v6_conn_request(struc
 		return 0;
 	}
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v6_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
@@ -540,7 +541,12 @@ struct request_sock *mptcp_subflow_reqsk
 					       struct sock *sk_listener,
 					       bool attach_listener)
 {
-	ops = &mptcp_subflow_request_sock_ops;
+	if (ops->family == AF_INET)
+		ops = &mptcp_subflow_v4_request_sock_ops;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (ops->family == AF_INET6)
+		ops = &mptcp_subflow_v6_request_sock_ops;
+#endif
 
 	return inet_reqsk_alloc(ops, sk_listener, attach_listener);
 }
@@ -1791,7 +1797,6 @@ static struct tcp_ulp_ops subflow_ulp_op
 static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 {
 	subflow_ops->obj_size = sizeof(struct mptcp_subflow_request_sock);
-	subflow_ops->slab_name = "request_sock_subflow";
 
 	subflow_ops->slab = kmem_cache_create(subflow_ops->slab_name,
 					      subflow_ops->obj_size, 0,
@@ -1808,9 +1813,10 @@ static int subflow_ops_init(struct reque
 
 void __init mptcp_subflow_init(void)
 {
-	mptcp_subflow_request_sock_ops = tcp_request_sock_ops;
-	if (subflow_ops_init(&mptcp_subflow_request_sock_ops) != 0)
-		panic("MPTCP: failed to init subflow request sock ops\n");
+	mptcp_subflow_v4_request_sock_ops = tcp_request_sock_ops;
+	mptcp_subflow_v4_request_sock_ops.slab_name = "request_sock_subflow_v4";
+	if (subflow_ops_init(&mptcp_subflow_v4_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v4 request sock ops\n");
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
 	subflow_request_sock_ipv4_ops.route_req = subflow_v4_route_req;
@@ -1824,6 +1830,18 @@ void __init mptcp_subflow_init(void)
 	tcp_prot_override.release_cb = tcp_release_cb_override;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
+	 * structures for v4 and v6 have the same size. It should not changed in
+	 * the future but better to make sure to be warned if it is no longer
+	 * the case.
+	 */
+	BUILD_BUG_ON(sizeof(struct tcp_request_sock) != sizeof(struct tcp6_request_sock));
+
+	mptcp_subflow_v6_request_sock_ops = tcp6_request_sock_ops;
+	mptcp_subflow_v6_request_sock_ops.slab_name = "request_sock_subflow_v6";
+	if (subflow_ops_init(&mptcp_subflow_v6_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v6 request sock ops\n");
+
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
 	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
 


