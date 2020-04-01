Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4393619B0FC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387918AbgDAQa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgDAQa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:30:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A7D2137B;
        Wed,  1 Apr 2020 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758657;
        bh=FOmBWtWn6+3QgLUu7/ZRMJz1EGVdTZYZfjvklXBdgdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlHMcy7jzqagMmZugur1G9yJ6oEH34QIm6AVLXgXRDcR4EbDA9afhl+RLEQKeiQPP
         iOwoECiBh8Dzt+mVb31anrE8QR3JJbipCQJF2j2Mt2FZyip7PsbVaavuW7h9ag9QTl
         rtlxUi9C7ZAKmLfwUAPFTz7NIZWGvPjaPnADf2lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com,
        syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com,
        syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com
Subject: [PATCH 4.4 36/91] net_sched: cls_route: remove the right filter from hashtable
Date:   Wed,  1 Apr 2020 18:17:32 +0200
Message-Id: <20200401161526.901169434@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ef299cc3fa1a9e1288665a9fdc8bff55629fd359 ]

route4_change() allocates a new filter and copies values from
the old one. After the new filter is inserted into the hash
table, the old filter should be removed and freed, as the final
step of the update.

However, the current code mistakenly removes the new one. This
looks apparently wrong to me, and it causes double "free" and
use-after-free too, as reported by syzbot.

Reported-and-tested-by: syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com
Fixes: 1109c00547fc ("net: sched: RCU cls_route")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -540,8 +540,8 @@ static int route4_change(struct net *net
 			fp = &b->ht[h];
 			for (pfp = rtnl_dereference(*fp); pfp;
 			     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
-				if (pfp == f) {
-					*fp = f->next;
+				if (pfp == fold) {
+					rcu_assign_pointer(*fp, fold->next);
 					break;
 				}
 			}


