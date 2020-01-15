Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2BF13C19B
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgAOMs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:48:27 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39331 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgAOMs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 07:48:26 -0500
Received: from cobaltpc1.rd.cisco.com
 ([IPv6:2001:420:44c1:2577:18d8:d5d6:4408:6200])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ri5riEH6BT6sRri5wiaE9x; Wed, 15 Jan 2020 13:48:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1579092504; bh=Iu1ikL9oMVTEbQXYlG9XJ+78XXDhr0SKQ2Yb+u9kv7E=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:From:Subject;
        b=U80pPzOhgMJ46Y5ggskl2JK4Yi16ktMFnMgCzrqZwaPMGOBC1TFfJk/Hxun11/d0Z
         kowkT2fhwe7Nl56vYzmRaW2QkbyXWG7NryzowXKqh2p5wEkjLIv+xHViV3HEXZuPpy
         lPF82V5nYNn3XT1hSnkEOMRG92Uz3y4iv4rVEdUW6BBIe1ARF2bOEhWnmLbiYNrPCn
         2ezYrAt+7GUBoLtBMxbfzA1uAacH2Ad86uaS1qZ86qMdsDzHUN8ZPX67hj7FHtjyW3
         Q2cXL7Mtq55TmNrKGKo6zaxrbCecjxkhJZf0bKeDDtzgqLe+TC7iy4rMvb+6vW+HJ3
         z3gpRzouF/A7Q==
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Timo Kaufmann <timokau@zoho.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH for v5.5 2/2] Input: rmi_f54: read from FIFO in 32 byte blocks
Date:   Wed, 15 Jan 2020 13:48:19 +0100
Message-Id: <20200115124819.3191024-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
References: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfCrwfkwhmKthDssy6WLiJ5HPIAldwwLU4BHSNjMRxnK9CCQEWscB0QLHf0bk+1tXNv/a1JENJ2ggRjBDlrHMXnfbd44jibhtgIPXr4cQufBuHALzgnTj
 1I8AGYBkSf/JPJ9lrSx6Cf39xY5+SqUcsWvFAj0Jz785E9g5tnoUqOVAdTxc+4jGSBPaFZhjWW+RSZv0ClAvZ90nJH2AoTlAHId11SZev1oeE4/Q9yGySH/K
 5bQh/4pnUzDA+md66dE8MklYl9p44P+SeD16Sy+UC9Zc2rdDRNXPPfedrTHwNlMe805waKOY+4+8UYvszqHISfwA3JTPxSyyXP3O6KTWCHK2wubTAllXdnbl
 0R/Q+x1wGQj0Q8+Ed1o//nnqIM3dHvY1MzbQwaXpGGeXVdXw0Q6sEXEfja1S5GDpYw0l871n37vaWiDlynB1fvDc1yN0dQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The F54 Report Data is apparently read through a fifo and for
the smbus protocol that means that between reading a block of 32
bytes the rmiaddr shouldn't be incremented. However, changing
that causes other non-fifo reads to fail and so that change was
reverted.

This patch changes just the F54 function and it now reads 32 bytes
at a time from the fifo, using the F54_FIFO_OFFSET to update the
start address that is used when reading from the fifo.

This has only been tested with smbus, not with i2c or spi. But I
suspect that the same is needed there since I think similar
problems will occur there when reading more than 256 bytes.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Timo Kaufmann <timokau@zoho.com>
Fixes: a284e11c371e ("Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers")
Cc: stable@vger.kernel.org
---
 drivers/input/rmi4/rmi_f54.c | 43 ++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
index 0bc01cfc2b51..6b23e679606e 100644
--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -24,6 +24,12 @@
 #define F54_NUM_TX_OFFSET       1
 #define F54_NUM_RX_OFFSET       0
 
+/*
+ * The smbus protocol can read only 32 bytes max at a time.
+ * But this should be fine for i2c/spi as well.
+ */
+#define F54_REPORT_DATA_SIZE	32
+
 /* F54 commands */
 #define F54_GET_REPORT          1
 #define F54_FORCE_CAL           2
@@ -526,6 +532,7 @@ static void rmi_f54_work(struct work_struct *work)
 	int report_size;
 	u8 command;
 	int error;
+	int i;
 
 	report_size = rmi_f54_get_report_size(f54);
 	if (report_size == 0) {
@@ -558,23 +565,27 @@ static void rmi_f54_work(struct work_struct *work)
 
 	rmi_dbg(RMI_DEBUG_FN, &fn->dev, "Get report command completed, reading data\n");
 
-	fifo[0] = 0;
-	fifo[1] = 0;
-	error = rmi_write_block(fn->rmi_dev,
-				fn->fd.data_base_addr + F54_FIFO_OFFSET,
-				fifo, sizeof(fifo));
-	if (error) {
-		dev_err(&fn->dev, "Failed to set fifo start offset\n");
-		goto abort;
-	}
+	for (i = 0; i < report_size; i += F54_REPORT_DATA_SIZE) {
+		int size = min(F54_REPORT_DATA_SIZE, report_size - i);
+
+		fifo[0] = i & 0xff;
+		fifo[1] = i >> 8;
+		error = rmi_write_block(fn->rmi_dev,
+					fn->fd.data_base_addr + F54_FIFO_OFFSET,
+					fifo, sizeof(fifo));
+		if (error) {
+			dev_err(&fn->dev, "Failed to set fifo start offset\n");
+			goto abort;
+		}
 
-	error = rmi_read_block(fn->rmi_dev, fn->fd.data_base_addr +
-			       F54_REPORT_DATA_OFFSET, f54->report_data,
-			       report_size);
-	if (error) {
-		dev_err(&fn->dev, "%s: read [%d bytes] returned %d\n",
-			__func__, report_size, error);
-		goto abort;
+		error = rmi_read_block(fn->rmi_dev, fn->fd.data_base_addr +
+				       F54_REPORT_DATA_OFFSET,
+				       f54->report_data + i, size);
+		if (error) {
+			dev_err(&fn->dev, "%s: read [%d bytes] returned %d\n",
+				__func__, size, error);
+			goto abort;
+		}
 	}
 
 abort:
-- 
2.24.0

