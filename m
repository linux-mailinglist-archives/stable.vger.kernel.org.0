Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA05656C4
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiGDNPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiGDNPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0164BF4A
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC24614C4
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C33C3411E;
        Mon,  4 Jul 2022 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656940518;
        bh=YytvB5ICotJkGzM2ciRXKMincd2l02U7rf6iAESkAjU=;
        h=Subject:To:Cc:From:Date:From;
        b=e8TxHu+Pz1HwjfYh8C+1Ftn5La+wxN47uPFbOpif94kznUwT//hNbB+XxXWqypXOC
         s9KMmBMq8V/wsgBKQkbS3BNEtYzG2LCyByDNO3nZUeQlM/8S2qFHCKcirFcRNn9vi3
         LIeE3bny44pZQYh0Plz1XGllCXsFLcA7LEp3laRE=
Subject: FAILED: patch "[PATCH] net/sched: act_api: Notify user space if any actions were" failed to apply to 4.19-stable tree
To:     victor@mojatatu.com, jhs@mojatatu.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:15:15 +0200
Message-ID: <1656940515213192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 76b39b94382f9e0a639e1c70c3253de248cc4c83 Mon Sep 17 00:00:00 2001
From: Victor Nogueira <victor@mojatatu.com>
Date: Thu, 23 Jun 2022 11:07:41 -0300
Subject: [PATCH] net/sched: act_api: Notify user space if any actions were
 flushed before error

If during an action flush operation one of the actions is still being
referenced, the flush operation is aborted and the kernel returns to
user space with an error. However, if the kernel was able to flush, for
example, 3 actions and failed on the fourth, the kernel will not notify
user space that it deleted 3 actions before failing.

This patch fixes that behaviour by notifying user space of how many
actions were deleted before flush failed and by setting extack with a
message describing what happened.

Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index da9733da9868..817065aa2833 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -588,7 +588,8 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 }
 
 static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
-			  const struct tc_action_ops *ops)
+			  const struct tc_action_ops *ops,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *nest;
 	int n_i = 0;
@@ -604,20 +605,25 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	if (nla_put_string(skb, TCA_KIND, ops->kind))
 		goto nla_put_failure;
 
+	ret = 0;
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
 		if (IS_ERR(p))
 			continue;
 		ret = tcf_idr_release_unsafe(p);
-		if (ret == ACT_P_DELETED) {
+		if (ret == ACT_P_DELETED)
 			module_put(ops->owner);
-			n_i++;
-		} else if (ret < 0) {
-			mutex_unlock(&idrinfo->lock);
-			goto nla_put_failure;
-		}
+		else if (ret < 0)
+			break;
+		n_i++;
 	}
 	mutex_unlock(&idrinfo->lock);
+	if (ret < 0) {
+		if (n_i)
+			NL_SET_ERR_MSG(extack, "Unable to flush all TC actions");
+		else
+			goto nla_put_failure;
+	}
 
 	ret = nla_put_u32(skb, TCA_FCNT, n_i);
 	if (ret)
@@ -638,7 +644,7 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
 	if (type == RTM_DELACTION) {
-		return tcf_del_walker(idrinfo, skb, ops);
+		return tcf_del_walker(idrinfo, skb, ops, extack);
 	} else if (type == RTM_GETACTION) {
 		return tcf_dump_walker(idrinfo, skb, cb);
 	} else {

