Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E8B5CF3
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfIRGam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729820AbfIRGYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B117D21924;
        Wed, 18 Sep 2019 06:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787861;
        bh=wi4Cfyhc5EMTiYmrakDGIzbIOsQrdbs/a584aA+7zOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLkuLJK8ksGK/JJ+5IYBCStkGsQVp46QBn2sISeVuYYfCFdlN0fChGil1dJ/CoNc2
         y+pRZMLmC9DhC2m+K80Pn3urstCZbTA2u0kYh0gGXsICAxmdB4nSOOjNBLCU7Oiau8
         gZjWVFa2J9GgzML5expJzlphaUYJ7nQS0u+06d1U=
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
Subject: [PATCH 5.2 11/85] sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
Date:   Wed, 18 Sep 2019 08:18:29 +0200
Message-Id: <20190918061234.493420947@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
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
@@ -531,7 +531,7 @@ static int hhf_change(struct Qdisc *sch,
 		new_hhf_non_hh_weight = nla_get_u32(tb[TCA_HHF_NON_HH_WEIGHT]);
 
 	non_hh_quantum = (u64)new_quantum * new_hhf_non_hh_weight;
-	if (non_hh_quantum > INT_MAX)
+	if (non_hh_quantum == 0 || non_hh_quantum > INT_MAX)
 		return -EINVAL;
 
 	sch_tree_lock(sch);


