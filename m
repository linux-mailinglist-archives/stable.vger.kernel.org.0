Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2C465D46C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbjADNh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbjADNgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:36:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0F2373A6
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:34:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA13B815EB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E98C433EF;
        Wed,  4 Jan 2023 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672839286;
        bh=eeWBvhuSVRd5GJiGlOa23hxyQrK0QbSQb3wemDbl6FE=;
        h=Subject:To:Cc:From:Date:From;
        b=YNEA0RXsEq1j5AhEUgWCc7NzQajyhltpSxTqg+xQyxDkhZQPu8v1OICyhqLI9+l7G
         WX+QJYVgvRf8N2EWnQAOgm8cgyHA5icqzv18q0j5WLg1Ts+3argIQruuo3mdfEl+fG
         iXiuXKMUffpejglGSNiych1U42eZaJ3ILq6BXohk=
Subject: FAILED: patch "[PATCH] mptcp: dedicated request sock for subflow in v6" failed to apply to 5.15-stable tree
To:     matthieu.baerts@tessares.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:34:43 +0100
Message-ID: <16728392834890@kroah.com>
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

34b21d1ddc8a ("mptcp: dedicated request sock for subflow in v6")
3fff88186f04 ("mptcp: remove MPTCP 'ifdef' in TCP SYN cookies")
4cf86ae84c71 ("mptcp: strict local address ID selection")
51fa7f8ebf0e ("mptcp: mark ops structures as ro_after_init")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 34b21d1ddc8ace77a8fa35c1b1e06377209e0dae Mon Sep 17 00:00:00 2001
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Fri, 9 Dec 2022 16:28:09 -0800
Subject: [PATCH] mptcp: dedicated request sock for subflow in v6

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

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3f670f2d5c5c..30524dd7d0ec 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -529,7 +529,7 @@ static int subflow_v6_rebuild_header(struct sock *sk)
 }
 #endif
 
-static struct request_sock_ops mptcp_subflow_request_sock_ops __ro_after_init;
+static struct request_sock_ops mptcp_subflow_v4_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -542,7 +542,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v4_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -551,6 +551,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
@@ -573,7 +574,7 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v6_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
@@ -586,7 +587,12 @@ struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *op
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
@@ -1914,7 +1920,6 @@ static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 {
 	subflow_ops->obj_size = sizeof(struct mptcp_subflow_request_sock);
-	subflow_ops->slab_name = "request_sock_subflow";
 
 	subflow_ops->slab = kmem_cache_create(subflow_ops->slab_name,
 					      subflow_ops->obj_size, 0,
@@ -1931,9 +1936,10 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 
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
@@ -1948,6 +1954,18 @@ void __init mptcp_subflow_init(void)
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
 

