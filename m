Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF12492E2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 04:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHSC1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 22:27:52 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56132 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726372AbgHSC1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 22:27:51 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0A7CC401AA;
        Wed, 19 Aug 2020 02:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1597804070; bh=QZEExHTjul/kr+pWOJMKovdVXYqInJHMRRAuQIgoA1I=;
        h=Date:From:Subject:To:Cc:From;
        b=cW5l80mWndzzq6Uvrir+3jOpyIy27aKZmH54xbB8WX7UtW0j3jjxG0vhm7MsH40QJ
         8/TapbOK0P4izjaUiwtAi8KthPZOdU8hITi4WGikoJBpwavdDqXCgqdIpbx3HM6GKh
         BofWB0BJz7YIOK45nEpkn7sXke88n354yY6OaZq4uGbLSholN5mIhAW/AC3cQzpjHI
         hAlGejQ0TqLWgIUXSH5Xo6WZoE7f3BGLYiir26NziQXhC8gKhrA+3jz4wcMFLkaxQT
         88GyFv3qnkzQx5iYtfnR4M0zMXD1+okP7EaiJ0x6lMDRXoRvBx1tNddv1B+hJZ0M6V
         bFCI3KSDWXe/Q==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A9D26A006B;
        Wed, 19 Aug 2020 02:27:47 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 18 Aug 2020 19:27:47 -0700
Date:   Tue, 18 Aug 2020 19:27:47 -0700
Message-Id: <2b0585228b003eedcc82db84697b31477df152e0.1597803605.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: uas: Add quirk for PNY Pro Elite
To:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        usb-storage@lists.one-eyed-alien.net
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PNY Pro Elite USB 3.1 Gen 2 device (SSD) doesn't respond to ATA_12
pass-through command (i.e. it just hangs). If it doesn't support this
command, it should respond properly to the host. Let's just add a quirk
to be able to move forward with other operations.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 162b09d69f62..971f8a4354c8 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -80,6 +80,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
+UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
+		"PNY",
+		"Pro Elite SSD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",

base-commit: d5643d2249b279077427b2c2b2ffae9b70c95b0b
-- 
2.28.0

