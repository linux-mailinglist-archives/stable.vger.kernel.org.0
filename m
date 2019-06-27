Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4857E47
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 10:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfF0Ifg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 04:35:36 -0400
Received: from foss.arm.com ([217.140.110.172]:49230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0Iff (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 04:35:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 095982B;
        Thu, 27 Jun 2019 01:35:35 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79E733F706;
        Thu, 27 Jun 2019 01:35:32 -0700 (PDT)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        coresight@lists.linaro.org, stable@vger.kernel.org
Subject: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on enable/disable
Date:   Thu, 27 Jun 2019 09:35:22 +0100
Message-Id: <20190627083525.37463-3-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627083525.37463-1-andrew.murray@arm.com>
References: <20190627083525.37463-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Synchronization is recommended before disabling the trace registers
to prevent any start or stop points being speculative at the point
of disabling the unit (section 7.3.77 of ARM IHI 0064D).

Synchronization is also recommended after programming the trace
registers to ensure all updates are committed prior to normal code
resuming (section 4.3.7 of ARM IHI 0064D).

Let's ensure these syncronization points are present in the code
and clearly commented.

Note that we could rely on the barriers in CS_LOCK and
coresight_disclaim_device_unlocked or the context switch to user
space - however coresight may be of use in the kernel.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
CC: stable@vger.kernel.org
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index c89190d464ab..68e8e3954cef 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -188,6 +188,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		dev_err(etm_dev,
 			"timeout while waiting for Idle Trace Status\n");
 
+	/* As recommended by 4.3.7 of ARM IHI 0064D */
+	dsb(sy);
+	isb();
+
 done:
 	CS_LOCK(drvdata->base);
 
@@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
 	control &= ~0x1;
 
 	/* make sure everything completes before disabling */
-	mb();
+	/* As recommended by 7.3.77 of ARM IHI 0064D */
+	dsb(sy);
 	isb();
 	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
 
-- 
2.21.0

