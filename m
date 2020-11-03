Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F922A53A4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387704AbgKCVDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbgKCVC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC7B205ED;
        Tue,  3 Nov 2020 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437377;
        bh=KG7rTtSh7smK0Jinbg6MXjGnreFsmZASuxYhpM7BIAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNHn0ktfljqMUzu0E1SNZem/Jh4E9x4WcPiEjGPaFNz3RGzz9rb76p1ZI6jtD28/V
         Lg7W0Rl1bBLORLWvS0cwM4rOYxcrds6rrV3xdQ55u/cwhEPR8wRabNOeTDoodPtKNs
         JeQw0Pg4p5yyfQh87qeQM4pJfveqx5WQT1Wq9oyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksandr Nogikh <nogikh@google.com>,
        syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 012/191] netem: fix zero division in tabledist
Date:   Tue,  3 Nov 2020 21:35:04 +0100
Message-Id: <20201103203234.264796795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit eadd1befdd778a1eca57fad058782bd22b4db804 ]

Currently it is possible to craft a special netlink RTM_NEWQDISC
command that can result in jitter being equal to 0x80000000. It is
enough to set the 32 bit jitter to 0x02000000 (it will later be
multiplied by 2^6) or just set the 64 bit jitter via
TCA_NETEM_JITTER64. This causes an overflow during the generation of
uniformly distributed numbers in tabledist(), which in turn leads to
division by zero (sigma != 0, but sigma * 2 is 0).

The related fragment of code needs 32-bit division - see commit
9b0ed89 ("netem: remove unnecessary 64 bit modulus"), so switching to
64 bit is not an option.

Fix the issue by keeping the value of jitter within the range that can
be adequately handled by tabledist() - [0;INT_MAX]. As negative std
deviation makes no sense, take the absolute value of the passed value
and cap it at INT_MAX. Inside tabledist(), switch to unsigned 32 bit
arithmetic in order to prevent overflows.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reported-by: syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Link: https://lore.kernel.org/r/20201028170731.1383332-1-aleksandrnogikh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -330,7 +330,7 @@ static s64 tabledist(s64 mu, s32 sigma,
 
 	/* default uniform distribution */
 	if (dist == NULL)
-		return ((rnd % (2 * sigma)) + mu) - sigma;
+		return ((rnd % (2 * (u32)sigma)) + mu) - sigma;
 
 	t = dist->table[rnd % dist->size];
 	x = (sigma % NETEM_DIST_SCALE) * t;
@@ -787,6 +787,10 @@ static void get_slot(struct netem_sched_
 		q->slot_config.max_packets = INT_MAX;
 	if (q->slot_config.max_bytes == 0)
 		q->slot_config.max_bytes = INT_MAX;
+
+	/* capping dist_jitter to the range acceptable by tabledist() */
+	q->slot_config.dist_jitter = min_t(__s64, INT_MAX, abs(q->slot_config.dist_jitter));
+
 	q->slot.packets_left = q->slot_config.max_packets;
 	q->slot.bytes_left = q->slot_config.max_bytes;
 	if (q->slot_config.min_delay | q->slot_config.max_delay |
@@ -1011,6 +1015,9 @@ static int netem_change(struct Qdisc *sc
 	if (tb[TCA_NETEM_SLOT])
 		get_slot(q, tb[TCA_NETEM_SLOT]);
 
+	/* capping jitter to the range acceptable by tabledist() */
+	q->jitter = min_t(s64, abs(q->jitter), INT_MAX);
+
 	return ret;
 
 get_table_failure:


