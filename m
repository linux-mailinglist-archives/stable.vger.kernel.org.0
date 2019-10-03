Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44308CAA6E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392420AbfJCRFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404841AbfJCQjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD0C2070B;
        Thu,  3 Oct 2019 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120778;
        bh=04og8EJJ0XrlsWKUC1y0IBIQv+GS066+o2phC4sBs70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZuZwFOkuZg00RZCsdbhCsQTGQrmf1cWRnhv/nByR7S6zfh/1cXmzVzWLFMBWhrGS
         OTIsa0hKvBy13cPhjrEZM0pBT+AS07XaWeA6Hxc9JX6dBcWKkLMRYo5nJmPhF7oHSe
         m2K1cW7UwpVTvSdw0rEmdVIbFkSnSTsIasdrviGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 027/344] net_sched: add policy validation for action attributes
Date:   Thu,  3 Oct 2019 17:49:52 +0200
Message-Id: <20191003154542.774892228@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 199ce850ce112315cfc68d42b694bcaa27b097b7 ]

Similar to commit 8b4c3cdd9dd8
("net: sched: Add policy validation for tc attributes"), we need
to add proper policy validation for TC action attributes too.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -831,6 +831,15 @@ static struct tc_cookie *nla_memdup_cook
 	return c;
 }
 
+static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
+	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
+				    .len = IFNAMSIZ - 1 },
+	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
+	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
+				    .len = TC_COOKIE_MAX_SIZE },
+	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
+};
+
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
@@ -846,8 +855,8 @@ struct tc_action *tcf_action_init_1(stru
 	int err;
 
 	if (name == NULL) {
-		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL,
-						  extack);
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+						  tcf_action_policy, extack);
 		if (err < 0)
 			goto err_out;
 		err = -EINVAL;
@@ -856,18 +865,9 @@ struct tc_action *tcf_action_init_1(stru
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
-			NL_SET_ERR_MSG(extack, "TC action name too long");
-			goto err_out;
-		}
-		if (tb[TCA_ACT_COOKIE]) {
-			int cklen = nla_len(tb[TCA_ACT_COOKIE]);
-
-			if (cklen > TC_COOKIE_MAX_SIZE) {
-				NL_SET_ERR_MSG(extack, "TC cookie size above the maximum");
-				goto err_out;
-			}
+		nla_strlcpy(act_name, kind, IFNAMSIZ);
 
+		if (tb[TCA_ACT_COOKIE]) {
 			cookie = nla_memdup_cookie(tb);
 			if (!cookie) {
 				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
@@ -1098,7 +1098,8 @@ static struct tc_action *tcf_action_get_
 	int index;
 	int err;
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1152,7 +1153,8 @@ static int tca_action_flush(struct net *
 
 	b = skb_tail_pointer(skb);
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1440,7 +1442,7 @@ static struct nlattr *find_dump_kind(str
 
 	if (tb[1] == NULL)
 		return NULL;
-	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], tcf_action_policy, NULL) < 0)
 		return NULL;
 	kind = tb2[TCA_ACT_KIND];
 


