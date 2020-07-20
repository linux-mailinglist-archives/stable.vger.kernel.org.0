Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57422697D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgGTQ0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732340AbgGTP77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5C722CAF;
        Mon, 20 Jul 2020 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260799;
        bh=WvytojH2IH+WuRea9tphH3q+Rxcve4U2HgOws2wIJWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ60EqCH8yJKbMnJXEx/bBfDECmFjbLy9KsHYaXI1q8yxPSdurCwkPI8KqTZcaTIj
         UgXwSR1unvHoo1dKMElkQIIx3N8fotnksmchZV0Dzw94KwkAEfNIC0OhwkctVQlmA7
         bBZcgY0OnBZF/WtQCvrQgxBRZmQzubL3H13a4ZmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/215] HID: quirks: Remove ITE 8595 entry from hid_have_special_driver
Date:   Mon, 20 Jul 2020 17:35:52 +0200
Message-Id: <20200720152823.545485689@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3045696d0ce663d67c95dcb8206d3de57f6841ec ]

The ITE 8595 chip used in various 2-in-1 keyboard docks works fine with
the hid-generic driver (minus the RF_KILL key) and also keeps working fine
when swapping drivers, so there is no need to have it in the
hid_have_special_driver list.

Note the other 2 USB ids in hid-ite.c were never added to
hid_have_special_driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 168fdaa1999fe..70c72b33d35e2 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -400,9 +400,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2) },
 #endif
-#if IS_ENABLED(CONFIG_HID_ITE)
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
-#endif
 #if IS_ENABLED(CONFIG_HID_ICADE)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
 #endif
-- 
2.25.1



