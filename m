Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586C2FA51B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfKMByI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfKMByD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AFE72245A;
        Wed, 13 Nov 2019 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610043;
        bh=a09o/6erw4XFpEHbgbqRKQCSfOoCeDDbbaY/XHSBdzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEukpEYzKunXJSDQbD0bOWoW+sn+/orSLcj0vwWaf0ovcpNbwYjMhz1yfFUNH7Vif
         y3JrH5l00rBPKi4pOh/fnMlePp9n0P8kTXLOJYw1PfFgQ0Cnhdo8eyDdvgNdk4n7i+
         ajJkGAbloMP629xih+mp6ORpgApIZnUJbCv26/Sw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 133/209] ACPI / SBS: Fix rare oops when removing modules
Date:   Tue, 12 Nov 2019 20:49:09 -0500
Message-Id: <20191113015025.9685-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronald Tschalär <ronald@innovation.ch>

[ Upstream commit 757c968c442397f1249bb775a7c8c03842e3e0c7 ]

There was a small race when removing the sbshc module where
smbus_alarm() had queued acpi_smbus_callback() for deferred execution
but it hadn't been run yet, so that when it did run hc had been freed
and the module unloaded, resulting in an invalid paging request.

A similar race existed when removing the sbs module with regards to
acpi_sbs_callback() (which is called from acpi_smbus_callback()).

We therefore need to ensure no callbacks are pending or executing before
the cleanups are done and the modules are removed.

Signed-off-by: Ronald TschalÃ¤r <ronald@innovation.ch>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osl.c   | 1 +
 drivers/acpi/sbshc.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index ed73f6fb0779b..b48874b8e1ea0 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1132,6 +1132,7 @@ void acpi_os_wait_events_complete(void)
 	flush_workqueue(kacpid_wq);
 	flush_workqueue(kacpi_notify_wq);
 }
+EXPORT_SYMBOL(acpi_os_wait_events_complete);
 
 struct acpi_hp_work {
 	struct work_struct work;
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index 7a3431018e0ab..5008ead4609a4 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -196,6 +196,7 @@ int acpi_smbus_unregister_callback(struct acpi_smb_hc *hc)
 	hc->callback = NULL;
 	hc->context = NULL;
 	mutex_unlock(&hc->lock);
+	acpi_os_wait_events_complete();
 	return 0;
 }
 
@@ -292,6 +293,7 @@ static int acpi_smbus_hc_remove(struct acpi_device *device)
 
 	hc = acpi_driver_data(device);
 	acpi_ec_remove_query_handler(hc->ec, hc->query_bit);
+	acpi_os_wait_events_complete();
 	kfree(hc);
 	device->driver_data = NULL;
 	return 0;
-- 
2.20.1

