Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56437103FD6
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfKTPkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52498 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729304AbfKTPkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:14 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004YL-7D; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5S-0004Ff-H2; Wed, 20 Nov 2019 15:40:10 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "ShihPo Hung" <shihpo.hung@sifive.com>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Andreas Koop" <andreas.koop@zf.com>
Date:   Wed, 20 Nov 2019 15:37:13 +0000
Message-ID: <lsq.1574264230.360257605@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/83] mmc: mmc_spi: Enable stable writes
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Koop <andreas.koop@zf.com>

commit 3a6ffb3c8c3274a39dc8f2514526e645c5d21753 upstream.

While using the mmc_spi driver occasionally errors like this popped up:

mmcblk0: error -84 transferring data end_request: I/O error, dev mmcblk0, sector 581756

I looked on the Internet for occurrences of the same problem and came
across a helpful post [1]. It includes source code to reproduce the bug.
There is also an analysis about the cause. During transmission data in the
supplied buffer is being modified. Thus the previously calculated checksum
is not correct anymore.

After some digging I found out that device drivers are supposed to report
they need stable writes. To fix this I set the appropriate flag at queue
initialization if CRC checksumming is enabled for that SPI host.

[1]
https://groups.google.com/forum/#!msg/sim1/gLlzWeXGFr8/KevXinUXfc8J

Signed-off-by: Andreas Koop <andreas.koop@zf.com>
[shihpo: Rebase on top of v5.3-rc1]
Signed-off-by: ShihPo Hung <shihpo.hung@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[bwh: Backported to 3.16:
 - request_queue::backing_dev_info is a struct not a pointer
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/card/queue.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -204,6 +205,10 @@ int mmc_init_queue(struct mmc_queue *mq,
 	if (!mq->queue)
 		return -ENOMEM;
 
+	if (mmc_host_is_spi(host) && host->use_spi_crc)
+		mq->queue->backing_dev_info.capabilities |=
+			BDI_CAP_STABLE_WRITES;
+
 	mq->mqrq_cur = mqrq_cur;
 	mq->mqrq_prev = mqrq_prev;
 	mq->queue->queuedata = mq;

