Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79CC3443DF
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhCVMzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232927AbhCVMxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93AC1619D7;
        Mon, 22 Mar 2021 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417218;
        bh=hpyCcmeIUttCmPHsOxNJuVhprNkteq2tMMcOf+MBk4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8oDgdSHgKUdA3+Duk08cOUeOKCLrdWaxM8UTXXowCPZUQ/mnyUMDZRWNwm9ybX2A
         RJH3guWEjJYgPqxMZp1O4UcMloCQER4KjOBhFKzZ7yLijkq6lV2WtjQhDf79t1DIya
         hfWldIAUC/5n6XauB5NOui9LM+J9c9qapFsdq2UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.9 06/25] ixgbe: prevent ptp_rx_hang from running when in FILTER_ALL mode
Date:   Mon, 22 Mar 2021 13:28:56 +0100
Message-Id: <20210322121920.606163398@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7257,7 +7257,8 @@ static void ixgbe_service_task(struct wo
 
 	if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state)) {
 		ixgbe_ptp_overflow_check(adapter);
-		ixgbe_ptp_rx_hang(adapter);
+		if (adapter->flags & IXGBE_FLAG_RX_HWTSTAMP_IN_REGISTER)
+			ixgbe_ptp_rx_hang(adapter);
 		ixgbe_ptp_tx_hang(adapter);
 	}
 


