Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26E3FEE06
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbfKPPs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:48:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbfKPPs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:27 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73282086A;
        Sat, 16 Nov 2019 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919307;
        bh=EAxCQth2ZKk/kGjhKRAbSAUj7vT5Dv3HrY5a2a8j1CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0pmk9HOa1QWcwzEW/U34jHBn98cZAU0FRjUmCvYoDFhdR3bVHgRtc8wGkFbAUu/Q
         zF69HSKHD03ghfDFZ45Sbb2qCT9ZITWykx7daQ93UE1MAnM3ceo8akHzoMR5xw9MCj
         1db1s5NoUUilBI5rnavhEBOKH2+5I92m2q0pJg8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mattias Jacobsson <2pi@mok.nu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 050/150] USB: misc: appledisplay: fix backlight update_status return code
Date:   Sat, 16 Nov 2019 10:45:48 -0500
Message-Id: <20191116154729.9573-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattias Jacobsson <2pi@mok.nu>

[ Upstream commit 090158555ff8d194a98616034100b16697dd80d0 ]

Upon success the update_status handler returns a positive number
corresponding to the number of bytes transferred by usb_control_msg.
However the return code of the update_status handler should indicate if
an error occurred(negative) or how many bytes of the user's input to sysfs
that was consumed. Return code zero indicates all bytes were consumed.

The bug can for example result in the update_status handler being called
twice, the second time with only the "unconsumed" part of the user's input
to sysfs. Effectively setting an incorrect brightness.

Change the update_status handler to return zero for all successful
transactions and forward usb_control_msg's error code upon failure.

Signed-off-by: Mattias Jacobsson <2pi@mok.nu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/appledisplay.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 03be7c75c5be7..3b59eaf81eefc 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -160,8 +160,11 @@ static int appledisplay_bl_update_status(struct backlight_device *bd)
 		pdata->msgdata, 2,
 		ACD_USB_TIMEOUT);
 	mutex_unlock(&pdata->sysfslock);
-	
-	return retval;
+
+	if (retval < 0)
+		return retval;
+	else
+		return 0;
 }
 
 static int appledisplay_bl_get_brightness(struct backlight_device *bd)
-- 
2.20.1

