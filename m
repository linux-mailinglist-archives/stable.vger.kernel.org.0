Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA420111F14
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfLCWnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfLCWnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412BE20803;
        Tue,  3 Dec 2019 22:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413009;
        bh=rbxxTSCTtzeyzH8V7lyMIsbwabxAb/eHcLvFhgCc4qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbHcKohSuswvpngSvke0bheUKOBtB9STruUlxzFLrwWCnpKjhU8K9AfJkcpFchB5f
         Q8aWPIVgaoVUPSwQeRDkTmui5giW4dT+mvvlxB3G+yRlSzW7nvqCjEubbI65IrQ09F
         NNLksugJu8c08iKp9agy+v4o20Ye2Ihv9Fd+lKlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.3 101/135] staging: rtl8723bs: Drop ACPI device ids
Date:   Tue,  3 Dec 2019 23:35:41 +0100
Message-Id: <20191203213039.442786172@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 2d9d2491530a156b9a5614adf9dc79285e35d55e upstream.

The driver only binds by SDIO device-ids, all the ACPI device-id does
is causing the driver to load unnecessarily on devices where the DSDT
contains a bogus OBDA8723 device.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111113846.24940-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -23,13 +23,7 @@ static const struct sdio_device_id sdio_
 	{ SDIO_DEVICE(0x024c, 0xb723), },
 	{ /* end: all zeroes */				},
 };
-static const struct acpi_device_id acpi_ids[] = {
-	{"OBDA8723", 0x0000},
-	{}
-};
-
 MODULE_DEVICE_TABLE(sdio, sdio_ids);
-MODULE_DEVICE_TABLE(acpi, acpi_ids);
 
 static int rtw_drv_init(struct sdio_func *func, const struct sdio_device_id *id);
 static void rtw_dev_remove(struct sdio_func *func);


