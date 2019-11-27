Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3D10BF96
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfK0Uia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfK0Ui2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:38:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0241215A5;
        Wed, 27 Nov 2019 20:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887108;
        bh=U/6tRCUAgN7vLtq1CMV91hKOfrocRssLaPKmD5mtqa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7XLWrcwbiLnCNYzq4Sw8RtNsriDXh9oyTh8QGk3ki0VCKtYxN2LixR6tJtEjvV9k
         6pmEmoe6ymfZA6XI6Ddpqyr9FWS2NCzmvarsNaR+ajK+0798UK6NES5DztkO8SM4AC
         cJX3qccXN7YtKG062jnxFee9CvKRBI4PRLUeLQfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 073/132] igb: shorten maximum PHC timecounter update interval
Date:   Wed, 27 Nov 2019 21:31:04 +0100
Message-Id: <20191127203007.942579295@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 094bf4d0e9657f6ea1ee3d7e07ce3970796949ce ]

The timecounter needs to be updated at least once per ~550 seconds in
order to avoid a 40-bit SYSTIM timestamp to be misinterpreted as an old
timestamp.

Since commit 500462a9d ("timers: Switch to a non-cascading wheel"),
scheduling of delayed work seems to be less accurate and a requested
delay of 540 seconds may actually be longer than 550 seconds. Shorten
the delay to 480 seconds to be sure the timecounter is updated in time.

This fixes an issue with HW timestamps on 82580/I350/I354 being off by
~1100 seconds for few seconds every ~9 minutes.

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index c44df87c38de2..5e65d8a78c3ed 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -65,9 +65,15 @@
  *
  * The 40 bit 82580 SYSTIM overflows every
  *   2^40 * 10^-9 /  60  = 18.3 minutes.
+ *
+ * SYSTIM is converted to real time using a timecounter. As
+ * timecounter_cyc2time() allows old timestamps, the timecounter
+ * needs to be updated at least once per half of the SYSTIM interval.
+ * Scheduling of delayed work is not very accurate, so we aim for 8
+ * minutes to be sure the actual interval is shorter than 9.16 minutes.
  */
 
-#define IGB_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 9)
+#define IGB_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 8)
 #define IGB_PTP_TX_TIMEOUT		(HZ * 15)
 #define INCPERIOD_82576			(1 << E1000_TIMINCA_16NS_SHIFT)
 #define INCVALUE_82576_MASK		((1 << E1000_TIMINCA_16NS_SHIFT) - 1)
-- 
2.20.1



