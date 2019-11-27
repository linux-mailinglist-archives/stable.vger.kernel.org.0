Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA4810B836
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfK0UlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbfK0UlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:41:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D8621787;
        Wed, 27 Nov 2019 20:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887263;
        bh=qpOfe/n+XafqdA3bd277vvX9ZgxGKO9nKXTsAQ4Xcxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIvQiTdiw0n+8J+79ByihWggdYBKtTRRaJdBqdBXXslMlSyRW+rNKc0cXjDkyID1x
         D7W5gXQnBap+8QZi0mhQ1K7lb6C3dl/aaCOQf5mc02XitCVqTb032Rw3p3fxKCwtE/
         sUmv4Xj6y4riUmrD6sxjcKZ0CriJXh+froKNl3gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mattias Jacobsson <2pi@mok.nu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 043/151] USB: misc: appledisplay: fix backlight update_status return code
Date:   Wed, 27 Nov 2019 21:30:26 +0100
Message-Id: <20191127203027.261800350@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b8092bcf89a29..140af7754c1e6 100644
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



