Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C1847243A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhLMJfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:35:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbhLMJeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA963B80E18;
        Mon, 13 Dec 2021 09:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB9FC00446;
        Mon, 13 Dec 2021 09:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388055;
        bh=79G5Hb5JrOLbAK8UOK4nUp4oZX4ewHMC3bFakq46Fxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JE4ImKelAG36juRhw2r3C+GxU9vN4UqhmQvB7P9WyGYY5X1NJ4WVt+93IuZZdodk9
         4csPLfzflQ6lpUenM8+ucNmiaudq9F1jYsKaIBej+OGm7xnBHMRB8S8UUtcF7DGJY8
         bccUTaMqLtnK49/8700XRIrlvqrx8mlTb0ss4OPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.9 05/42] HID: add USB_HID dependancy on some USB HID drivers
Date:   Mon, 13 Dec 2021 10:29:47 +0100
Message-Id: <20211213092926.748687063@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f237d9028f844a86955fc9da59d7ac4a5c55d7d5 upstream.

Some HID drivers are only for USB drivers, yet did not depend on
CONFIG_USB_HID.  This was hidden by the fact that the USB functions were
stubbed out in the past, but now that drivers are checking for USB
devices properly, build errors can occur with some random
configurations.

Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211202114819.2511954-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -183,7 +183,7 @@ config HID_CHICONY
 
 config HID_CORSAIR
 	tristate "Corsair devices"
-	depends on HID && USB && LEDS_CLASS
+	depends on USB_HID && LEDS_CLASS
 	---help---
 	Support for Corsair devices that are not fully compliant with the
 	HID standard.
@@ -421,7 +421,7 @@ config HID_LENOVO
 
 config HID_LOGITECH
 	tristate "Logitech devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -730,7 +730,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on HID
+	depends on USB_HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 


