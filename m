Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718F91133C8
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfLDSHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfLDSHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:30 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BED20674;
        Wed,  4 Dec 2019 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482849;
        bh=/9WXowLFlknbzCAJ8vgHVsnC58Tpx+wZ+ZMD/tq+Oko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgZcqGUBSwhCqUg5WsVo2urrFky074jpZlNOCHPXBMqcR1jxIYRhJ+e372Hmm56gz
         A0shFcLsxmZYpmrWeo8EMFxCGWK1E22PbLoki03Ap3lJh9DL9M5f/wxSMHMhtFN3pI
         4mxvK43n4jxMMN+5UYMXzRvmYcwW0tJk+7QFPHu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.14 159/209] staging: rtl8723bs: Drop ACPI device ids
Date:   Wed,  4 Dec 2019 18:56:11 +0100
Message-Id: <20191204175334.429038945@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
@@ -30,13 +30,7 @@ static const struct sdio_device_id sdio_
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


