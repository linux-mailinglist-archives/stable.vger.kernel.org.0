Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA5560A0
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfFZDnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfFZDnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:12 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B73E20883;
        Wed, 26 Jun 2019 03:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520591;
        bh=5rFNYZyvNdwrIOYTJ/UqqG+fqyrkLzHd4QdCCujhBts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/s0ISrpG/npDrHlgob0d9wpyxB2TYpKyqC1p5/abdJ9ELcFzkcqZfHCOfHeAjNsa
         5h+Oc+anlVfG97izM3YtCkR9fKBAP4cPTLRwcN4nYoW1eLUBtrTZOpPZI3m5A8ruuN
         3I78PmhaTUVNOgjeCMQOXoPEGZu6spB0ncoZAzxc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathew King <mathewk@chromium.org>,
        Jett Rink <jettrink@chromium.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 41/51] platform/x86: intel-vbtn: Report switch events when event wakes device
Date:   Tue, 25 Jun 2019 23:40:57 -0400
Message-Id: <20190626034117.23247-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathew King <mathewk@chromium.org>

[ Upstream commit cb1921b17adbe6509538098ac431033378cd7165 ]

When a switch event, such as tablet mode/laptop mode or docked/undocked,
wakes a device make sure that the value of the swich is reported.
Without when a device is put in tablet mode from laptop mode when it is
suspended or vice versa the device will wake up but mode will be
incorrect.

Tested by suspending a device in laptop mode and putting it in tablet
mode, the device resumes and is in tablet mode. When suspending the
device in tablet mode and putting it in laptop mode the device resumes
and is in laptop mode.

Signed-off-by: Mathew King <mathewk@chromium.org>
Reviewed-by: Jett Rink <jettrink@chromium.org>
Reviewed-by: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 06cd7e818ed5..a0d0cecff55f 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -76,12 +76,24 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	struct platform_device *device = context;
 	struct intel_vbtn_priv *priv = dev_get_drvdata(&device->dev);
 	unsigned int val = !(event & 1); /* Even=press, Odd=release */
-	const struct key_entry *ke_rel;
+	const struct key_entry *ke, *ke_rel;
 	bool autorelease;
 
 	if (priv->wakeup_mode) {
-		if (sparse_keymap_entry_from_scancode(priv->input_dev, event)) {
+		ke = sparse_keymap_entry_from_scancode(priv->input_dev, event);
+		if (ke) {
 			pm_wakeup_hard_event(&device->dev);
+
+			/*
+			 * Switch events like tablet mode will wake the device
+			 * and report the new switch position to the input
+			 * subsystem.
+			 */
+			if (ke->type == KE_SW)
+				sparse_keymap_report_event(priv->input_dev,
+							   event,
+							   val,
+							   0);
 			return;
 		}
 		goto out_unknown;
-- 
2.20.1

