Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6747273C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbhLMJ7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238543AbhLMJ44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB7AC09B057;
        Mon, 13 Dec 2021 01:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9859CE0E89;
        Mon, 13 Dec 2021 09:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0BFC00446;
        Mon, 13 Dec 2021 09:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388810;
        bh=+SCLD9UK3iOdmbcca8gQH5VRMG4w65O4cBrUe3qd9fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFTyshJTpX2FXpXyhkL7ayWOfV6i1SKtqHNNENffreDmBsoILnUMKIYS8kUSLwVup
         BdsBZVWaxp5ILu+Vaeo2q2nHR58Kjh2y/sUXlmmITaUVb0MpQ4FPHrNd/g6nYVacmL
         avSsEBsV/hMAmKXcqQTe0oIGUi5VBcdoUQUA7cJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.10 009/132] HID: add USB_HID dependancy on some USB HID drivers
Date:   Mon, 13 Dec 2021 10:29:10 +0100
Message-Id: <20211213092939.394120975@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -214,7 +214,7 @@ config HID_CHICONY
 
 config HID_CORSAIR
 	tristate "Corsair devices"
-	depends on HID && USB && LEDS_CLASS
+	depends on USB_HID && LEDS_CLASS
 	help
 	Support for Corsair devices that are not fully compliant with the
 	HID standard.
@@ -541,7 +541,7 @@ config HID_LENOVO
 
 config HID_LOGITECH
 	tristate "Logitech devices"
-	depends on HID
+	depends on USB_HID
 	depends on LEDS_CLASS
 	default !EXPERT
 	help
@@ -889,7 +889,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on HID
+	depends on USB_HID
 	help
 	Support for Samsung InfraRed remote control or keyboards.
 


