Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5B42618FF
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbgIHSFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731524AbgIHQMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DDF2478B;
        Tue,  8 Sep 2020 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580272;
        bh=5zwf0lJoGSus3xa+k3O/lcGB+3+GBcqvPyP2gBB40vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImssrnECkxG1lQ+23UwetayfVqhCm3GzgDx+10sjC09kWBPpUnXVvWa0YldE3pkn7
         YbWAJkOrQevzg6IF8n5c7p38jbp6R7SAJMKGCAZU2rZobuIzfDRIVWSdJehzyHqmpi
         Z9tG6H2ezRbz92MD1YccH/eekpddnSb/Og2b4lZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 4.14 01/65] HID: core: Correctly handle ReportSize being zero
Date:   Tue,  8 Sep 2020 17:25:46 +0200
Message-Id: <20200908152217.094197289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit bce1305c0ece3dc549663605e567655dd701752c upstream.

It appears that a ReportSize value of zero is legal, even if a bit
non-sensical. Most of the HID code seems to handle that gracefully,
except when computing the total size in bytes. When fed as input to
memset, this leads to some funky outcomes.

Detect the corner case and correctly compute the size.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1427,6 +1427,17 @@ static void hid_output_field(const struc
 }
 
 /*
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
+/*
  * Create a report. 'data' has to be allocated using
  * hid_alloc_report_buf() so that it has proper size.
  */
@@ -1438,7 +1449,7 @@ void hid_output_report(struct hid_report
 	if (report->id > 0)
 		*data++ = report->id;
 
-	memset(data, 0, ((report->size - 1) >> 3) + 1);
+	memset(data, 0, hid_compute_report_size(report));
 	for (n = 0; n < report->maxfield; n++)
 		hid_output_field(report->device, report->field[n], data);
 }
@@ -1565,7 +1576,7 @@ int hid_report_raw_event(struct hid_devi
 		csize--;
 	}
 
-	rsize = ((report->size - 1) >> 3) + 1;
+	rsize = hid_compute_report_size(report);
 
 	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
 		rsize = HID_MAX_BUFFER_SIZE - 1;


