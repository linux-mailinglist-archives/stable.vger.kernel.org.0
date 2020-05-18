Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7CD1D8156
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbgERRrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgERRrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF1420657;
        Mon, 18 May 2020 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824028;
        bh=3buQ2INR/cncheX+j1GIwxDoRrtLBkthjHGxaijJLcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NV5nEstKYYhc0LFvWW55+jv3cn8nPSwHuCHdTHJ7f6vTmTSGfTv5ZXh5hH7OAW06P
         3k/+vaTwI3lJ8Yglj2HoZwTeF48p21if4GYo2tIUAMKaD7ll12I9o99a0VnCKmstQZ
         ybpkAedHLitwgb3i7pExvXwEeoR0j8heNtP6d/DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 008/114] sch_sfq: validate silly quantum values
Date:   Mon, 18 May 2020 19:35:40 +0200
Message-Id: <20200518173504.720494834@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit df4953e4e997e273501339f607b77953772e3559 ]

syzbot managed to set up sfq so that q->scaled_quantum was zero,
triggering an infinite loop in sfq_dequeue()

More generally, we must only accept quantum between 1 and 2^18 - 7,
meaning scaled_quantum must be in [1, 0x7FFF] range.

Otherwise, we also could have a loop in sfq_dequeue()
if scaled_quantum happens to be 0x8000, since slot->allot
could indefinitely switch between 0 and 0x8000.

Fixes: eeaeb068f139 ("sch_sfq: allow big packets and be fair")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -639,6 +639,15 @@ static int sfq_change(struct Qdisc *sch,
 	if (ctl->divisor &&
 	    (!is_power_of_2(ctl->divisor) || ctl->divisor > 65536))
 		return -EINVAL;
+
+	/* slot->allot is a short, make sure quantum is not too big. */
+	if (ctl->quantum) {
+		unsigned int scaled = SFQ_ALLOT_SIZE(ctl->quantum);
+
+		if (scaled <= 0 || scaled > SHRT_MAX)
+			return -EINVAL;
+	}
+
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
 					ctl_v1->Wlog))
 		return -EINVAL;


