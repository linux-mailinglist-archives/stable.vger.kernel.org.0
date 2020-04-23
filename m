Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D198A1B68DE
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgDWXSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:18:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49042 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728277AbgDWXGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:38 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-0004fk-Qy; Fri, 24 Apr 2020 00:06:31 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvO-00E6ma-GR; Fri, 24 Apr 2020 00:06:30 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Jiri Kosina" <jkosina@suse.cz>
Date:   Fri, 24 Apr 2020 00:05:21 +0100
Message-ID: <lsq.1587683028.902216420@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 094/245] HID: Fix slab-out-of-bounds read in
 hid_field_extract
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 8ec321e96e056de84022c032ffea253431a83c3c upstream.

The syzbot fuzzer found a slab-out-of-bounds bug in the HID report
handler.  The bug was caused by a report descriptor which included a
field with size 12 bits and count 4899, for a total size of 7349
bytes.

The usbhid driver uses at most a single-page 4-KB buffer for reports.
In the test there wasn't any problem about overflowing the buffer,
since only one byte was received from the device.  Rather, the bug
occurred when the HID core tried to extract the data from the report
fields, which caused it to try reading data beyond the end of the
allocated buffer.

This patch fixes the problem by rejecting any report whose total
length exceeds the HID_MAX_BUFFER_SIZE limit (minus one byte to allow
for a possible report index).  In theory a device could have a report
longer than that, but if there was such a thing we wouldn't handle it
correctly anyway.

Reported-and-tested-by: syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -248,6 +248,12 @@ static int hid_add_field(struct hid_pars
 	offset = report->size;
 	report->size += parser->global.report_size * parser->global.report_count;
 
+	/* Total size check: Allow for possible report index byte */
+	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+		hid_err(parser->device, "report is too long\n");
+		return -1;
+	}
+
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 

