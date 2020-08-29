Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC1256714
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 13:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgH2L27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 07:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgH2L2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Aug 2020 07:28:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D427F214DB;
        Sat, 29 Aug 2020 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598700369;
        bh=B9VCR1gc3mVExEe2V499pC1prwSxp/+jhKu43FvTLNU=;
        h=From:To:Cc:Subject:Date:From;
        b=zYwTfmnLzGYjYC7cBwL7UWSG8ImGKC3qfcDFucsRDuTTUP+MyQbSwuPojkS94jtBk
         mQsz9/czKDf45ZLMs/uyQ42zTe3k7muKVy41rHIhwzRi3k+fA6irRUjjL6fJKHwhLH
         v2NToLsTGTK2FN1AB+sRkSDYJA/BnetkQhQIJRPc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kByzm-007dRY-Ra; Sat, 29 Aug 2020 12:26:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@android.com
Subject: [PATCH] HID: core: Correctly handle ReportSize being zero
Date:   Sat, 29 Aug 2020 12:26:01 +0100
Message-Id: <20200829112601.1060527-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It appears that a ReportSize value of zero is legal, even if a bit
non-sensical. Most of the HID code seems to handle that gracefully,
except when computing the total size in bytes. When fed as input to
memset, this leads to some funky outcomes.

Detect the corner case and correctly compute the size.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/hid/hid-core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 359616e3efbb..d2ecc9c45255 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1597,6 +1597,17 @@ static void hid_output_field(const struct hid_device *hid,
 	}
 }
 
+/*
+ * Compute the size of a report.
+ */
+static size_t hid_compute_report_size(struct hid_report *report)
+{
+	if (report->size)
+		return ((report->size - 1) >> 3) + 1;
+
+	return 0;
+}
+
 /*
  * Create a report. 'data' has to be allocated using
  * hid_alloc_report_buf() so that it has proper size.
@@ -1609,7 +1620,7 @@ void hid_output_report(struct hid_report *report, __u8 *data)
 	if (report->id > 0)
 		*data++ = report->id;
 
-	memset(data, 0, ((report->size - 1) >> 3) + 1);
+	memset(data, 0, hid_compute_report_size(report));
 	for (n = 0; n < report->maxfield; n++)
 		hid_output_field(report->device, report->field[n], data);
 }
@@ -1739,7 +1750,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 		csize--;
 	}
 
-	rsize = ((report->size - 1) >> 3) + 1;
+	rsize = hid_compute_report_size(report);
 
 	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
 		rsize = HID_MAX_BUFFER_SIZE - 1;
-- 
2.27.0

