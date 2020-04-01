Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE619B102
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgDAQbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgDAQbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928F6212CC;
        Wed,  1 Apr 2020 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758664;
        bh=igKsz5aGdZ2VauEo01TFaMDcawtLkncf0/hV/bXqtII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe1AaBJg15MPRSF7R740xFEoppDUf//yCFov6f/qSzulpjhiqFL0Io+uokmHio8/B
         F5U2vpxbjkpZGSO5PTuqzqe0zx9O/8r4r/rq/iM+3GRpMHEuSkEoumwwGmKCdc1y+d
         DIuJ/ZK4qPjyfRf0EXxNp9d4ERaLOCKTGXNhU/EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com,
        syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
Subject: [PATCH 4.4 37/91] net_sched: keep alloc_hash updated after hash allocation
Date:   Wed,  1 Apr 2020 18:17:33 +0200
Message-Id: <20200401161527.011635323@linuxfoundation.org>
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

[ Upstream commit 0d1c3530e1bd38382edef72591b78e877e0edcd3 ]

In commit 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
I moved cp->hash calculation before the first
tcindex_alloc_perfect_hash(), but cp->alloc_hash is left untouched.
This difference could lead to another out of bound access.

cp->alloc_hash should always be the size allocated, we should
update it after this tcindex_alloc_perfect_hash().

Reported-and-tested-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_tcindex.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -293,6 +293,7 @@ tcindex_set_parms(struct net *net, struc
 				      sizeof(*r) * cp->hash, GFP_KERNEL);
 		if (!cp->perfect)
 			goto errout;
+		cp->alloc_hash = cp->hash;
 		for (i = 0; i < min(cp->hash, p->hash); i++)
 			tcf_exts_init(&cp->perfect[i].exts,
 				      TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);


