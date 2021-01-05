Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6141F2EA441
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 05:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbhAEEIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 23:08:19 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:42806 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbhAEEIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 23:08:19 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2EF474017C;
        Tue,  5 Jan 2021 04:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609819639; bh=g0RabAfp5Y9ySM1+ZobHfBfFqD33KoVQm2dq3PgktB8=;
        h=Date:From:Subject:To:Cc:From;
        b=TPkQ94VfOsSMUt6wVoVbIUPLNpcurDRrUZhuWNJqFaLT/g+M0Lv89YNc0HGfJNgTE
         o2MyeOldDfI20Dw3qcKDkSj3DEC1IqgDD9E3razikbX8FBv9ZD33cyrn/7/RMK6ZL0
         oi17mQOmYNkxrB+RSp1tkb9yl2lBnXU/Cyo5i0m17lV2GUmUQOISQDl1bV2Oogy5be
         URpMwarhXdQrtE+1fqtHvBVg5xxOFFlqnthDKgfg7MWZgS/ruMIt2laGfI6DJfGvsX
         eLlSo7CoemoqD66jrXl9zF1P4X7gatCluumLu+RuZrwkyR1q0QJPqbZ+1pKySWwOwr
         0qdl3Fnta2A8Q==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id F2484A0250;
        Tue,  5 Jan 2021 04:07:15 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 04 Jan 2021 20:07:15 -0800
Date:   Mon, 04 Jan 2021 20:07:15 -0800
Message-Id: <2edc7af892d0913bf06f5b35e49ec463f03d5ed8.1609819418.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: uas: Add PNY USB Portable SSD to unusual_uas
To:     Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        usb-storage@lists.one-eyed-alien.net
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here's another variant PNY Pro Elite USB 3.1 Gen 2 portable SSD that
hangs and doesn't respond to ATA_1x pass-through commands. If it doesn't
support these commands, it should respond properly to the host. Add it
to the unusual uas list to be able to move forward with other
operations.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 870e9cf3d5dc..f9677a5ec31b 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -90,6 +90,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
+UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
+		"PNY",
+		"Pro Elite SSD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
 		"PNY",

base-commit: 5c8fe583cce542aa0b84adc939ce85293de36e5e
-- 
2.28.0

