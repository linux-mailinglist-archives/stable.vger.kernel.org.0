Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946FD622A4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389080AbfGHP1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389074AbfGHP1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:27:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC4920665;
        Mon,  8 Jul 2019 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599652;
        bh=lpF8smmZKzXzIFKYhBNQHTJe28GZk9w9HrrXxBl46x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBHQ3cOk9QBAx5/l8LNXw8XZ4+WU7Bq2dznqgtd+nh90RubdrYSC+At3znnkD6xfd
         hgXpV0lef/x8slvjJQBk0yuF73K9kGlN9JjtLUWRPCsxm0j2fCObJqCdGNhMNsGOMW
         YlbRKMXCxU2n8rnn2qM7w/iV41Oqbu1aem61DRB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathew King <mathewk@chromium.org>,
        Jett Rink <jettrink@chromium.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/90] platform/x86: intel-vbtn: Report switch events when event wakes device
Date:   Mon,  8 Jul 2019 17:12:57 +0200
Message-Id: <20190708150524.134124013@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



