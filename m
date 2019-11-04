Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF616EEC2E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbfKDVyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387971AbfKDVye (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:54:34 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 878FD217F4;
        Mon,  4 Nov 2019 21:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904474;
        bh=vIY7s/sWc35wae5Q2HDnJ+V/vP5qanCNZjWVkgXUNS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBSSWHOxCsUtqnt57QZMo6/kS2CBAS/13/VBu6AXWxTfPRY19FyaMZ8tnP0Zz5bPP
         6kK9fCqgiNyy1TAcV1HzNKLmcuROQw+2IydMD877iGgpWQMhK0UQExFKY30LeAEtqa
         kRXEgM4uCyfA7phJquWh14Mae8KGi+S5iAdeJv2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zubin Mithra <zsm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 59/95] net_sched: check cops->tcf_block in tc_bind_tclass()
Date:   Mon,  4 Nov 2019 22:44:57 +0100
Message-Id: <20191104212106.949412581@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 8b142a00edcf8422ca48b8de88d286efb500cb53 upstream

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
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 637949b576c63..296e95f72eb15 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1695,6 +1695,8 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 	cl = cops->find(q, portid);
 	if (!cl)
 		return;
+	if (!cops->tcf_block)
+		return;
 	block = cops->tcf_block(q, cl);
 	if (!block)
 		return;
-- 
2.20.1



