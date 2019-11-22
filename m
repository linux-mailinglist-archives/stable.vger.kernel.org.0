Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC15106E9C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKVLKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbfKVLC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:02:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFED207FC;
        Fri, 22 Nov 2019 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420549;
        bh=a09o/6erw4XFpEHbgbqRKQCSfOoCeDDbbaY/XHSBdzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdG8v2qUylOII/2rdoabh1vJQliV8KrNTXbXZq7lzY/Z3htV+JvXKz5p43dDjBQuD
         10I4UYsXoTeoDfyG6EzafjZXvJ6E4TxCTKu4As0n0eUxwyAnDRriEo+U9yA2ds7QUZ
         2UU2o6WUTOqOO7cAHw24tz+1q75lsAwSENsKqNRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ronald=20Tschal=C3=83=C2=A4r?= <ronald@innovation.ch>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/220] ACPI / SBS: Fix rare oops when removing modules
Date:   Fri, 22 Nov 2019 11:28:29 +0100
Message-Id: <20191122100923.126452267@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



