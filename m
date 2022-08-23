Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5944A59DC9E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbiHWMSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359766AbiHWMQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4F79EEF;
        Tue, 23 Aug 2022 02:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35E4B81C99;
        Tue, 23 Aug 2022 09:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066DC433D6;
        Tue, 23 Aug 2022 09:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247640;
        bh=+3Z0N652XQDKJcVkH2Y1HAqVaUgo8FNp2aL9bo8S6VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qazEv0rjR7rYlrrH3r58dHVFtRygigR1bwK1C8UhDWg5+NErNnYsu8ohSzp+gdeS3
         kEzVf9r2TMLpEA/5asFENuY3uYDZPIQcSLX/CvaE+qzZ38oLv63JHtrdox5umg5ToN
         4DL6DWeuQHB+mPn/ZHniu0V8rb2DZgPy5GvdR50w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/158] audit: log nftables configuration change events once per table
Date:   Tue, 23 Aug 2022 10:27:10 +0200
Message-Id: <20220823080049.994739312@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit c520292f29b8047285bcfbc2322fa2a9bf02521a ]

Reduce logging of nftables events to a level similar to iptables.
Restore the table field to list the table, adding the generation.

Indicate the op as the most significant operation in the event.

A couple of sample events:

type=PROCTITLE msg=audit(2021-03-18 09:30:49.801:143) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
type=SYSCALL msg=audit(2021-03-18 09:30:49.801:143) : arch=x86_64 syscall=sendmsg success=yes exit=172 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=roo
t sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv6 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv4 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=inet entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld

type=PROCTITLE msg=audit(2021-03-18 09:30:49.839:144) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
type=SYSCALL msg=audit(2021-03-18 09:30:49.839:144) : arch=x86_64 syscall=sendmsg success=yes exit=22792 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=r
oot sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv6 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv4 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=inet entries=165 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld

The issue was originally documented in
https://github.com/linux-audit/audit-kernel/issues/124

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 186 +++++++++++++++++++---------------
 1 file changed, 103 insertions(+), 83 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 990a0274e555..507d3d24a347 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -66,6 +66,41 @@ static const struct rhashtable_params nft_objname_ht_params = {
 	.automatic_shrinking	= true,
 };
 
+struct nft_audit_data {
+	struct nft_table *table;
+	int entries;
+	int op;
+	struct list_head list;
+};
+
+static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
+	[NFT_MSG_NEWTABLE]	= AUDIT_NFT_OP_TABLE_REGISTER,
+	[NFT_MSG_GETTABLE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELTABLE]	= AUDIT_NFT_OP_TABLE_UNREGISTER,
+	[NFT_MSG_NEWCHAIN]	= AUDIT_NFT_OP_CHAIN_REGISTER,
+	[NFT_MSG_GETCHAIN]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELCHAIN]	= AUDIT_NFT_OP_CHAIN_UNREGISTER,
+	[NFT_MSG_NEWRULE]	= AUDIT_NFT_OP_RULE_REGISTER,
+	[NFT_MSG_GETRULE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELRULE]	= AUDIT_NFT_OP_RULE_UNREGISTER,
+	[NFT_MSG_NEWSET]	= AUDIT_NFT_OP_SET_REGISTER,
+	[NFT_MSG_GETSET]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELSET]	= AUDIT_NFT_OP_SET_UNREGISTER,
+	[NFT_MSG_NEWSETELEM]	= AUDIT_NFT_OP_SETELEM_REGISTER,
+	[NFT_MSG_GETSETELEM]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELSETELEM]	= AUDIT_NFT_OP_SETELEM_UNREGISTER,
+	[NFT_MSG_NEWGEN]	= AUDIT_NFT_OP_GEN_REGISTER,
+	[NFT_MSG_GETGEN]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_TRACE]		= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_NEWOBJ]	= AUDIT_NFT_OP_OBJ_REGISTER,
+	[NFT_MSG_GETOBJ]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELOBJ]	= AUDIT_NFT_OP_OBJ_UNREGISTER,
+	[NFT_MSG_GETOBJ_RESET]	= AUDIT_NFT_OP_OBJ_RESET,
+	[NFT_MSG_NEWFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_REGISTER,
+	[NFT_MSG_GETFLOWTABLE]	= AUDIT_NFT_OP_INVALID,
+	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+};
+
 static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 {
 	switch (net->nft.validate_state) {
@@ -710,17 +745,6 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
-			      ctx->table->name, ctx->table->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			ctx->table->use,
-			event == NFT_MSG_NEWTABLE ?
-				AUDIT_NFT_OP_TABLE_REGISTER :
-				AUDIT_NFT_OP_TABLE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -1477,18 +1501,6 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      ctx->chain->name, ctx->chain->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			ctx->chain->use,
-			event == NFT_MSG_NEWCHAIN ?
-				AUDIT_NFT_OP_CHAIN_REGISTER :
-				AUDIT_NFT_OP_CHAIN_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -2844,18 +2856,6 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      ctx->chain->name, ctx->chain->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			rule->handle,
-			event == NFT_MSG_NEWRULE ?
-				AUDIT_NFT_OP_RULE_REGISTER :
-				AUDIT_NFT_OP_RULE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -3882,18 +3882,6 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
 	int err;
-	char *buf = kasprintf(gfp_flags, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      set->name, set->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			set->field_count,
-			event == NFT_MSG_NEWSET ?
-				AUDIT_NFT_OP_SET_REGISTER :
-				AUDIT_NFT_OP_SET_UNREGISTER,
-			gfp_flags);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -5035,18 +5023,6 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	u32 portid = ctx->portid;
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      ctx->table->name, ctx->table->handle,
-			      set->name, set->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			set->handle,
-			event == NFT_MSG_NEWSETELEM ?
-				AUDIT_NFT_OP_SETELEM_REGISTER :
-				AUDIT_NFT_OP_SETELEM_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
@@ -6180,12 +6156,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 			    filter->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != filter->type)
 				goto cont;
-
 			if (reset) {
 				char *buf = kasprintf(GFP_ATOMIC,
-						      "%s:%llu;?:0",
+						      "%s:%u",
 						      table->name,
-						      table->handle);
+						      net->nft.base_seq);
 
 				audit_log_nfcfg(buf,
 						family,
@@ -6306,8 +6281,8 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		reset = true;
 
 	if (reset) {
-		char *buf = kasprintf(GFP_ATOMIC, "%s:%llu;?:0",
-				      table->name, table->handle);
+		char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
+				      table->name, net->nft.base_seq);
 
 		audit_log_nfcfg(buf,
 				family,
@@ -6394,15 +6369,15 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(gfp, "%s:%llu;?:0",
-			      table->name, table->handle);
+	char *buf = kasprintf(gfp, "%s:%u",
+			      table->name, net->nft.base_seq);
 
 	audit_log_nfcfg(buf,
 			family,
 			obj->handle,
 			event == NFT_MSG_NEWOBJ ?
-				AUDIT_NFT_OP_OBJ_REGISTER :
-				AUDIT_NFT_OP_OBJ_UNREGISTER,
+				 AUDIT_NFT_OP_OBJ_REGISTER :
+				 AUDIT_NFT_OP_OBJ_UNREGISTER,
 			gfp);
 	kfree(buf);
 
@@ -7220,18 +7195,6 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 {
 	struct sk_buff *skb;
 	int err;
-	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
-			      flowtable->table->name, flowtable->table->handle,
-			      flowtable->name, flowtable->handle);
-
-	audit_log_nfcfg(buf,
-			ctx->family,
-			flowtable->hooknum,
-			event == NFT_MSG_NEWFLOWTABLE ?
-				AUDIT_NFT_OP_FLOWTABLE_REGISTER :
-				AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
-			GFP_KERNEL);
-	kfree(buf);
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
@@ -7352,9 +7315,6 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	struct sk_buff *skb2;
 	int err;
 
-	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
-			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
-
 	if (!nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
@@ -7885,12 +7845,64 @@ static void nft_commit_notify(struct net *net, u32 portid)
 	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
 }
 
+static int nf_tables_commit_audit_alloc(struct list_head *adl,
+					struct nft_table *table)
+{
+	struct nft_audit_data *adp;
+
+	list_for_each_entry(adp, adl, list) {
+		if (adp->table == table)
+			return 0;
+	}
+	adp = kzalloc(sizeof(*adp), GFP_KERNEL);
+	if (!adp)
+		return -ENOMEM;
+	adp->table = table;
+	list_add(&adp->list, adl);
+	return 0;
+}
+
+static void nf_tables_commit_audit_collect(struct list_head *adl,
+					   struct nft_table *table, u32 op)
+{
+	struct nft_audit_data *adp;
+
+	list_for_each_entry(adp, adl, list) {
+		if (adp->table == table)
+			goto found;
+	}
+	WARN_ONCE("table=%s not expected in commit list", table->name);
+	return;
+found:
+	adp->entries++;
+	if (!adp->op || adp->op > op)
+		adp->op = op;
+}
+
+#define AUNFTABLENAMELEN (NFT_TABLE_MAXNAMELEN + 22)
+
+static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
+{
+	struct nft_audit_data *adp, *adn;
+	char aubuf[AUNFTABLENAMELEN];
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		snprintf(aubuf, AUNFTABLENAMELEN, "%s:%u", adp->table->name,
+			 generation);
+		audit_log_nfcfg(aubuf, adp->table->family, adp->entries,
+				nft2audit_op[adp->op], GFP_KERNEL);
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	LIST_HEAD(adl);
 	int err;
 
 	if (list_empty(&net->nft.commit_list)) {
@@ -7910,6 +7922,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		int ret;
 
+		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
+		if (ret) {
+			nf_tables_commit_chain_prepare_cancel(net);
+			return ret;
+		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
 			chain = trans->ctx.chain;
@@ -7938,6 +7955,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	net->nft.gencursor = nft_gencursor_next(net);
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
+					       trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
@@ -8092,6 +8111,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
+	nf_tables_commit_audit_log(&adl, net->nft.base_seq);
 	nf_tables_commit_release(net);
 
 	return 0;
-- 
2.35.1



