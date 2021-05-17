Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8708138325B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240896AbhEQOrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241300AbhEQOoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 665576195A;
        Mon, 17 May 2021 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261242;
        bh=eSy6zKIxXLzxOslN40huBVdUCeubKe8+1nZOsfvq3Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgeqpwdwFC/EyEdsVIXlNGYUEgWwhPtX6V6e7xZpNqaGn3T17i+teEa+4/2F0TnbO
         pKvEEfHg7cwZWlPG5cTIeRHYI/FfD1E/MEL7yOs4z38O8JqLMLCc03eOccW8tn7hJt
         paJyRRQXnkS/AT5z7W1cytrBW5DjgTb55edyQlrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com,
        Du Cheng <ducheng2@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 089/329] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
Date:   Mon, 17 May 2021 16:00:00 +0200
Message-Id: <20210517140305.121480144@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit ed8157f1ebf1ae81a8fa2653e3f20d2076fad1c9 ]

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Catch this condition in parse_taprio_schedule to
prevent this condition.

Reported as bug on syzkaller:
https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c

Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Acked-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6f775275826a..c70f93d64483 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -901,6 +901,12 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
 		list_for_each_entry(entry, &new->entries, list)
 			cycle = ktime_add_ns(cycle, entry->interval);
+
+		if (!cycle) {
+			NL_SET_ERR_MSG(extack, "'cycle_time' can never be 0");
+			return -EINVAL;
+		}
+
 		new->cycle_time = cycle;
 	}
 
-- 
2.30.2



