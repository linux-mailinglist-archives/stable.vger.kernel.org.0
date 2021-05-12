Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FF37C29F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhELPMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhELPKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EAB661625;
        Wed, 12 May 2021 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831768;
        bh=4dwgm3xfLZguM+2AWdkjMOegsdcI4gRWhodO1Lt6W9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWFXEYIfUUQKlWTbyTdhnpw9Irj2B6Xoc3VUeR7Gp2J5JyDaUeMbIwb8ilnhNrVMa
         f5IKLEtE5Xk5EuJ2VO1rQTQqN4qCpNsLd1O2Tu4c7f9OgHb8ZYx4EHosuhJkLMWVdR
         o+bmaAOT8ZqaqiV/+dbFu0NLnV5akN3WKJl7Fto8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/244] bnxt_en: Fix RX consumer index logic in the error path.
Date:   Wed, 12 May 2021 16:50:01 +0200
Message-Id: <20210512144750.365726835@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit bbd6f0a948139970f4a615dff189d9a503681a39 ]

In bnxt_rx_pkt(), the RX buffers are expected to complete in order.
If the RX consumer index indicates an out of order buffer completion,
it means we are hitting a hardware bug and the driver will abort all
remaining RX packets and reset the RX ring.  The RX consumer index
that we pass to bnxt_discard_rx() is not correct.  We should be
passing the current index (tmp_raw_cons) instead of the old index
(raw_cons).  This bug can cause us to be at the wrong index when
trying to abort the next RX packet.  It can crash like this:

 #0 [ffff9bbcdf5c39a8] machine_kexec at ffffffff9b05e007
 #1 [ffff9bbcdf5c3a00] __crash_kexec at ffffffff9b111232
 #2 [ffff9bbcdf5c3ad0] panic at ffffffff9b07d61e
 #3 [ffff9bbcdf5c3b50] oops_end at ffffffff9b030978
 #4 [ffff9bbcdf5c3b78] no_context at ffffffff9b06aaf0
 #5 [ffff9bbcdf5c3bd8] __bad_area_nosemaphore at ffffffff9b06ae2e
 #6 [ffff9bbcdf5c3c28] bad_area_nosemaphore at ffffffff9b06af24
 #7 [ffff9bbcdf5c3c38] __do_page_fault at ffffffff9b06b67e
 #8 [ffff9bbcdf5c3cb0] do_page_fault at ffffffff9b06bb12
 #9 [ffff9bbcdf5c3ce0] page_fault at ffffffff9bc015c5
    [exception RIP: bnxt_rx_pkt+237]
    RIP: ffffffffc0259cdd  RSP: ffff9bbcdf5c3d98  RFLAGS: 00010213
    RAX: 000000005dd8097f  RBX: ffff9ba4cb11b7e0  RCX: ffffa923cf6e9000
    RDX: 0000000000000fff  RSI: 0000000000000627  RDI: 0000000000001000
    RBP: ffff9bbcdf5c3e60   R8: 0000000000420003   R9: 000000000000020d
    R10: ffffa923cf6ec138  R11: ffff9bbcdf5c3e83  R12: ffff9ba4d6f928c0
    R13: ffff9ba4cac28080  R14: ffff9ba4cb11b7f0  R15: ffff9ba4d5a30000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

Fixes: a1b0e4e684e9 ("bnxt_en: Improve RX consumer index validity check.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 04386e4078de..588389697cf9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1728,12 +1728,14 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	cons = rxcmp->rx_cmp_opaque;
 	if (unlikely(cons != rxr->rx_next_cons)) {
-		int rc1 = bnxt_discard_rx(bp, cpr, raw_cons, rxcmp);
+		int rc1 = bnxt_discard_rx(bp, cpr, &tmp_raw_cons, rxcmp);
 
 		netdev_warn(bp->dev, "RX cons %x != expected cons %x\n",
 			    cons, rxr->rx_next_cons);
 		bnxt_sched_reset(bp, rxr);
-		return rc1;
+		if (rc1)
+			return rc1;
+		goto next_rx_no_prod_no_len;
 	}
 	rx_buf = &rxr->rx_buf_ring[cons];
 	data = rx_buf->data;
-- 
2.30.2



