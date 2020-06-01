Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A8D1EAE04
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgFASFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbgFASFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557B0206E2;
        Mon,  1 Jun 2020 18:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034738;
        bh=rZ+XXj06rF9qqmD9r7wRrJJHXnVfRV6jDYnqFaLFJsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNx10S2k6P1xUW+uwLyuEtkqSM1D9s+PdSjGpa1N7iE9r0jXbtWYUikSkvUYq5dEh
         DGDeLGaBXlL1fp8ips4/UKcWPNO2rTdjaksS0a0og8C3zk+9W52y0iXhLUCINYBQ/c
         hcU3NBLvHRi77vzJ1fc94qqToqg4WoxV3UgCVans=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijayendra Suman <vijayendra.suman@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 88/95] bnxt_en: Fix accumulation of bp->net_stats_prev.
Date:   Mon,  1 Jun 2020 19:54:28 +0200
Message-Id: <20200601174033.889824361@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
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
@@ -7177,7 +7177,7 @@ static void __bnxt_close_nic(struct bnxt
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
-	if (bp->bnapi)
+	if (bp->bnapi && irq_re_init)
 		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
 	if (irq_re_init) {
 		bnxt_free_irq(bp);


