Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81CA3429AF
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 02:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhCTBpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 21:45:32 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:48399 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhCTBpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 21:45:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0USf-dtz_1616204693;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0USf-dtz_1616204693)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Mar 2021 09:45:06 +0800
From:   Wen Yang <simon.wy@alibaba-inc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9] ixgbe: prevent ptp_rx_hang from running when in FILTER_ALL mode
Date:   Sat, 20 Mar 2021 09:44:51 +0800
Message-Id: <20210320014451.36599-1-simon.wy@alibaba-inc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

commit 6704a3abf4cf4181a1ee64f5db4969347b88ca1d upstream.

On hardware which supports timestamping all packets, the timestamps are
recorded in the packet buffer, and the driver no longer uses or reads
the registers. This makes the logic for checking and clearing Rx
timestamp hangs meaningless.

If we run the ixgbe_ptp_rx_hang() function in this case, then the driver
will continuously spam the log output with "Clearing Rx timestamp hang".
These messages are spurious, and confusing to end users.

The original code in commit a9763f3cb54c ("ixgbe: Update PTP to support
X550EM_x devices", 2015-12-03) did have a flag PTP_RX_TIMESTAMP_IN_REGISTER
which was intended to be used to avoid the Rx timestamp hang check,
however it did not actually check the flag before calling the function.

Do so now in order to stop the checks and prevent the spurious log
messages.

Fixes: a9763f3cb54c ("ixgbe: Update PTP to support X550EM_x devices", 2015-12-03)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: <stable@vger.kernel.org> # 4.9.x: 622a2ef538fb: ixgbe: check for Tx timestamp timeouts during watchdog
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 66b1cc02..36d73bf 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7257,7 +7257,8 @@ static void ixgbe_service_task(struct work_struct *work)
 
 	if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state)) {
 		ixgbe_ptp_overflow_check(adapter);
-		ixgbe_ptp_rx_hang(adapter);
+		if (adapter->flags & IXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER)
+			ixgbe_ptp_rx_hang(adapter);
 		ixgbe_ptp_tx_hang(adapter);
 	}
 
-- 
1.8.3.1

