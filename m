Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF42265AB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgGTP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbgGTP4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:56:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F4422CAF;
        Mon, 20 Jul 2020 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260563;
        bh=I6NXEEfK5JI78L1/UdbeoToJ7nBUSo1pNXloKT410Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDV6/brlvL0xgxo7yn8Gkr4el6URimiCAGJZ0HE1tf7ttJ/FvTJYWyJ3kP2tVZHhn
         nBTpmgI/VD7py/4cvltmqruxBSoThvXTHOoeTFspnmaCeFh3ur/QzzFWzur8NI+cWx
         rJo+lg8hYCY6W5cgiUP42On8XUFro7hmT6NAEch8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com
Subject: [PATCH 5.4 014/215] net_sched: fix a memory leak in atm_tc_init()
Date:   Mon, 20 Jul 2020 17:34:56 +0200
Message-Id: <20200720152820.839210434@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 306381aec7c2b5a658eebca008c8a1b666536cba ]

When tcf_block_get() fails inside atm_tc_init(),
atm_tc_put() is called to release the qdisc p->link.q.
But the flow->ref prevents it to do so, as the flow->ref
is still zero.

Fix this by moving the p->link.ref initialization before
tcf_block_get().

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Reported-and-tested-by: syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_atm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -553,16 +553,16 @@ static int atm_tc_init(struct Qdisc *sch
 	if (!p->link.q)
 		p->link.q = &noop_qdisc;
 	pr_debug("atm_tc_init: link (%p) qdisc %p\n", &p->link, p->link.q);
+	p->link.vcc = NULL;
+	p->link.sock = NULL;
+	p->link.common.classid = sch->handle;
+	p->link.ref = 1;
 
 	err = tcf_block_get(&p->link.block, &p->link.filter_list, sch,
 			    extack);
 	if (err)
 		return err;
 
-	p->link.vcc = NULL;
-	p->link.sock = NULL;
-	p->link.common.classid = sch->handle;
-	p->link.ref = 1;
 	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
 	return 0;
 }


