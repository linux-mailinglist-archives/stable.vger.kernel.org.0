Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE44C15A8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfI2N7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729775AbfI2N7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 933AA2082F;
        Sun, 29 Sep 2019 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765580;
        bh=972AL1vjFDOEPaUs0FxqVBXlwhqdVEaKh6uM6gYrhlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4u6AaLMvfhO0y24n+GhQJfwJwjXWmOJvk61gllgpf4zpf1UimdlYYo2E1mvUMxMg
         Uidc0h5uqefHSLur+6ZeNjj1ns2dj4ec80indYHD7MHhAPg/HwgfJQXdO8Y/VYBhhD
         9MN9t0uO3JW5V8wMTSduOsVAt+wtTZWsAojfEV3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/63] net_sched: check cops->tcf_block in tc_bind_tclass()
Date:   Sun, 29 Sep 2019 15:54:35 +0200
Message-Id: <20190929135041.447819712@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 8b142a00edcf8422ca48b8de88d286efb500cb53 ]

At least sch_red and sch_tbf don't implement ->tcf_block()
while still have a non-zero tc "class".

Instead of adding nop implementations to each of such qdisc's,
we can just relax the check of cops->tcf_block() in
tc_bind_tclass(). They don't support TC filter anyway.

Reported-by: syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index be7cd140b2a38..b06cc5e504127 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1831,6 +1831,8 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 	cl = cops->find(q, portid);
 	if (!cl)
 		return;
+	if (!cops->tcf_block)
+		return;
 	block = cops->tcf_block(q, cl, NULL);
 	if (!block)
 		return;
-- 
2.20.1



