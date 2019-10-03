Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C34CA850
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbfJCQZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfJCQY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5B020867;
        Thu,  3 Oct 2019 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119898;
        bh=wzy+qn7G4vChhr+Igs0f97LpsFy/FGBogC3S8Dgnf0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/fGyxrRXfSdgvo8BXLL2PWMBaoi6k2O+K9TQvw30rsp3aC8gFWC+Z2piwIKYRDq1
         IDyTBWMPAnCtFQxGhhw3QwG+JqypIHKSy+YwG0CVnCCjbAG12kElSLNFKHOWpSwH7x
         MbphbdXg2R/tC8j69Mja/1/p58pOEF7IXB4EekR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.2 022/313] net_sched: add policy validation for action attributes
Date:   Thu,  3 Oct 2019 17:50:00 +0200
Message-Id: <20191003154535.559326756@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -828,6 +828,15 @@ static struct tc_cookie *nla_memdup_cook
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
@@ -843,8 +852,8 @@ struct tc_action *tcf_action_init_1(stru
 	int err;
 
 	if (name == NULL) {
-		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL,
-						  extack);
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+						  tcf_action_policy, extack);
 		if (err < 0)
 			goto err_out;
 		err = -EINVAL;
@@ -853,18 +862,9 @@ struct tc_action *tcf_action_init_1(stru
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
@@ -1095,7 +1095,8 @@ static struct tc_action *tcf_action_get_
 	int index;
 	int err;
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1149,7 +1150,8 @@ static int tca_action_flush(struct net *
 
 	b = skb_tail_pointer(skb);
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1437,7 +1439,7 @@ static struct nlattr *find_dump_kind(str
 
 	if (tb[1] == NULL)
 		return NULL;
-	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], tcf_action_policy, NULL) < 0)
 		return NULL;
 	kind = tb2[TCA_ACT_KIND];
 


