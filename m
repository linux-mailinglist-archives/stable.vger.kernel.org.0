Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9357F125E6E
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 11:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLSKDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 05:03:12 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:39638 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 05:03:12 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id xBJA2wCa007981; Thu, 19 Dec 2019 19:02:58 +0900
X-Iguazu-Qid: 34truqWIwMNSm1hbsZ
X-Iguazu-QSIG: v=2; s=0; t=1576749777; q=34truqWIwMNSm1hbsZ; m=XCcMxZqtfJrKC41q7XPcsasib3nSIcc13MPBFfTkNA4=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1510) id xBJA2ugq027120;
        Thu, 19 Dec 2019 19:02:57 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBJA2uLO002913;
        Thu, 19 Dec 2019 19:02:56 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBJA2te1006799;
        Thu, 19 Dec 2019 19:02:56 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     linux-serial@vger.kernel.org
Cc:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, shrirang.bagul@canonical.com,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Johan Hovold <johan@kernel.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] serdev: Don't claim unsupported ACPI serial devices
Date:   Thu, 19 Dec 2019 19:03:45 +0900
X-TSB-HOP: ON
Message-Id: <20191219100345.911093-1-punit1.agrawal@toshiba.co.jp>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Serdev sub-system claims all ACPI serial devices that are not already
initialised. As a result, no device node is created for serial ports
on certain boards such as the Apollo Lake based UP2. This has the
unintended consequence of not being able to raise the login prompt via
serial connection.

Introduce a blacklist to reject ACPI serial devices that should not be
claimed by serdev sub-system. Add the peripheral ids for Intel HS UART
to the blacklist to bring back serial port on SoCs carrying them.

Cc: stable@vger.kernel.org
Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Johan Hovold <johan@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Hi Greg,

I've updated the patch to tighten the commit log and code identifier
to be more ACPI specific.

Thanks,
Punit

Changelog

* Update commit log to refer to ACPI serial devices
* Update identifier to be ACPI specific
* Space around peripheral Ids

Previous versions

[0] https://www.spinics.net/lists/kernel/msg3348136.html
[1] https://lkml.org/lkml/2019/12/18/42

 drivers/tty/serdev/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 226adeec2aed..ce5309d00280 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
 	return AE_OK;
 }
 
+static const struct acpi_device_id serdev_acpi_devices_blacklist[] = {
+	{ "INT3511", 0 },
+	{ "INT3512", 0 },
+	{ },
+};
+
 static acpi_status acpi_serdev_add_device(acpi_handle handle, u32 level,
 					  void *data, void **return_value)
 {
@@ -675,6 +681,10 @@ static acpi_status acpi_serdev_add_device(acpi_handle handle, u32 level,
 	if (acpi_device_enumerated(adev))
 		return AE_OK;
 
+	/* Skip if black listed */
+	if (!acpi_match_device_ids(adev, serdev_acpi_devices_blacklist))
+		return AE_OK;
+
 	if (acpi_serdev_check_resources(ctrl, adev))
 		return AE_OK;
 
-- 
2.24.0

