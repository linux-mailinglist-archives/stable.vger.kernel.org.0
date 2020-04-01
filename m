Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7492019B258
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgDAQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389591AbgDAQnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E2F1214D8;
        Wed,  1 Apr 2020 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759386;
        bh=8c9L/V/NFaE7MJiSJqrGZJsOP7sIRux2YXMZXzY50dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C88z90DkBt0TbktGs6ov66kBpN4Ddi1zvvjrN0a94xb2Glcw7uUSPukF1fAlhKkMw
         C1o7r7V91FOQaz+Yw8Oe+ax64mnmXA3PXNofR1nSJ7YJi8+UYEno49OhV4QzymwYdh
         WqNlFBs93wliEJnGDkKq6uy/FAnrp2mkJhAMGEVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com,
        syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
Subject: [PATCH 4.14 063/148] net_sched: keep alloc_hash updated after hash allocation
Date:   Wed,  1 Apr 2020 18:17:35 +0200
Message-Id: <20200401161559.731808028@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
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
@@ -375,6 +375,7 @@ tcindex_set_parms(struct net *net, struc
 
 		if (tcindex_alloc_perfect_hash(cp) < 0)
 			goto errout;
+		cp->alloc_hash = cp->hash;
 		for (i = 0; i < min(cp->hash, p->hash); i++)
 			cp->perfect[i].res = p->perfect[i].res;
 		balloc = 1;


