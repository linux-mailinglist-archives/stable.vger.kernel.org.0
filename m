Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA6566D11
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiGEMU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiGEMSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A4E1A3A1;
        Tue,  5 Jul 2022 05:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5B7DB817D3;
        Tue,  5 Jul 2022 12:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D942C341C7;
        Tue,  5 Jul 2022 12:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023228;
        bh=u2+qk0VaXt/xlaKih6IiscdsQz5E8o+kNEJq18d1LV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9yw6pAIvT33GawiFXnCJj9Qa0DZXw7OL8UgoCCgVUtdHbrsS+Ho5Yz7yKhxnZzUy
         fCOdQsh4o+5pbRHWeGZ6NP4WjYk9hvfaeKcc+MiIF22Oryj9vUQ5QV9C3+bXUlaxLM
         FOWSkUNHPEL3yRi/Dej+Crr17bbkK6R1wiI26DZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Nogueira <victor@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 42/98] net/sched: act_api: Notify user space if any actions were flushed before error
Date:   Tue,  5 Jul 2022 13:58:00 +0200
Message-Id: <20220705115618.782704663@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Victor Nogueira <victor@mojatatu.com>

commit 76b39b94382f9e0a639e1c70c3253de248cc4c83 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -350,7 +350,8 @@ static int tcf_idr_release_unsafe(struct
 }
 
 static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
-			  const struct tc_action_ops *ops)
+			  const struct tc_action_ops *ops,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *nest;
 	int n_i = 0;
@@ -366,20 +367,25 @@ static int tcf_del_walker(struct tcf_idr
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
@@ -400,7 +406,7 @@ int tcf_generic_walker(struct tc_action_
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
 	if (type == RTM_DELACTION) {
-		return tcf_del_walker(idrinfo, skb, ops);
+		return tcf_del_walker(idrinfo, skb, ops, extack);
 	} else if (type == RTM_GETACTION) {
 		return tcf_dump_walker(idrinfo, skb, cb);
 	} else {


