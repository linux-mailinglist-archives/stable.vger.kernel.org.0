Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCED3A02E7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhFHTLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234617AbhFHTHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB28B613C3;
        Tue,  8 Jun 2021 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178048;
        bh=qRgtV29vkt8l+bN+ZbQtiyJWZXFD63rBV8gf154Nykc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNQj6cSik5DeNA1FHoZVjsiVzyiBLha7N728DRYw8gZxwOXkjEc2Su3nucV5ywrPe
         rKQTRljAiUKtbtFIf2GnAaNwJsZAuuwYhoJNFIJqIGvoZATDNagfFh+xM9nLmiaNPf
         dXyKuj8JlQ77MfqtPMTHXpeZL/zq0IkKSfb/inho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 058/161] sch_htb: fix refcount leak in htb_parent_to_leaf_offload
Date:   Tue,  8 Jun 2021 20:26:28 +0200
Message-Id: <20210608175947.434459023@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 944d671d5faa0d78980a3da5c0f04960ef1ad893 ]

The commit ae81feb7338c ("sch_htb: fix null pointer dereference
on a null new_q") fixes a NULL pointer dereference bug, but it
is not correct.

Because htb_graft_helper properly handles the case when new_q
is NULL, and after the previous patch by skipping this call
which creates an inconsistency : dev_queue->qdisc will still
point to the old qdisc, but cl->parent->leaf.q will point to
the new one (which will be noop_qdisc, because new_q was NULL).
The code is based on an assumption that these two pointers are
the same, so it can lead to refcount leaks.

The correct fix is to add a NULL pointer check to protect
qdisc_refcount_inc inside htb_parent_to_leaf_offload.

Fixes: ae81feb7338c ("sch_htb: fix null pointer dereference on a null new_q")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Suggested-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 081c11d5717c..8827987ba903 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1488,7 +1488,8 @@ static void htb_parent_to_leaf_offload(struct Qdisc *sch,
 	struct Qdisc *old_q;
 
 	/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
-	qdisc_refcount_inc(new_q);
+	if (new_q)
+		qdisc_refcount_inc(new_q);
 	old_q = htb_graft_helper(dev_queue, new_q);
 	WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
 }
@@ -1675,10 +1676,9 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 					  cl->parent->common.classid,
 					  NULL);
 		if (q->offload) {
-			if (new_q) {
+			if (new_q)
 				htb_set_lockdep_class_child(new_q);
-				htb_parent_to_leaf_offload(sch, dev_queue, new_q);
-			}
+			htb_parent_to_leaf_offload(sch, dev_queue, new_q);
 		}
 	}
 
-- 
2.30.2



