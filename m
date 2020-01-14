Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773CC13A633
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgANKKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731575AbgANKKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:10:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E98207FF;
        Tue, 14 Jan 2020 10:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996604;
        bh=SHPsJWplU4upQPPHc+t5m2MHuAEbIWet61KD0ZWDA7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APC9WSl4YEizaRNrg+OMhj/2B229+xhPDup1GK7SlptIDh61P3ZU99utV5nzKatNk
         TB5XdL7KVOip/UkuPwby39BGIF4H7qRBU3pk1yfUNISgeFzhmrUrKqVO3uJ+kqchk3
         3Z3+LHIr14ZXHfeGL3uMCOIKKbSvWoQsVwa8DQhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jkosina@suse.cz>,
        syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com
Subject: [PATCH 4.14 08/39] HID: Fix slab-out-of-bounds read in hid_field_extract
Date:   Tue, 14 Jan 2020 11:01:42 +0100
Message-Id: <20200114094341.044310674@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.210038037@linuxfoundation.org>
References: <20200114094336.210038037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -268,6 +268,12 @@ static int hid_add_field(struct hid_pars
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
 


