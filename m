Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE2106E1D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfKVLGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731827AbfKVLGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05FF42075E;
        Fri, 22 Nov 2019 11:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420776;
        bh=omy4etwwr7CNjSz7GlHf580AUNLJFjAUQ8HjxqEHb1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vy7yAERn99IJrAp621W8nCRKLEfbXi04gSkUDFarEo7neogJ3mv8hceBV+r14zqGX
         b2BZ+lHzFO4eddWZoeUOmx+Ag2MtUkhnl9s4hmDeJ++Qc8UIvcEEy/Q6lvh/CaN7Gn
         WqLDCEetLtLQTvkv4UwgkwF/jBqQKnujb2cUgRhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 215/220] ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for hibernate
Date:   Fri, 22 Nov 2019 11:29:40 +0100
Message-Id: <20191122100929.111123338@linuxfoundation.org>
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
index dec9024fc49ec..b21c241aaab9f 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -1139,8 +1139,8 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
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



