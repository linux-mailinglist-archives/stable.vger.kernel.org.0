Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822222267C4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbgGTQO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388261AbgGTQO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066932064B;
        Mon, 20 Jul 2020 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261666;
        bh=MhT3uRynivrvhvXGvhtNUo8aL37u/AGUDgmW7cutRis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muG5N9A6k7qQ7jNbZVlchXS2Aw7/ju2ksSc7WRvgoQsvbTRXhyuXtXFrgR99REGUD
         sIE784zydILsWbP9M2QyOdwjEHEn3QcBc58Gm1KxSQSB4rGkYpk6cvkmzo3xku10bJ
         M0k21mobqGgpkQQDLPpIWZtn20RWyKNzmBO7PTOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.7 198/244] hwmon: (drivetemp) Avoid SCT usage on Toshiba DT01ACA family drives
Date:   Mon, 20 Jul 2020 17:37:49 +0200
Message-Id: <20200720152835.263483439@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

commit c66ef39eb27fe123ee05082b90eb2985c33c7715 upstream.

It has been observed that Toshiba DT01ACA family drives have
WRITE FPDMA QUEUED command timeouts and sometimes just freeze until
power-cycled under heavy write loads when their temperature is getting
polled in SCT mode. The SMART mode seems to be fine, though.

Let's make sure we don't use SCT mode for these drives then.

While only the 3 TB model was actually caught exhibiting the problem let's
play safe here to avoid data corruption and extend the ban to the whole
family.

Fixes: 5b46903d8bf3 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://lore.kernel.org/r/0cb2e7022b66c6d21d3f189a12a97878d0e7511b.1595075458.git.mail@maciej.szmigiero.name
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/drivetemp.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -285,6 +285,42 @@ static int drivetemp_get_scttemp(struct
 	return err;
 }
 
+static const char * const sct_avoid_models[] = {
+/*
+ * These drives will have WRITE FPDMA QUEUED command timeouts and sometimes just
+ * freeze until power-cycled under heavy write loads when their temperature is
+ * getting polled in SCT mode. The SMART mode seems to be fine, though.
+ *
+ * While only the 3 TB model (DT01ACA3) was actually caught exhibiting the
+ * problem let's play safe here to avoid data corruption and ban the whole
+ * DT01ACAx family.
+
+ * The models from this array are prefix-matched.
+ */
+	"TOSHIBA DT01ACA",
+};
+
+static bool drivetemp_sct_avoid(struct drivetemp_data *st)
+{
+	struct scsi_device *sdev = st->sdev;
+	unsigned int ctr;
+
+	if (!sdev->model)
+		return false;
+
+	/*
+	 * The "model" field contains just the raw SCSI INQUIRY response
+	 * "product identification" field, which has a width of 16 bytes.
+	 * This field is space-filled, but is NOT NULL-terminated.
+	 */
+	for (ctr = 0; ctr < ARRAY_SIZE(sct_avoid_models); ctr++)
+		if (!strncmp(sdev->model, sct_avoid_models[ctr],
+			     strlen(sct_avoid_models[ctr])))
+			return true;
+
+	return false;
+}
+
 static int drivetemp_identify_sata(struct drivetemp_data *st)
 {
 	struct scsi_device *sdev = st->sdev;
@@ -326,6 +362,13 @@ static int drivetemp_identify_sata(struc
 	/* bail out if this is not a SATA device */
 	if (!is_ata || !is_sata)
 		return -ENODEV;
+
+	if (have_sct && drivetemp_sct_avoid(st)) {
+		dev_notice(&sdev->sdev_gendev,
+			   "will avoid using SCT for temperature monitoring\n");
+		have_sct = false;
+	}
+
 	if (!have_sct)
 		goto skip_sct;
 


