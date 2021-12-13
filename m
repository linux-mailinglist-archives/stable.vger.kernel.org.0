Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53B47240A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhLMJdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbhLMJd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:33:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCB7C061A72;
        Mon, 13 Dec 2021 01:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F5B6CE0E6B;
        Mon, 13 Dec 2021 09:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2B6C341C5;
        Mon, 13 Dec 2021 09:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388003;
        bh=u2W6cyixXsLNkpvsnRYeGVTcZBqqVQfwTdOFWZ7Kn+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieESoRfrmEhGT+B5oZGPkQ8T5Mp6uX0XnJLOqhxw/uGGVn5NIH/3ZIqlAu18+A6bI
         rSXKSDX15sh/zT+R9kdjdQxude5VNfvGsykmP4wZaAnQq0xFlkLu8e+g1284vvZQob
         QsfalNlYJDvXS/2f50EAFVE1tLjr4XxmQk941YKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.4 05/37] HID: add USB_HID dependancy on some USB HID drivers
Date:   Mon, 13 Dec 2021 10:29:43 +0100
Message-Id: <20211213092925.552892634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
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
@@ -173,7 +173,7 @@ config HID_CHICONY
 
 config HID_CORSAIR
 	tristate "Corsair devices"
-	depends on HID && USB && LEDS_CLASS
+	depends on USB_HID && LEDS_CLASS
 	---help---
 	Support for Corsair devices that are not fully compliant with the
 	HID standard.
@@ -389,7 +389,7 @@ config HID_LENOVO
 
 config HID_LOGITECH
 	tristate "Logitech devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -693,7 +693,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on HID
+	depends on USB_HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 


