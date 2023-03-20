Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4330B6C1616
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCTPCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjCTPB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF3E4696
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:58:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F7A6158A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC5C433EF;
        Mon, 20 Mar 2023 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324279;
        bh=A6z5jMj1lbIaCR00luTRPiATudjLCg2qCwzM/WqZcrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vOREbgbePuZESxh+cjtS5lFO8tx+jqhxg1JadZX85c6ryDRfClspQf316juH13Zu
         3q3sJJ6m1jCWFVdFuwZPmfYRIRPAI2mgCSsbk5GGHeSZKhgP49YEl64UDLMi0OC+DM
         xdVW6nCju7pUp3oiY9h74XbuZhayPc8DuuU79N6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, lee@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 29/30] HID: core: Provide new max_buffer_size attribute to over-ride the default
Date:   Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145421.339532208@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee@kernel.org>

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
[Lee: Backported to v4.14.y]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |   18 +++++++++++++-----
 include/linux/hid.h    |    3 +++
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -245,6 +245,7 @@ static int hid_add_field(struct hid_pars
 	unsigned usages;
 	unsigned offset;
 	unsigned i;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 
 	report = hid_register_report(parser->device, report_type, parser->global.report_id);
 	if (!report) {
@@ -268,8 +269,11 @@ static int hid_add_field(struct hid_pars
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
@@ -1568,6 +1572,7 @@ int hid_report_raw_event(struct hid_devi
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int a;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
@@ -1584,10 +1589,13 @@ int hid_report_raw_event(struct hid_devi
 
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
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -770,6 +770,7 @@ struct hid_driver {
  * @raw_request: send raw report request to device (e.g. feature report)
  * @output_report: send output report to device
  * @idle: send idle request to device
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -794,6 +795,8 @@ struct hid_ll_driver {
 	int (*output_report) (struct hid_device *hdev, __u8 *buf, size_t len);
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;


