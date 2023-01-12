Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1545A66781D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbjALOws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbjALOw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:52:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE875584F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3F05B81E31
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA877C433EF;
        Thu, 12 Jan 2023 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534349;
        bh=/9bzqYjS9gG3rAp406bt9ABO0Y24TNNEsPjnhM3WPxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c04jVYRR9Vo/moFb09CywwSyQhS60V5IB56lNCx0tOw+zARtmUUxB+/EmSPimBLtk
         FVElmePTlBxeLX5kCWsZiFde6QSLMRnd9PvIm48AfOmR8HhuJjsIDRSNaoe3GBd3UY
         1HzAYsrJwwDlXhfdCvDx6GoVK0A9oe6PtPlB5FZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 779/783] mptcp: remove MPTCP ifdef in TCP SYN cookies
Date:   Thu, 12 Jan 2023 14:58:15 +0100
Message-Id: <20230112135600.511785784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 3fff88186f047627bb128d65155f42517f8e448f upstream.

To ease the maintenance, it is often recommended to avoid having #ifdef
preprocessor conditions.

Here the section related to CONFIG_MPTCP was quite short but the next
commit needs to add more code around. It is then cleaner to move
specific MPTCP code to functions located in net/mptcp directory.

Now that mptcp_subflow_request_sock_ops structure can be static, it can
also be marked as "read only after init".

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mptcp.h   |   12 ++++++++++--
 net/ipv4/syncookies.c |    7 +++----
 net/mptcp/subflow.c   |   12 +++++++++++-
 3 files changed, 24 insertions(+), 7 deletions(-)

--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -58,8 +58,6 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
-extern struct request_sock_ops mptcp_subflow_request_sock_ops;
-
 void mptcp_init(void);
 
 static inline bool sk_is_mptcp(const struct sock *sk)
@@ -133,6 +131,9 @@ void mptcp_seq_show(struct seq_file *seq
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  struct sk_buff *skb);
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener);
 #else
 
 static inline void mptcp_init(void)
@@ -208,6 +209,13 @@ static inline int mptcp_subflow_init_coo
 {
 	return 0; /* TCP fallback */
 }
+
+static inline struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+							     struct sock *sk_listener,
+							     bool attach_listener)
+{
+	return NULL;
+}
 #endif /* CONFIG_MPTCP */
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -290,12 +290,11 @@ struct request_sock *cookie_tcp_reqsk_al
 	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
-#ifdef CONFIG_MPTCP
 	if (sk_is_mptcp(sk))
-		ops = &mptcp_subflow_request_sock_ops;
-#endif
+		req = mptcp_subflow_reqsk_alloc(ops, sk, false);
+	else
+		req = inet_reqsk_alloc(ops, sk, false);
 
-	req = inet_reqsk_alloc(ops, sk, false);
 	if (!req)
 		return NULL;
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -359,7 +359,7 @@ do_reset:
 	mptcp_subflow_reset(sk);
 }
 
-struct request_sock_ops mptcp_subflow_request_sock_ops;
+static struct request_sock_ops mptcp_subflow_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -411,6 +411,16 @@ drop:
 }
 #endif
 
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener)
+{
+	ops = &mptcp_subflow_request_sock_ops;
+
+	return inet_reqsk_alloc(ops, sk_listener, attach_listener);
+}
+EXPORT_SYMBOL(mptcp_subflow_reqsk_alloc);
+
 /* validate hmac received in third ACK */
 static bool subflow_hmac_valid(const struct request_sock *req,
 			       const struct mptcp_options_received *mp_opt)


