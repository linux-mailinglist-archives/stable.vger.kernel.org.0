Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6A132E7FB
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCEMYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhCEMYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3483E65022;
        Fri,  5 Mar 2021 12:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947047;
        bh=9Rkd35JWqDdnI/d/KvbRUpgIk0pHtpga6C2IoiqExHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdBofzDui3Uw4JZUWmE7m8QN/Bz9N9TjXg/oZP22+f6zNUUWnuqKxhvtm/pytUCW2
         LkUz3rKCA9I84mPtwTUQuAD9vhvZf8EdtiuKEAz6MHhjiZlUaKoy1wh9MylKT1j/CD
         MyM4+IewB9364sfyCKMroBNvfhj1185CXYcICWUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 028/104] net/sched: cls_flower: Reject invalid ct_state flags rules
Date:   Fri,  5 Mar 2021 13:20:33 +0100
Message-Id: <20210305120904.560845902@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

commit 1bcc51ac0731aab1b109b2cd5c3d495f1884e5ca upstream.

Reject the unsupported and invalid ct_state flags of cls flower rules.

Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/pkt_cls.h |    2 ++
 net/sched/cls_flower.c       |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,6 +591,8 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+
+	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
 };
 
 enum {
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -30,6 +30,11 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
+		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
+#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
+		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
+
 struct fl_flow_key {
 	struct flow_dissector_key_meta meta;
 	struct flow_dissector_key_control control;
@@ -686,8 +691,10 @@ static const struct nla_policy fl_policy
 	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
 	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
-	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
-	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
+	[TCA_FLOWER_KEY_CT_STATE]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
+	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
+		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
 	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
@@ -1390,12 +1397,33 @@ static int fl_set_enc_opt(struct nlattr
 	return 0;
 }
 
+static int fl_validate_ct_state(u16 state, struct nlattr *tb,
+				struct netlink_ext_ack *extack)
+{
+	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "no trk, so no other flag can be set");
+		return -EINVAL;
+	}
+
+	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
+	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
+		NL_SET_ERR_MSG_ATTR(extack, tb,
+				    "new and est are mutually exclusive");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int fl_set_key_ct(struct nlattr **tb,
 			 struct flow_dissector_key_ct *key,
 			 struct flow_dissector_key_ct *mask,
 			 struct netlink_ext_ack *extack)
 {
 	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
+		int err;
+
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
 			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
 			return -EOPNOTSUPP;
@@ -1403,6 +1431,13 @@ static int fl_set_key_ct(struct nlattr *
 		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
+
+		err = fl_validate_ct_state(mask->ct_state,
+					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
+					   extack);
+		if (err)
+			return err;
+
 	}
 	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {


