Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6AB854F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733263AbfISWTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731332AbfISWTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728B420678;
        Thu, 19 Sep 2019 22:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931581;
        bh=m3qCy2g8XdxYeuzfG9cR3BKMkKqjyOQEIvoc12ySV2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R68L0J8lpPmQoRWgotrNVHBbVvJ2/pI8DArYYDQWrh2s/MQeZ0a3HKdliy8wRiPh7
         BkGCSpjyUvnrgvke5C1/sBv8grudzOLtCzeppWYBhj+GooDSpxZGwKGIw7xaNtmQv6
         2euiAZAqf6Gll26bAIE9om0gneO2MQfp1eVFD6cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com,
        syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com,
        syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Terry Lam <vtlam@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 07/74] sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
Date:   Fri, 20 Sep 2019 00:03:20 +0200
Message-Id: <20190919214802.500659970@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit d4d6ec6dac07f263f06d847d6f732d6855522845 ]

In case of TCA_HHF_NON_HH_WEIGHT or TCA_HHF_QUANTUM is zero,
it would make no progress inside the loop in hhf_dequeue() thus
kernel would get stuck.

Fix this by checking this corner case in hhf_change().

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Reported-by: syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com
Reported-by: syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com
Reported-by: syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Terry Lam <vtlam@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hhf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -543,7 +543,7 @@ static int hhf_change(struct Qdisc *sch,
 		new_hhf_non_hh_weight = nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
 
 	non_hh_quantum = (u64)new_quantum * new_hhf_non_hh_weight;
-	if (non_hh_quantum > INT_MAX)
+	if (non_hh_quantum == 0 || non_hh_quantum > INT_MAX)
 		return -EINVAL;
 
 	sch_tree_lock(sch);


