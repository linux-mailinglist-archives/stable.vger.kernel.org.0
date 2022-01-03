Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170AA483257
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiACO1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiACO0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D693C06179B;
        Mon,  3 Jan 2022 06:26:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF4CDCE1106;
        Mon,  3 Jan 2022 14:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA96EC36AED;
        Mon,  3 Jan 2022 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219977;
        bh=zzCY/fEsYqpMS+9mtH68nU1cAYzNk5ELATqcEm9U5P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixkm0Er+zBFLoxoNp/kEZc3+8YmUjXGCy6X7qNatDpvaBAsviY/Gv1J039H1jD2ak
         h8UrVmm0/FAQaukiFRvc/TthNBXFsRYpg3JDCuwiGltTom8I8bSxzVhWVGYAaFZOyT
         VM0jMfxR9jv4Kkk59beUlf54O9i6hzsxd8AebMu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Self <jason@bluehome.net>
Subject: [PATCH 5.4 01/37] HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option
Date:   Mon,  3 Jan 2022 15:23:39 +0100
Message-Id: <20220103142051.930280444@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit c4f0126d487f3c68ab19ccb7c561e8fbf3ea2247 upstream.

Since commit 4bc43a421218 ("HID: asus: Add
hid_is_using_ll_driver(usb_hid_driver) check") the hid-asus.c depends
on the usb_hid_driver symbol. Add a depends on USB_HID to Kconfig to
fix missing symbols errors in hid-asus when USB_HID is not enabled.

Fixes: 4bc43a421218 ("HID: asus: Add hid_is_using_ll_driver(usb_hid_driver) check")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Jason Self <jason@bluehome.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -149,6 +149,7 @@ config HID_APPLEIR
 
 config HID_ASUS
 	tristate "Asus"
+	depends on USB_HID
 	depends on LEDS_CLASS
 	depends on ASUS_WMI || ASUS_WMI=n
 	select POWER_SUPPLY


