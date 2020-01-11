Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D57137D57
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAKJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbgAKJ4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:56:34 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340552064C;
        Sat, 11 Jan 2020 09:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736593;
        bh=7kDf70uPJllFRG6KjY3sw8i/7bcmhbURD18d9eTmYnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bq+4GJXoz4q9MVg7wXafwH5U8WpfAF8J4Pb8Zh9B2iUyswQIA/kJe1fkk3n3CSaMt
         cf1onYqzxTl1uYl3wMnMz5u66doAHtPtEnff/iEHunGpxk0zGjo0H4ZPIegy4uUOAs
         3dQC4E2IdAFDPOzsCuZH5yfVG8jV2wqDpQ9g0P6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.4 51/59] pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
Date:   Sat, 11 Jan 2020 10:50:00 +0100
Message-Id: <20200111094850.568289216@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d9e15a2733067c9328fb56d98fe8e574fa19ec31 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -706,7 +706,7 @@ static int fq_change(struct Qdisc *sch,
 	if (tb[TCA_FQ_QUANTUM]) {
 		u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
 
-		if (quantum > 0)
+		if (quantum > 0 && quantum <= (1 << 20))
 			q->quantum = quantum;
 		else
 			err = -EINVAL;


