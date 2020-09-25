Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909692787F3
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgIYMv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgIYMv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EDC2075E;
        Fri, 25 Sep 2020 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038286;
        bh=1eMB35O/YYu1FUpbnaPQlHV3JPbKu9y4jtby9smTyls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMjv/gqg7Dy30BxLmu/2SjEvUNsqjVRVmG4wTwI2ou4vKrPc85d+/9im85xYXQgA5
         t8SMpcBsznoQE76AfvAnhV5+OKJgw6X38trygt0SAI4v4R13l7zp+7J2LPOcKYdGJ/
         5APuoAJbxikPXIjFgP6J+JIzb360Mz7+TUx1FIyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+80e32b5d1f9923f8ace6@syzkaller.appspotmail.com
Subject: [PATCH 5.4 06/43] act_ife: load meta modules before tcf_idr_check_alloc()
Date:   Fri, 25 Sep 2020 14:48:18 +0200
Message-Id: <20200925124724.468386578@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -508,6 +523,21 @@ static int tcf_ife_init(struct net *net,
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
@@ -569,15 +599,9 @@ static int tcf_ife_init(struct net *net,
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


