Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074D76ECF14
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjDXNiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjDXNhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77F58A67
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A10A362408
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6638C433EF;
        Mon, 24 Apr 2023 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343437;
        bh=n8doxV9OST131P8XhJtWnO8caIIA21dOX9BAWvugWEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJxYrDhgN0Wr12VYTI9Gkm1/PUOG0upljqQVVxGBiL02k0z0WVGbQlAsjkL3xWYKi
         kNV4XFBBMrFSWOX/kbtEyb3TAC2TMdzpGbdxul0Q5V+0ryx1/8fKWtGKXg5LYwtYJk
         KqI3ueCpsYuAK2oMcwr4jGhMO+vhbIb+benWMfeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH 4.14 24/28] dccp: Call inet6_destroy_sock() via sk->sk_destruct().
Date:   Mon, 24 Apr 2023 15:18:45 +0200
Message-Id: <20230424131122.147065596@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 1651951ebea54970e0bda60c638fc2eee7a6218f upstream.

After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
sk->sk_destruct() by setting inet6_sock_destruct() to it to make
sure we do not leak inet6-specific resources.

DCCP sets its own sk->sk_destruct() in the dccp_init_sock(), and
DCCPv6 socket shares it by calling the same init function via
dccp_v6_init_sock().

To call inet6_sock_destruct() from DCCPv6 sk->sk_destruct(), we
export it and set dccp_v6_sk_destruct() in the init function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dccp/dccp.h     |    1 +
 net/dccp/ipv6.c     |   15 ++++++++-------
 net/dccp/proto.c    |    8 +++++++-
 net/ipv6/af_inet6.c |    1 +
 4 files changed, 17 insertions(+), 8 deletions(-)

--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -291,6 +291,7 @@ int dccp_rcv_state_process(struct sock *
 int dccp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			 const struct dccp_hdr *dh, const unsigned int len);
 
+void dccp_destruct_common(struct sock *sk);
 int dccp_init_sock(struct sock *sk, const __u8 ctl_sock_initialized);
 void dccp_destroy_sock(struct sock *sk);
 
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1000,6 +1000,12 @@ static const struct inet_connection_sock
 #endif
 };
 
+static void dccp_v6_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
+	inet6_sock_destruct(sk);
+}
+
 /* NOTE: A lot of things set to zero explicitly by call to
  *       sk_alloc() so need not be done here.
  */
@@ -1012,17 +1018,12 @@ static int dccp_v6_init_sock(struct sock
 		if (unlikely(!dccp_v6_ctl_sock_initialized))
 			dccp_v6_ctl_sock_initialized = 1;
 		inet_csk(sk)->icsk_af_ops = &dccp_ipv6_af_ops;
+		sk->sk_destruct = dccp_v6_sk_destruct;
 	}
 
 	return err;
 }
 
-static void dccp_v6_destroy_sock(struct sock *sk)
-{
-	dccp_destroy_sock(sk);
-	inet6_destroy_sock(sk);
-}
-
 static struct timewait_sock_ops dccp6_timewait_sock_ops = {
 	.twsk_obj_size	= sizeof(struct dccp6_timewait_sock),
 };
@@ -1045,7 +1046,7 @@ static struct proto dccp_v6_prot = {
 	.accept		   = inet_csk_accept,
 	.get_port	   = inet_csk_get_port,
 	.shutdown	   = dccp_shutdown,
-	.destroy	   = dccp_v6_destroy_sock,
+	.destroy	   = dccp_destroy_sock,
 	.orphan_count	   = &dccp_orphan_count,
 	.max_header	   = MAX_DCCP_HEADER,
 	.obj_size	   = sizeof(struct dccp6_sock),
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -171,12 +171,18 @@ const char *dccp_packet_name(const int t
 
 EXPORT_SYMBOL_GPL(dccp_packet_name);
 
-static void dccp_sk_destruct(struct sock *sk)
+void dccp_destruct_common(struct sock *sk)
 {
 	struct dccp_sock *dp = dccp_sk(sk);
 
 	ccid_hc_tx_delete(dp->dccps_hc_tx_ccid, sk);
 	dp->dccps_hc_tx_ccid = NULL;
+}
+EXPORT_SYMBOL_GPL(dccp_destruct_common);
+
+static void dccp_sk_destruct(struct sock *sk)
+{
+	dccp_destruct_common(sk);
 	inet_sock_destruct(sk);
 }
 
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -112,6 +112,7 @@ void inet6_sock_destruct(struct sock *sk
 	inet6_cleanup_sock(sk);
 	inet_sock_destruct(sk);
 }
+EXPORT_SYMBOL_GPL(inet6_sock_destruct);
 
 static int inet6_create(struct net *net, struct socket *sock, int protocol,
 			int kern)


