Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9A0664A30
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbjAJSbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239394AbjAJSab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638B52C79
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED87FB818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C20C433D2;
        Tue, 10 Jan 2023 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375105;
        bh=/7PBnTF6f6Mgmr5Dv8vCC7POymBtwkex9t5h0iusb88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoJrrvNAdrvvbw5Pcy2BmDOwOOcB3QJSPEtot4N7djlGjznbjY38x4k2g8DceXxLa
         WKWVyoY7GxR5fSeNSuzr095aSuvpTky8jl85AJJOCRZPTOdfBY/Q+/Lq2xVpOgoo1/
         9f6JWYVHUcOzj/Ih2hetz3TCkdNM2/D7SntefgZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 080/290] mptcp: remove MPTCP ifdef in TCP SYN cookies
Date:   Tue, 10 Jan 2023 19:02:52 +0100
Message-Id: <20230110180034.375456179@linuxfoundation.org>
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
Cc: stable@vger.kernel.org
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
@@ -93,8 +93,6 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
-extern struct request_sock_ops mptcp_subflow_request_sock_ops;
-
 void mptcp_init(void);
 
 static inline bool sk_is_mptcp(const struct sock *sk)
@@ -182,6 +180,9 @@ void mptcp_seq_show(struct seq_file *seq
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  struct sk_buff *skb);
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener);
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb);
 
@@ -274,6 +275,13 @@ static inline int mptcp_subflow_init_coo
 	return 0; /* TCP fallback */
 }
 
+static inline struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+							     struct sock *sk_listener,
+							     bool attach_listener)
+{
+	return NULL;
+}
+
 static inline __be32 mptcp_reset_option(const struct sk_buff *skb)  { return htonl(0u); }
 #endif /* CONFIG_MPTCP */
 
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
@@ -483,7 +483,7 @@ do_reset:
 	mptcp_subflow_reset(sk);
 }
 
-struct request_sock_ops mptcp_subflow_request_sock_ops;
+static struct request_sock_ops mptcp_subflow_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -536,6 +536,16 @@ drop:
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


