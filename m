Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372ED157432
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBJMJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:09:57 -0500
Received: from seldsegrel01.sonyericsson.com ([37.139.156.29]:3529 "EHLO
        SELDSEGREL01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgBJMJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 07:09:57 -0500
From:   Peter Enderborg <peter.enderborg@sony.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Peter Enderborg <peter.enderborg@sony.com>
Subject: [PATCH] HID: Extend report buffer size
Date:   Mon, 10 Feb 2020 13:08:47 +0100
Message-ID: <20200210120847.31737-1-peter.enderborg@sony.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <Pine.LNX.4.44L0.2002071018580.3671-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.2002071018580.3671-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain
X-SEG-SpamProfiler-Analysis: v=2.3 cv=V88DLtvi c=1 sm=1 tr=0 a=T5MYTZSj1jWyQccoVcawfw==:117 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=l697ptgUJYAA:10 a=z6gsHLkEAAAA:8 a=0ZngROrHOgAAH7t2AUYA:9 a=d-OLMTCWyvARjPbQ-enb:22
X-SEG-SpamProfiler-Score: 0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the patch "HID: Fix slab-out-of-bounds read in hid_field_extract"
there added a check for buffer overruns. This made Elgato StreamDeck
to fail. This patch extend the buffer to 8192 to solve this. It also
adds a print of the requested length if it fails on this test.

Signed-off-by: Peter Enderborg <peter.enderborg@sony.com>
---
 drivers/hid/hid-core.c | 2 +-
 include/linux/hid.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 851fe54ea59e..28841219b3d2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -290,7 +290,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 
 	/* Total size check: Allow for possible report index byte */
 	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
-		hid_err(parser->device, "report is too long\n");
+		hid_err(parser->device, "report is too long (%d)\n", report->size);
 		return -1;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index cd41f209043f..875f71132b14 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -492,7 +492,7 @@ struct hid_report_enum {
 };
 
 #define HID_MIN_BUFFER_SIZE	64		/* make sure there is at least a packet size of space */
-#define HID_MAX_BUFFER_SIZE	4096		/* 4kb */
+#define HID_MAX_BUFFER_SIZE	8192		/* 8kb */
 #define HID_CONTROL_FIFO_SIZE	256		/* to init devices with >100 reports */
 #define HID_OUTPUT_FIFO_SIZE	64
 
-- 
2.17.1

