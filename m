Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4832C616AB
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfGGTlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57844 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727645AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006k7-8V; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005fx-3Z; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jack Morgenstein" <jackm@dev.mellanox.co.il>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.957409944@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 118/129] net/mlx4_core: Fix qp mtt size calculation
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 8511a653e9250ef36b95803c375a7be0e2edb628 upstream.

Calculation of qp mtt size (in function mlx4_RST2INIT_wrapper)
ultimately depends on function roundup_pow_of_two.

If the amount of memory required by the QP is less than one page,
roundup_pow_of_two is called with argument zero.  In this case, the
roundup_pow_of_two result is undefined.

Calling roundup_pow_of_two with a zero argument resulted in the
following stack trace:

UBSAN: Undefined behaviour in ./include/linux/log2.h:61:13
shift exponent 64 is too large for 64-bit type 'long unsigned int'
CPU: 4 PID: 26939 Comm: rping Tainted: G OE 4.19.0-rc1
Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
Call Trace:
dump_stack+0x9a/0xeb
ubsan_epilogue+0x9/0x7c
__ubsan_handle_shift_out_of_bounds+0x254/0x29d
? __ubsan_handle_load_invalid_value+0x180/0x180
? debug_show_all_locks+0x310/0x310
? sched_clock+0x5/0x10
? sched_clock+0x5/0x10
? sched_clock_cpu+0x18/0x260
? find_held_lock+0x35/0x1e0
? mlx4_RST2INIT_QP_wrapper+0xfb1/0x1440 [mlx4_core]
mlx4_RST2INIT_QP_wrapper+0xfb1/0x1440 [mlx4_core]

Fix this by explicitly testing for zero, and returning one if the
argument is zero (assuming that the next higher power of 2 in this case
should be one).

Fixes: c82e9aa0a8bc ("mlx4_core: resource tracking for HCA resources used by guests")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -2460,13 +2460,13 @@ static int qp_get_mtt_size(struct mlx4_q
 	int total_pages;
 	int total_mem;
 	int page_offset = (be32_to_cpu(qpc->params2) >> 6) & 0x3f;
+	int tot;
 
 	sq_size = 1 << (log_sq_size + log_sq_sride + 4);
 	rq_size = (srq|rss|xrc) ? 0 : (1 << (log_rq_size + log_rq_stride + 4));
 	total_mem = sq_size + rq_size;
-	total_pages =
-		roundup_pow_of_two((total_mem + (page_offset << 6)) >>
-				   page_shift);
+	tot = (total_mem + (page_offset << 6)) >> page_shift;
+	total_pages = !tot ? 1 : roundup_pow_of_two(tot);
 
 	return total_pages;
 }

