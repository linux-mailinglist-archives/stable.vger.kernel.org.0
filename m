Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D3528B838
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgJLNuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731922AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05F8420838;
        Mon, 12 Oct 2020 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510475;
        bh=xaKaBIrkkXGyYw7amhaPuxjNGljU04YxFH7p5PWnDjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP2hT/0goXcApwoBoCJqhMxRtgAWm77MrzGOXkaxfRDF7VRHIbtxCsfDYFk2+vHmT
         duVgxIZCYcT88F5cT3tWH4KwsEScbjyKcRm1DJNQGuBobFbimS36br4q6Xjpq+dFIN
         27+x2Uo0ZKj6EAb6kyKFK+hQSrnZXPlhMtM93jF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 114/124] netlink: fix policy dump leak
Date:   Mon, 12 Oct 2020 15:31:58 +0200
Message-Id: <20201012133152.369524503@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit a95bc734e60449e7b073ff7ff70c35083b290ae9 upstream.

If userspace doesn't complete the policy dump, we leak the
allocated state. Fix this.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netlink.h   |    3 ++-
 net/netlink/genetlink.c |    9 ++++++++-
 net/netlink/policy.c    |   24 ++++++++++--------------
 3 files changed, 20 insertions(+), 16 deletions(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1936,7 +1936,8 @@ void nla_get_range_signed(const struct n
 int netlink_policy_dump_start(const struct nla_policy *policy,
 			      unsigned int maxtype,
 			      unsigned long *state);
-bool netlink_policy_dump_loop(unsigned long *state);
+bool netlink_policy_dump_loop(unsigned long state);
 int netlink_policy_dump_write(struct sk_buff *skb, unsigned long state);
+void netlink_policy_dump_free(unsigned long state);
 
 #endif
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1079,7 +1079,7 @@ static int ctrl_dumppolicy(struct sk_buf
 	if (err)
 		return err;
 
-	while (netlink_policy_dump_loop(&cb->args[1])) {
+	while (netlink_policy_dump_loop(cb->args[1])) {
 		void *hdr;
 		struct nlattr *nest;
 
@@ -1113,6 +1113,12 @@ nla_put_failure:
 	return skb->len;
 }
 
+static int ctrl_dumppolicy_done(struct netlink_callback *cb)
+{
+	netlink_policy_dump_free(cb->args[1]);
+	return 0;
+}
+
 static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
@@ -1123,6 +1129,7 @@ static const struct genl_ops genl_ctrl_o
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
 		.dumpit		= ctrl_dumppolicy,
+		.done		= ctrl_dumppolicy_done,
 	},
 };
 
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -84,7 +84,6 @@ int netlink_policy_dump_start(const stru
 	unsigned int policy_idx;
 	int err;
 
-	/* also returns 0 if "*_state" is our ERR_PTR() end marker */
 	if (*_state)
 		return 0;
 
@@ -140,21 +139,11 @@ static bool netlink_policy_dump_finished
 	       !state->policies[state->policy_idx].policy;
 }
 
-bool netlink_policy_dump_loop(unsigned long *_state)
+bool netlink_policy_dump_loop(unsigned long _state)
 {
-	struct nl_policy_dump *state = (void *)*_state;
-
-	if (IS_ERR(state))
-		return false;
-
-	if (netlink_policy_dump_finished(state)) {
-		kfree(state);
-		/* store end marker instead of freed state */
-		*_state = (unsigned long)ERR_PTR(-ENOENT);
-		return false;
-	}
+	struct nl_policy_dump *state = (void *)_state;
 
-	return true;
+	return !netlink_policy_dump_finished(state);
 }
 
 int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
@@ -309,3 +298,10 @@ nla_put_failure:
 	nla_nest_cancel(skb, policy);
 	return -ENOBUFS;
 }
+
+void netlink_policy_dump_free(unsigned long _state)
+{
+	struct nl_policy_dump *state = (void *)_state;
+
+	kfree(state);
+}


