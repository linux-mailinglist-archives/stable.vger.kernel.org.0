Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F640E853
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354215AbhIPRoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354964AbhIPRkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B790461A86;
        Thu, 16 Sep 2021 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811111;
        bh=AnqclIy/yhabaP/XcnnT3myiJuVDcV2mN78sB8cMj18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtHg/kJVLZxoe88qTOWUiKndluQeFWPOsQicDMKTTOnmFwUgeszaQ/dMM2fIqKni1
         3cxY9cA24Mpvc7HLxgind2DQ1z88tW/fb9WA8dbcfpvUWDesC/o2TzFZlfsdn+ai/g
         CQpil08S8OHgv69oIRd8oWbAUeGbDqOQTwNkURn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com,
        Haimin Zhang <tcs_kernel@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 388/432] fix array-index-out-of-bounds in taprio_change
Date:   Thu, 16 Sep 2021 18:02:17 +0200
Message-Id: <20210916155823.964303662@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit efe487fce3061d94222c6501d7be3aa549b3dc78 ]

syzbot report an array-index-out-of-bounds in taprio_change
index 16 is out of range for type '__u16 [16]'
that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
the return value of netdev_set_num_tc.

Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9c79374457a0..1ab2fc933a21 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	taprio_set_picos_per_byte(dev, q);
 
 	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
 		for (i = 0; i < mqprio->num_tc; i++)
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
-- 
2.30.2



