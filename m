Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F97F6C12C7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCTNKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjCTNKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:10:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1678F970
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38407B80DD4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF674C433D2;
        Mon, 20 Mar 2023 13:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679317804;
        bh=hpEgOPcuOqnj+H2rFgViwTkTIjW+oIf14+bx2IzPplo=;
        h=From:To:Cc:Subject:Date:From;
        b=TDFPPzA9dSQZ3PAqNr2d0jA6saj+su2fQqZCQI9zzF9oGvYQMRqFXVnTBL3n2rZ+P
         Dkx5FqugjyvQrbZw4FOUUH31CShMQz+tTYt9Nx7oqd48ERrcQ3TqF6veYir8O9t3yq
         MjtVTxHFE/NesiC18TFvyuJbhPYs6qjiPpTPuyoIpRFFuXHASDqbZsKeeMIywn6Br5
         WaYvyYCj8ZCGXrVZqVTj8+pcesG/eOWeLs3i7yMZhgv2Db440viZ4VTT419pIrcOf3
         +PkpdLb8Sc+UUUO/dOo9s6qLvgFiCGzPkfqqlXzPCYo129HX+Txuulv6LWCLorykIm
         ZKb4c/33WRFfw==
From:   Lee Jones <lee@kernel.org>
To:     lee@kernel.org
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4.9.y 1/2] HID: core: Provide new max_buffer_size attribute to over-ride the default
Date:   Mon, 20 Mar 2023 13:09:56 +0000
Message-Id: <20230320130957.2772257-1-lee@kernel.org>
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
[Lee: Backported to v4.9.y]
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/hid/hid-core.c | 18 +++++++++++++-----
 include/linux/hid.h    |  3 +++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c5207ed5d65b1..b9e6c51173571 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -246,6 +246,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	unsigned usages;
 	unsigned offset;
 	unsigned i;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 
 	report = hid_register_report(parser->device, report_type, parser->global.report_id);
 	if (!report) {
@@ -269,8 +270,11 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
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
@@ -1548,6 +1552,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int a;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
@@ -1564,10 +1569,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 
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
index a07fa623fd0c2..be12e7d14c4a1 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -736,6 +736,7 @@ struct hid_driver {
  * @raw_request: send raw report request to device (e.g. feature report)
  * @output_report: send output report to device
  * @idle: send idle request to device
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -760,6 +761,8 @@ struct hid_ll_driver {
 	int (*output_report) (struct hid_device *hdev, __u8 *buf, size_t len);
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
-- 
2.40.0.rc1.284.g88254d51c5-goog

