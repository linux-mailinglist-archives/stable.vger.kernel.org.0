Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8226FA47E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbfKMB4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfKMB4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13AFB222CF;
        Wed, 13 Nov 2019 01:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610161;
        bh=eO+zh+1hDJrf6kovEjttSsvpTV1BbphILcEKLCmqexY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQmw5lFI75CTde7M5OHUJ4vMBvBFR9+cRLJbanIXgWQOfl+Zt74vFKlsIEU/i1QJV
         Dtm+Caq71lQQAyff7Nez4neYUOBvAmhkO9mvyEg4LzXaESqxHZc3FVG7iJx9g8iEK7
         REs2aF2SR4mGtOfzD/hIigiQl2JUinmo4XAY5Jdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 204/209] ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for hibernate
Date:   Tue, 12 Nov 2019 20:50:20 -0500
Message-Id: <20191113015025.9685-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c8afd03486c26accdda4846e5561aa3f8e862a9d ]

Commit 48402cee6889 ("ACPI / LPSS: Resume BYT/CHT I2C controllers from
resume_noirq") makes acpi_lpss_{suspend_late,resume_early}() bail early
on BYT/CHT as resume_from_noirq is set.

This means that on resume from hibernate dw_i2c_plat_resume() doesn't get
called by the restore_early callback, acpi_lpss_resume_early(). Instead it
should be called by the restore_noirq callback matching how things are done
when resume_from_noirq is set and we are doing a regular resume.

Change the restore_noirq callback to acpi_lpss_resume_noirq so that
dw_i2c_plat_resume() gets properly called when resume_from_noirq is set
and we are resuming from hibernate.

Likewise also change the poweroff_noirq callback so that
dw_i2c_plat_suspend gets called properly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202139
Fixes: 48402cee6889 ("ACPI / LPSS: Resume BYT/CHT I2C controllers from resume_noirq")
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index c47bc6c7f4b91..a63285f9cbca1 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -1121,8 +1121,8 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
 		.thaw_noirq = acpi_subsys_thaw_noirq,
 		.poweroff = acpi_subsys_suspend,
 		.poweroff_late = acpi_lpss_suspend_late,
-		.poweroff_noirq = acpi_subsys_suspend_noirq,
-		.restore_noirq = acpi_subsys_resume_noirq,
+		.poweroff_noirq = acpi_lpss_suspend_noirq,
+		.restore_noirq = acpi_lpss_resume_noirq,
 		.restore_early = acpi_lpss_resume_early,
 #endif
 		.runtime_suspend = acpi_lpss_runtime_suspend,
-- 
2.20.1

