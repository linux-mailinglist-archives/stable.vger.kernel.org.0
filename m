Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CA1B6811
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgDWXMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50120 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728520AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvX-0004lh-Uh; Fri, 24 Apr 2020 00:06:40 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-00E6to-Rz; Fri, 24 Apr 2020 00:06:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Fri, 24 Apr 2020 00:06:30 +0100
Message-ID: <lsq.1587683028.182041319@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 163/245] pkt_sched: fq: do not accept silly
 TCA_FQ_QUANTUM
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit d9e15a2733067c9328fb56d98fe8e574fa19ec31 upstream.

As diagnosed by Florian :

If TCA_FQ_QUANTUM is set to 0x80000000, fq_deueue()
can loop forever in :

if (f->credit <= 0) {
  f->credit += q->quantum;
  goto begin;
}

... because f->credit is either 0 or -2147483648.

Let's limit TCA_FQ_QUANTUM to no more than 1 << 20 :
This max value should limit risks of breaking user setups
while fixing this bug.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: Drop call to NL_SET_ERR_MSG_MOD() as extack is
 not supported.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -690,7 +690,7 @@ static int fq_change(struct Qdisc *sch,
 	if (tb[TCA_FQ_QUANTUM]) {
 		u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
 
-		if (quantum > 0)
+		if (quantum > 0 && quantum <= (1 << 20))
 			q->quantum = quantum;
 		else
 			err = -EINVAL;

