Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA3F4724CC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhLMJih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:38:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50770 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhLMJhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:37:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81FC5B80E2A;
        Mon, 13 Dec 2021 09:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2B1C341C8;
        Mon, 13 Dec 2021 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388234;
        bh=nga9DHVo8q8MCgESHlI9anqtSQZXirrH4/RBimp9ipw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH95bR0Y8wwUAdEZca/F8DHSOELUoGUctSLJcTaGmbcASuYlm9qTM1Pj5nu2GSQan
         SUm/xraRdWq+r+F3l2Rk8PSnIM5zXPQviOO0+KSOfeYGmqX19ZtBKGca3ZIOFZtF/w
         3+tNn9+qKUmjyyT6vsm1M68/cDQjbJObRQJjBhw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.14 04/53] HID: add USB_HID dependancy on some USB HID drivers
Date:   Mon, 13 Dec 2021 10:29:43 +0100
Message-Id: <20211213092928.500357786@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
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
@@ -198,7 +198,7 @@ config HID_CHICONY
 
 config HID_CORSAIR
 	tristate "Corsair devices"
-	depends on HID && USB && LEDS_CLASS
+	depends on USB_HID && LEDS_CLASS
 	---help---
 	Support for Corsair devices that are not fully compliant with the
 	HID standard.
@@ -448,7 +448,7 @@ config HID_LENOVO
 
 config HID_LOGITECH
 	tristate "Logitech devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -780,7 +780,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on HID
+	depends on USB_HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 


