Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D521EAAB8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgFASKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731017AbgFASKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB26F2065C;
        Mon,  1 Jun 2020 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035044;
        bh=LMa7nr4zO0zeZVtYMjtumHTenenqBEXAoybZsjOD7wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a1LdZibt0kAsVsWjN9d38bmCdjnu6SeVC7aGfCYuHaMaHIP8Z6Q/Oz/GhP1/q7o3J
         Pr2637GkVqaYBlwUGSazUxaNwwI6JpKSh11EyMRFfsD6G2YDT6r0Uf9ih2ztnNQfY6
         CGz2ZA2Y4IMkT9+EvsLoMjoWqsaBmZYbxnRZwB7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijayendra Suman <vijayendra.suman@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 127/142] bnxt_en: Fix accumulation of bp->net_stats_prev.
Date:   Mon,  1 Jun 2020 19:54:45 +0200
Message-Id: <20200601174050.940067130@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit b8056e8434b037fdab08158fea99ed7bc8ef3a74 upstream.

We have logic to maintain network counters across resets by storing
the counters in bp->net_stats_prev before reset.  But not all resets
will clear the counters.  Certain resets that don't need to change
the number of rings do not clear the counters.  The current logic
accumulates the counters before all resets, causing big jumps in
the counters after some resets, such as ethtool -G.

Fix it by only accumulating the counters during reset if the irq_re_init
parameter is set.  The parameter signifies that all rings and interrupts
will be reset and that means that the counters will also be reset.

Reported-by: Vijayendra Suman <vijayendra.suman@oracle.com>
Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9285,7 +9285,7 @@ static void __bnxt_close_nic(struct bnxt
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
-	if (bp->bnapi)
+	if (bp->bnapi && irq_re_init)
 		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
 	if (irq_re_init) {
 		bnxt_free_irq(bp);


