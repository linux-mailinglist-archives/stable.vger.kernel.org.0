Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C048E278793
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgIYMsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbgIYMsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:48:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD62E221EC;
        Fri, 25 Sep 2020 12:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038120;
        bh=sy9yQ69z3QF1anMKHNOhTmy1R1dHozoWZUmbCNN7yFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wc/8dfLf18/OALB+vxdtP53l9b0Ha6QgewW9MFgIALeB8RY/3O2yM/VqlSnKStTAC
         rzgkl9hH8Fkp9YgPnF6kx6Z+EpUUd8u5zCC1+fAxZqnWwFVxdeo46L7aQOl0cWu3Cf
         HgqRmUW5lDDijFy01YXCiIp724mFHVqvkCBLlPOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
Subject: [PATCH 5.8 03/56] act_ife: load meta modules before tcf_idr_check_alloc()
Date:   Fri, 25 Sep 2020 14:47:53 +0200
Message-Id: <20200925124728.338886281@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit cc8e58f8325cdf14b9516b61c384cdfd02a4f408 ]

The following deadlock scenario is triggered by syzbot:

Thread A:				Thread B:
tcf_idr_check_alloc()
...
populate_metalist()
  rtnl_unlock()
					rtnl_lock()
					...
  request_module()			tcf_idr_check_alloc()
  rtnl_lock()

At this point, thread A is waiting for thread B to release RTNL
lock, while thread B is waiting for thread A to commit the IDR
change with tcf_idr_insert() later.

Break this deadlock situation by preloading ife modules earlier,
before tcf_idr_check_alloc(), this is fine because we only need
to load modules we need potentially.

Reported-and-tested-by: syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -436,6 +436,25 @@ static void tcf_ife_cleanup(struct tc_ac
 		kfree_rcu(p, rcu);
 }
 
+static int load_metalist(struct nlattr **tb, bool rtnl_held)
+{
+	int i;
+
+	for (i = 1; i < max_metacnt; i++) {
+		if (tb[i]) {
+			void *val = nla_data(tb[i]);
+			int len = nla_len(tb[i]);
+			int rc;
+
+			rc = load_metaops_and_vet(i, val, len, rtnl_held);
+			if (rc != 0)
+				return rc;
+		}
+	}
+
+	return 0;
+}
+
 static int populate_metalist(struct tcf_ife_info *ife, struct nlattr **tb,
 			     bool exists, bool rtnl_held)
 {
@@ -449,10 +468,6 @@ static int populate_metalist(struct tcf_
 			val = nla_data(tb[i]);
 			len = nla_len(tb[i]);
 
-			rc = load_metaops_and_vet(i, val, len, rtnl_held);
-			if (rc != 0)
-				return rc;
-
 			rc = add_metainfo(ife, i, val, len, exists);
 			if (rc)
 				return rc;
@@ -509,6 +524,21 @@ static int tcf_ife_init(struct net *net,
 	if (!p)
 		return -ENOMEM;
 
+	if (tb[TCA_IFE_METALST]) {
+		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
+						  tb[TCA_IFE_METALST], NULL,
+						  NULL);
+		if (err) {
+			kfree(p);
+			return err;
+		}
+		err = load_metalist(tb2, rtnl_held);
+		if (err) {
+			kfree(p);
+			return err;
+		}
+	}
+
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0) {
@@ -570,15 +600,9 @@ static int tcf_ife_init(struct net *net,
 	}
 
 	if (tb[TCA_IFE_METALST]) {
-		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
-						  tb[TCA_IFE_METALST], NULL,
-						  NULL);
-		if (err)
-			goto metadata_parse_err;
 		err = populate_metalist(ife, tb2, exists, rtnl_held);
 		if (err)
 			goto metadata_parse_err;
-
 	} else {
 		/* if no passed metadata allow list or passed allow-all
 		 * then here we process by adding as many supported metadatum


