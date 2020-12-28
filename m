Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BEE2E3D8A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441242AbgL1OQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441236AbgL1OQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBCA207A9;
        Mon, 28 Dec 2020 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164964;
        bh=tabp5gX2tkCFcibSKiI8VWJhPIInDjw/Up4ucq/JRHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyTaS7HNZfKMaLICgqUrna7iqlkADQvraiouzOZmWUlG5GorY9KJmqM5yJ6j/5pw2
         5c4Je3Hxekz346QOdgSZiNhsMw8FZ/6fyY0T4fhuU6y2UeNxjuW+hjBu2FuFN51myz
         UJ7ZSckrwP9/W4zlL15htsXz6BrlvypEN+ZxUDws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/717] platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on some HP x360 models
Date:   Mon, 28 Dec 2020 13:45:42 +0100
Message-Id: <20201228125037.508636844@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a4327979a19e8734ddefbd8bcbb73bd9905b69cd ]

Some HP x360 models have an ACPI VGBS method which sets bit 4 instead of
bit 6 when NOT in tablet mode at boot. Inspecting all the DSDTs in my DSDT
collection shows only one other model, the Medion E1239T ever setting bit 4
and it always sets this together with bit 6.

So lets treat bit 4 as a second bit which when set indicates the device not
being in tablet-mode, as we already do for bit 6.

While at it also prefix all VGBS constant defines with "VGBS_".

Note this wrokaround was first added to the kernel as
commit d823346876a9 ("platform/x86: intel-vbtn: Fix SW_TABLET_MODE always
reporting 1 on the HP Pavilion 11 x360").
After commit 8169bd3e6e19 ("platform/x86: intel-vbtn: Switch to an
allow-list for SW_TABLET_MODE reporting") got added to the kernel this
was reverted, because with the new allow-list approach the workaround
was no longer necessary for the model on which the issue was first
reported.

But it turns out that the workaround is still necessary because some
affected models report a chassis-type of 31 which is on the allow-list.

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1894017
Fixes: 21d64817c724 ("platform/x86: intel-vbtn: Revert "Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360"")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 0419c8001fe33..123401f04b55a 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -15,9 +15,13 @@
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
 
+/* Returned when NOT in tablet mode on some HP Stream x360 11 models */
+#define VGBS_TABLET_MODE_FLAG_ALT	0x10
 /* When NOT in tablet mode, VGBS returns with the flag 0x40 */
-#define TABLET_MODE_FLAG 0x40
-#define DOCK_MODE_FLAG   0x80
+#define VGBS_TABLET_MODE_FLAG		0x40
+#define VGBS_DOCK_MODE_FLAG		0x80
+
+#define VGBS_TABLET_MODE_FLAGS (VGBS_TABLET_MODE_FLAG | VGBS_TABLET_MODE_FLAG_ALT)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("AceLan Kao");
@@ -72,9 +76,9 @@ static void detect_tablet_mode(struct platform_device *device)
 	if (ACPI_FAILURE(status))
 		return;
 
-	m = !(vgbs & TABLET_MODE_FLAG);
+	m = !(vgbs & VGBS_TABLET_MODE_FLAGS);
 	input_report_switch(priv->input_dev, SW_TABLET_MODE, m);
-	m = (vgbs & DOCK_MODE_FLAG) ? 1 : 0;
+	m = (vgbs & VGBS_DOCK_MODE_FLAG) ? 1 : 0;
 	input_report_switch(priv->input_dev, SW_DOCK, m);
 }
 
-- 
2.27.0



