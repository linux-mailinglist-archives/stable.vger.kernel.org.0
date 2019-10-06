Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6F2CD741
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfJFRya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbfJFRy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2875522478;
        Sun,  6 Oct 2019 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383992;
        bh=xXalf5xqeX1/i6O/O50rC1iTJLzLihvL1a3MH8qpFyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2ikIAyrdlUGkuyxuwzPJPcZzPUSTQoBd/3rCOytCcqBxrOwTDj0g6gWsa52VMKlv
         gHABzYTrbqtCBPTwFedydmI4jLx9rfffwGhtwDU4z5/tWwDWYedWY3IbbGQuO1Ea1K
         moFVNRat/2An1aZRy0312AZJEQt3J+PzNpDhkIOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 135/166] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
Date:   Sun,  6 Oct 2019 19:21:41 +0200
Message-Id: <20191006171224.523399591@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 68ce6688a5baefde30914fc07fc27292dbbe8320 ]

The speed divisor is used in a context expecting an s64, but it is
evaluated using 32-bit arithmetic.

To avoid that happening, instead of multiplying by 1,000,000 in the
first place, simplify the fraction and do a standard 32 bit division
instead.

Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -965,8 +965,7 @@ static void taprio_set_picos_per_byte(st
 		speed = ecmd.base.speed;
 
 skip:
-	picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
-				   speed * 1000 * 1000);
+	picos_per_byte = (USEC_PER_SEC * 8) / speed;
 
 	atomic64_set(&q->picos_per_byte, picos_per_byte);
 	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",


