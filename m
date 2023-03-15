Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826886BB216
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjCOMcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjCOMcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C635A18C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D534B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88974C433D2;
        Wed, 15 Mar 2023 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883501;
        bh=ce9CHtg3M/RaWr7G3yLDOOz/kBfNVARFASuA9T2J9ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCgK6jljMKeXllIPKX0F1rcLDCeHKBR0sk49EOu2goZqVlSuTUNPvkTVLu1i1RAIA
         fjefPniZYu7LD5V+yMoP8UFVBl/gFHJAlipD4nMErOw0NH/lJC4IZBJIBSOhkkmGJD
         ca2agul0yyYBWVH39CQHRDlWq5e8BeuQ5+TZ8Ji8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Jones <lee@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.1 023/143] HID: core: Provide new max_buffer_size attribute to over-ride the default
Date:   Wed, 15 Mar 2023 13:11:49 +0100
Message-Id: <20230315115741.211653308@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |   32 +++++++++++++++++++++++++-------
 include/linux/hid.h    |    3 +++
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -261,6 +261,7 @@ static int hid_add_field(struct hid_pars
 {
 	struct hid_report *report;
 	struct hid_field *field;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int usages;
 	unsigned int offset;
 	unsigned int i;
@@ -291,8 +292,11 @@ static int hid_add_field(struct hid_pars
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
@@ -1966,6 +1970,7 @@ int hid_report_raw_event(struct hid_devi
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
 	int ret = 0;
@@ -1981,10 +1986,13 @@ int hid_report_raw_event(struct hid_devi
 
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
@@ -2387,7 +2395,12 @@ int hid_hw_raw_request(struct hid_device
 		       unsigned char reportnum, __u8 *buf,
 		       size_t len, enum hid_report_type rtype, enum hid_class_request reqtype)
 {
-	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
+
+	if (hdev->ll_driver->max_buffer_size)
+		max_buffer_size = hdev->ll_driver->max_buffer_size;
+
+	if (len < 1 || len > max_buffer_size || !buf)
 		return -EINVAL;
 
 	return hdev->ll_driver->raw_request(hdev, reportnum, buf, len,
@@ -2406,7 +2419,12 @@ EXPORT_SYMBOL_GPL(hid_hw_raw_request);
  */
 int hid_hw_output_report(struct hid_device *hdev, __u8 *buf, size_t len)
 {
-	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
+
+	if (hdev->ll_driver->max_buffer_size)
+		max_buffer_size = hdev->ll_driver->max_buffer_size;
+
+	if (len < 1 || len > max_buffer_size || !buf)
 		return -EINVAL;
 
 	if (hdev->ll_driver->output_report)
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -827,6 +827,7 @@ struct hid_driver {
  * @output_report: send output report to device
  * @idle: send idle request to device
  * @may_wakeup: return if device may act as a wakeup source during system-suspend
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -852,6 +853,8 @@ struct hid_ll_driver {
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 	bool (*may_wakeup)(struct hid_device *hdev);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;


