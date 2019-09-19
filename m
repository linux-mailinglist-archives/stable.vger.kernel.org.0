Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43781B8778
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404820AbfISWgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405034AbfISWGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B23721920;
        Thu, 19 Sep 2019 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930759;
        bh=PZCwTfuWldxsg3C3Jw5YY8AHw2TBpq8aBpf9WBQhNXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVDetxr+lgN897xig/CujbWSFTliGN7yzYkc8LyX+w/s3r+9dYxBu8FbR3T6L8faL
         reqkP9nlg91vAWZc8jA8b+yhvAqfjJNw0ly7/7JA+93ItwOUcqDHMYOdydMPq/KZZq
         JLvUUKSA+j15WP/+/5YnoXnRlBhuZJD3nazAEsx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 06/21] net_sched: let qdisc_put() accept NULL pointer
Date:   Fri, 20 Sep 2019 00:03:07 +0200
Message-Id: <20190919214701.920915648@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214657.842130855@linuxfoundation.org>
References: <20190919214657.842130855@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 6efb971ba8edfbd80b666f29de12882852f095ae ]

When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
pointer which leads to a crash in sfb_destroy(). Similar for
sch_dsmark.

Instead of fixing each separately, Linus suggested to just accept
NULL pointer in qdisc_put(), which would make callers easier.

(For sch_dsmark, the bug probably exists long before commit
6529eaba33f0.)

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -985,6 +985,9 @@ static void qdisc_destroy(struct Qdisc *
 
 void qdisc_put(struct Qdisc *qdisc)
 {
+	if (!qdisc)
+		return;
+
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;


