Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA18829B358
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766394AbgJ0Osd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766379AbgJ0Osa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 504D1206E5;
        Tue, 27 Oct 2020 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810108;
        bh=X0KNH79P368ib1KLLif5rioUG0MMtWpG+iDiEO2PYyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXVc3EfcCetdcu5Ulr5oj81MsjaisGbj1Ue2YqY/XeHQNXoTKU/KnCAfOwE3rqnsi
         4dqwubiaT3ErdqYUxU6lBQQjFgeqrohXUhvPB7WW2+YK+T8+W1cXjTJt609TGVHMHc
         nrwtb8DOEYRXh5ZWZ+dDdFsebMH6DMw4MPBUBqBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 5.8 024/633] net_sched: remove a redundant goto chain check
Date:   Tue, 27 Oct 2020 14:46:07 +0100
Message-Id: <20201027135523.832186012@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 1aad8049909a6d3379175ef2824a68ac35c0b564 ]

All TC actions call tcf_action_check_ctrlact() to validate
goto chain, so this check in tcf_action_init_1() is actually
redundant. Remove it to save troubles of leaking memory.

Fixes: e49d8c22f126 ("net_sched: defer tcf_idr_insert() in tcf_action_init_1()")
Reported-by: Vlad Buslov <vladbu@mellanox.com>
Suggested-by: Davide Caratti <dcaratti@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -722,13 +722,6 @@ int tcf_action_destroy(struct tc_action
 	return ret;
 }
 
-static int tcf_action_destroy_1(struct tc_action *a, int bind)
-{
-	struct tc_action *actions[] = { a, NULL };
-
-	return tcf_action_destroy(actions, bind);
-}
-
 static int tcf_action_put(struct tc_action *p)
 {
 	return __tcf_action_put(p, false);
@@ -1000,13 +993,6 @@ struct tc_action *tcf_action_init_1(stru
 	if (err < 0)
 		goto err_mod;
 
-	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
-	    !rcu_access_pointer(a->goto_chain)) {
-		tcf_action_destroy_1(a, bind);
-		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
-		return ERR_PTR(-EINVAL);
-	}
-
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
 


