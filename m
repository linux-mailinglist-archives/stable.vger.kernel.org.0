Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791AA676FDC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjAVP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjAVP0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B11F22A3B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F43160C67
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B269FC433EF;
        Sun, 22 Jan 2023 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401159;
        bh=x5CQZ72c0QMtBcqBBi7lqLcouV43Yc+o46B25Mp1V7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3vnbHiISjPKzjwaHRLBXxDajqb9Vy6PEBE3MMTCSnMdDXc0PhAi89zCDjiGQpyvN
         4lz8x37eAr96w1UcInmNa+E+6gdE5wzj6Esj4UFLN7pSelBGXnu+0fXl7qxfGpCBo6
         R2+wCPk8wT9ey8ETNTdgn5gwaovXWm07awyDj/Zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 102/193] mptcp: netlink: respect v4/v6-only sockets
Date:   Sun, 22 Jan 2023 16:03:51 +0100
Message-Id: <20230122150250.975766338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit fb00ee4f3343acb2b9222ca9b73b47dd1e1a8efc upstream.

If an MPTCP socket has been created with AF_INET6 and the IPV6_V6ONLY
option has been set, the userspace PM would allow creating subflows
using IPv4 addresses, e.g. mapped in v6.

The kernel side of userspace PM will also accept creating subflows with
local and remote addresses having different families. Depending on the
subflow socket's family, different behaviours are expected:
 - If AF_INET is forced with a v6 address, the kernel will take the last
   byte of the IP and try to connect to that: a new subflow is created
   but to a non expected address.
 - If AF_INET6 is forced with a v4 address, the kernel will try to
   connect to a v4 address (v4-mapped-v6). A -EBADF error from the
   connect() part is then expected.

It is then required to check the given families can be accepted. This is
done by using a new helper for addresses family matching, taking care of
IPv4 vs IPv4-mapped-IPv6 addresses. This helper will be re-used later by
the in-kernel path-manager to use mixed IPv4 and IPv6 addresses.

While at it, a clear error message is now reported if there are some
conflicts with the families that have been passed by the userspace.

Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c           |   25 +++++++++++++++++++++++++
 net/mptcp/pm_userspace.c |    7 +++++++
 net/mptcp/protocol.h     |    3 +++
 3 files changed, 35 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -420,6 +420,31 @@ void mptcp_pm_subflow_chk_stale(const st
 	}
 }
 
+/* if sk is ipv4 or ipv6_only allows only same-family local and remote addresses,
+ * otherwise allow any matching local/remote pair
+ */
+bool mptcp_pm_addr_families_match(const struct sock *sk,
+				  const struct mptcp_addr_info *loc,
+				  const struct mptcp_addr_info *rem)
+{
+	bool mptcp_is_v4 = sk->sk_family == AF_INET;
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	bool loc_is_v4 = loc->family == AF_INET || ipv6_addr_v4mapped(&loc->addr6);
+	bool rem_is_v4 = rem->family == AF_INET || ipv6_addr_v4mapped(&rem->addr6);
+
+	if (mptcp_is_v4)
+		return loc_is_v4 && rem_is_v4;
+
+	if (ipv6_only_sock(sk))
+		return !loc_is_v4 && !rem_is_v4;
+
+	return loc_is_v4 == rem_is_v4;
+#else
+	return mptcp_is_v4 && loc->family == AF_INET && rem->family == AF_INET;
+#endif
+}
+
 void mptcp_pm_data_reset(struct mptcp_sock *msk)
 {
 	u8 pm_type = mptcp_get_pm_type(sock_net((struct sock *)msk));
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -294,6 +294,13 @@ int mptcp_nl_cmd_sf_create(struct sk_buf
 	}
 
 	sk = &msk->sk.icsk_inet.sk;
+
+	if (!mptcp_pm_addr_families_match(sk, &addr_l, &addr_r)) {
+		GENL_SET_ERR_MSG(info, "families mismatch");
+		err = -EINVAL;
+		goto create_err;
+	}
+
 	lock_sock(sk);
 
 	err = __mptcp_subflow_connect(sk, &addr_l, &addr_r);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -762,6 +762,9 @@ int mptcp_pm_parse_addr(struct nlattr *a
 int mptcp_pm_parse_entry(struct nlattr *attr, struct genl_info *info,
 			 bool require_family,
 			 struct mptcp_pm_addr_entry *entry);
+bool mptcp_pm_addr_families_match(const struct sock *sk,
+				  const struct mptcp_addr_info *loc,
+				  const struct mptcp_addr_info *rem);
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);


