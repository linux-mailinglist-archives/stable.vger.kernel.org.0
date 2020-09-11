Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F52666FB
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgIKRgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgIKMxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:53:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB9620758;
        Fri, 11 Sep 2020 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828793;
        bh=3TUk0QMmGSrbMIZSTi77zDVjfJg52osVKczki7C3fyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pl6Q6ZDxPAg6RyTKOYfJm9FJUs0Vn3EyHU6+B/EyR4xJd6ktw25co+plSIVapsjkC
         FXmQ2cBAEuFKdIXJZaKKm2ZSZjj61fFSPAFJS9K3qmCZBC9uIE5AwNuWJ2e0FogFxL
         OZu1cgJ9DI2+2ExRVb3fJ2vLIJ/SNwoeft0Wwuso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 4.4 01/62] HID: core: Correctly handle ReportSize being zero
Date:   Fri, 11 Sep 2020 14:45:44 +0200
Message-Id: <20200911122502.469937711@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
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
@@ -1368,6 +1368,17 @@ static void hid_output_field(const struc
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
@@ -1379,7 +1390,7 @@ void hid_output_report(struct hid_report
 	if (report->id > 0)
 		*data++ = report->id;
 
-	memset(data, 0, ((report->size - 1) >> 3) + 1);
+	memset(data, 0, hid_compute_report_size(report));
 	for (n = 0; n < report->maxfield; n++)
 		hid_output_field(report->device, report->field[n], data);
 }
@@ -1506,7 +1517,7 @@ int hid_report_raw_event(struct hid_devi
 		csize--;
 	}
 
-	rsize = ((report->size - 1) >> 3) + 1;
+	rsize = hid_compute_report_size(report);
 
 	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
 		rsize = HID_MAX_BUFFER_SIZE - 1;


