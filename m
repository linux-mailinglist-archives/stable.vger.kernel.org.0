Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9602F6C12A0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCTNFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCTNFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F1F18B3C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240E9614DA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA78C4339C;
        Mon, 20 Mar 2023 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317544;
        bh=W43j5evAxbRzp+5Ve/V8Jf0xjL0cf+kfp9ty/eD8YpM=;
        h=From:To:Cc:Subject:Date:From;
        b=G5QYqYqzodYsqOLFwJevEpJF2gbmfIKiAmPq2tk6OY4Za+3+fcAJ3CNV5YFCCI5QD
         2UA8/blGY69VUMaeOeR7Rfv51XNzh0OVWpaFKBaqPsdUtk38FlGqrI/sS9j3KueYJU
         H0Fah32y7c86NgEZb7Scuw7ezq7DaKvZ2J7+Zdz0uSo3vJRJTtJm2X9I3LQeZj6gUs
         xmISz2y/4+zKiP6GHLqh8V7HLpnL/USeCUgFGwR7UIsqLGEK0VunIUEts0ofmBzeOt
         H7aN2SlWjsL28Hbbu3tdzMAnFNOnfA0RHVoUuiGg3aDt8j5GCIODFiiNFmjZ+lozAE
         +cWMoIZ4ZUQFQ==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5.15.y 1/2] HID: core: Provide new max_buffer_size attribute to over-ride the default
Date:   Mon, 20 Mar 2023 13:05:34 +0000
Message-Id: <20230320130535.2769860-1-lee@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b1a37ed00d7908a991c1d0f18a8cba3c2aa99bdc upstream.

Presently, when a report is processed, its proposed size, provided by
the user of the API (as Report Size * Report Count) is compared against
the subsystem default HID_MAX_BUFFER_SIZE (16k).  However, some
low-level HID drivers allocate a reduced amount of memory to their
buffers (e.g. UHID only allocates UHID_DATA_MAX (4k) buffers), rending
this check inadequate in some cases.

In these circumstances, if the received report ends up being smaller
than the proposed report size, the remainder of the buffer is zeroed.
That is, the space between sizeof(csize) (size of the current report)
and the rsize (size proposed i.e. Report Size * Report Count), which can
be handled up to HID_MAX_BUFFER_SIZE (16k).  Meaning that memset()
shoots straight past the end of the buffer boundary and starts zeroing
out in-use values, often resulting in calamity.

This patch introduces a new variable into 'struct hid_ll_driver' where
individual low-level drivers can over-ride the default maximum value of
HID_MAX_BUFFER_SIZE (16k) with something more sympathetic to the
interface.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Lee: Backported to v5.15.y]
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/hid/hid-core.c | 18 +++++++++++++-----
 include/linux/hid.h    |  3 +++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f1ea883db5de1..d941023c56289 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -258,6 +258,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int usages;
 	unsigned int offset;
 	unsigned int i;
@@ -288,8 +289,11 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	offset = report->size;
 	report->size += parser->global.report_size * parser->global.report_count;
 
+	if (parser->device->ll_driver->max_buffer_size)
+		max_buffer_size = parser->device->ll_driver->max_buffer_size;
+
 	/* Total size check: Allow for possible report index byte */
-	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+	if (report->size > (max_buffer_size - 1) << 3) {
 		hid_err(parser->device, "report is too long\n");
 		return -1;
 	}
@@ -1752,6 +1756,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int a;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
@@ -1768,10 +1773,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 
 	rsize = hid_compute_report_size(report);
 
-	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE - 1;
-	else if (rsize > HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE;
+	if (hid->ll_driver->max_buffer_size)
+		max_buffer_size = hid->ll_driver->max_buffer_size;
+
+	if (report_enum->numbered && rsize >= max_buffer_size)
+		rsize = max_buffer_size - 1;
+	else if (rsize > max_buffer_size)
+		rsize = max_buffer_size;
 
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 3cfbffd94a058..c3478e396829e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -805,6 +805,7 @@ struct hid_driver {
  * @output_report: send output report to device
  * @idle: send idle request to device
  * @may_wakeup: return if device may act as a wakeup source during system-suspend
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -830,6 +831,8 @@ struct hid_ll_driver {
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 	bool (*may_wakeup)(struct hid_device *hdev);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
-- 
2.40.0.rc1.284.g88254d51c5-goog

