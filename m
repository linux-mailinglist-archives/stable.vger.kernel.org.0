Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19656124084
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 08:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRHrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 02:47:00 -0500
Received: from mo-csw-fb1516.securemx.jp ([210.130.202.172]:57830 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfLRHrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 02:47:00 -0500
X-Greylist: delayed 3042 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 02:46:58 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1516) id xBI6uI9h022198; Wed, 18 Dec 2019 15:56:18 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id xBI6u3N8003361; Wed, 18 Dec 2019 15:56:03 +0900
X-Iguazu-Qid: 34tKCtS7NXirWj8SRu
X-Iguazu-QSIG: v=2; s=0; t=1576652163; q=34tKCtS7NXirWj8SRu; m=KvLJg+ndWRx7gv1wyosUGxci+yrAV9a0iwKugus5RSg=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1513) id xBI6u2g7017814;
        Wed, 18 Dec 2019 15:56:02 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBI6u2cg024477;
        Wed, 18 Dec 2019 15:56:02 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBI6u1uQ000537;
        Wed, 18 Dec 2019 15:56:01 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     linux-serial@vger.kernel.org
Cc:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, shrirang.bagul@canonical.com,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] serdev: Don't claim unsupported serial devices
Date:   Wed, 18 Dec 2019 15:56:46 +0900
X-TSB-HOP: ON
Message-Id: <20191218065646.817493-1-punit1.agrawal@toshiba.co.jp>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Serdev sub-system claims all serial devices that are not already
enumerated. As a result, no device node is created for serial port on
certain boards such as the Apollo Lake based UP2. This has the
unintended consequence of not being able to raise the login prompt via
serial connection.

Introduce a blacklist to reject devices that should not be treated as
a serdev device. Add the Intel HS UART peripheral ids to the blacklist
to bring back serial port on SoCs carrying them.

Cc: stable@vger.kernel.org
Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
---

Hi,

The patch has been updated based on feedback recieved on the RFC[0].

Please consider merging if there are no objections.

Thanks,
Punit

[0] https://www.spinics.net/lists/linux-serial/msg36646.html

 drivers/tty/serdev/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 226adeec2aed..0d64fb7d4f36 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -663,6 +663,12 @@ static acpi_status acpi_serdev_register_device(struct serdev_controller *ctrl,
 	return AE_OK;
 }
 
+static const struct acpi_device_id serdev_blacklist_devices[] = {
+	{"INT3511", 0},
+	{"INT3512", 0},
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
+	if (!acpi_match_device_ids(adev, serdev_blacklist_devices))
+		return AE_OK;
+
 	if (acpi_serdev_check_resources(ctrl, adev))
 		return AE_OK;
 
-- 
2.24.0

