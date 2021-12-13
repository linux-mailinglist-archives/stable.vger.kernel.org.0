Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA683472574
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhLMJnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:50 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35898 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhLMJlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A81AFCE0AE2;
        Mon, 13 Dec 2021 09:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580D4C00446;
        Mon, 13 Dec 2021 09:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388502;
        bh=OIUKyJEUh6kIs8eyaIGV9zHcxdJufY4CZ/RhKrc7iDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKCbbhkbMXxO4WA5jCYBxM5ijep++Q6jRDUmdcRvGxirl/afDcc6Z5iR9DHmKvDgL
         X0pkXbDKUds2Y/+swbWzh2/E/wTageHRpC5JCdUX3eyy6vC7kYakQa8z+/14W6OQCB
         Hrcz9qCUveJyTQUYfzQWkrrNzWL9LFlyqaoBqqM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+37b8770e6d5a8220a039@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 73/74] net_sched: fix a crash in tc_new_tfilter()
Date:   Mon, 13 Dec 2021 10:30:44 +0100
Message-Id: <20211213092933.255532366@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 460b360104d51552a57f39e54b2589c9fd7fa0b3 upstream.

When tcf_block_find() fails, it already rollbacks the qdisc refcnt,
so its caller doesn't need to clean up this again. Avoid calling
qdisc_put() again by resetting qdisc to NULL for callers.

Reported-by: syzbot+37b8770e6d5a8220a039@syzkaller.appspotmail.com
Fixes: e368fdb61d8e ("net: sched: use Qdisc rcu API instead of relying on rtnl lock")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -629,8 +629,10 @@ static struct tcf_block *tcf_block_find(
 errout_rcu:
 	rcu_read_unlock();
 errout_qdisc:
-	if (*q)
+	if (*q) {
 		qdisc_put(*q);
+		*q = NULL;
+	}
 	return ERR_PTR(err);
 }
 


