Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE60D38A4D1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhETKKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235608AbhETKHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED6F6121E;
        Thu, 20 May 2021 09:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503720;
        bh=tBtlQKeOh4bzv/PsFltyg6Ant/+Arm9yc6qgELr6QD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p37IrOMwW7hjhgBhdiDpWxhT6tbHeAlKwSg8ua1iDxw67dBQPCS8b2O5F/dtI+bfD
         ihKwIUQgJQ6JdYPNAkvozw18tpBuccDntJ3IwyiVrGimzPEsMomPUxR4Qd+rIDT7UZ
         CdmhZbq5IvdmLZnRa5elIA3urpZCCrCJp1X0DVTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 349/425] netfilter: xt_SECMARK: add new revision to fix structure layout
Date:   Thu, 20 May 2021 11:21:58 +0200
Message-Id: <20210520092142.877534757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c7d13358b6a2f49f81a34aa323a2d0878a0532a2 ]

This extension breaks when trying to delete rules, add a new revision to
fix this.

Fixes: 5e6874cdb8de ("[SECMARK]: Add xtables SECMARK target")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_SECMARK.h |  6 ++
 net/netfilter/xt_SECMARK.c                | 88 ++++++++++++++++++-----
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_SECMARK.h b/include/uapi/linux/netfilter/xt_SECMARK.h
index 1f2a708413f5..beb2cadba8a9 100644
--- a/include/uapi/linux/netfilter/xt_SECMARK.h
+++ b/include/uapi/linux/netfilter/xt_SECMARK.h
@@ -20,4 +20,10 @@ struct xt_secmark_target_info {
 	char secctx[SECMARK_SECCTX_MAX];
 };
 
+struct xt_secmark_target_info_v1 {
+	__u8 mode;
+	char secctx[SECMARK_SECCTX_MAX];
+	__u32 secid;
+};
+
 #endif /*_XT_SECMARK_H_target */
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 4ad5fe27e08b..097534dbc622 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -30,10 +30,9 @@ MODULE_ALIAS("ip6t_SECMARK");
 static u8 mode;
 
 static unsigned int
-secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
+secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 {
 	u32 secmark = 0;
-	const struct xt_secmark_target_info *info = par->targinfo;
 
 	BUG_ON(info->mode != mode);
 
@@ -49,7 +48,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int checkentry_lsm(struct xt_secmark_target_info *info)
+static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
 	int err;
 
@@ -81,15 +80,15 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 	return 0;
 }
 
-static int secmark_tg_check(const struct xt_tgchk_param *par)
+static int
+secmark_tg_check(const char *table, struct xt_secmark_target_info_v1 *info)
 {
-	struct xt_secmark_target_info *info = par->targinfo;
 	int err;
 
-	if (strcmp(par->table, "mangle") != 0 &&
-	    strcmp(par->table, "security") != 0) {
+	if (strcmp(table, "mangle") != 0 &&
+	    strcmp(table, "security") != 0) {
 		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
-				    par->table);
+				    table);
 		return -EINVAL;
 	}
 
@@ -124,25 +123,76 @@ static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
 	}
 }
 
-static struct xt_target secmark_tg_reg __read_mostly = {
-	.name       = "SECMARK",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = secmark_tg_check,
-	.destroy    = secmark_tg_destroy,
-	.target     = secmark_tg,
-	.targetsize = sizeof(struct xt_secmark_target_info),
-	.me         = THIS_MODULE,
+static int secmark_tg_check_v0(const struct xt_tgchk_param *par)
+{
+	struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.mode	= info->mode,
+	};
+	int ret;
+
+	memcpy(newinfo.secctx, info->secctx, SECMARK_SECCTX_MAX);
+
+	ret = secmark_tg_check(par->table, &newinfo);
+	info->secid = newinfo.secid;
+
+	return ret;
+}
+
+static unsigned int
+secmark_tg_v0(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.secid	= info->secid,
+	};
+
+	return secmark_tg(skb, &newinfo);
+}
+
+static int secmark_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	return secmark_tg_check(par->table, par->targinfo);
+}
+
+static unsigned int
+secmark_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	return secmark_tg(skb, par->targinfo);
+}
+
+static struct xt_target secmark_tg_reg[] __read_mostly = {
+	{
+		.name		= "SECMARK",
+		.revision	= 0,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v0,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v0,
+		.targetsize	= sizeof(struct xt_secmark_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "SECMARK",
+		.revision	= 1,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v1,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v1,
+		.targetsize	= sizeof(struct xt_secmark_target_info_v1),
+		.usersize	= offsetof(struct xt_secmark_target_info_v1, secid),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init secmark_tg_init(void)
 {
-	return xt_register_target(&secmark_tg_reg);
+	return xt_register_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 static void __exit secmark_tg_exit(void)
 {
-	xt_unregister_target(&secmark_tg_reg);
+	xt_unregister_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 module_init(secmark_tg_init);
-- 
2.30.2



