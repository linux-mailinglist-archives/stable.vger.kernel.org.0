Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2686213E6B3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391247AbgAPRRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391242AbgAPRRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:17:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F0D32051A;
        Thu, 16 Jan 2020 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195055;
        bh=bH2Qc2xCK/qCMgBfXfFwb99YTiO2dHrcA5sxfHP6jLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjZpEV+udAD4zUjXnZU25etOZFmOxmNrg/FJlKOUcahroNH5ZznO1/Ow013K55I1s
         +TOkFmUdL7p9Vf2+ffTPdbANWbrbOq3z+wWjxoPv7BciFbkFE6LbwIfqnnJusTkgh1
         hy7m8lK1T4dkNmGuGSgfjSjwBe5puDezqxGctZUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 012/371] pwm: lpss: Release runtime-pm reference from the driver's remove callback
Date:   Thu, 16 Jan 2020 12:11:20 -0500
Message-Id: <20200116171719.16965-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 42885551cedb45961879d2fc3dc3c4dc545cc23e ]

For each pwm output which gets enabled through pwm_lpss_apply(), we do a
pm_runtime_get_sync().

This commit adds pm_runtime_put() calls to pwm_lpss_remove() to balance
these when the driver gets removed with some of the outputs still enabled.

Fixes: f080be27d7d9 ("pwm: lpss: Add support for runtime PM")
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lpss.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
index 1e69c1c9ec09..7a4a6406cf69 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -216,6 +216,12 @@ EXPORT_SYMBOL_GPL(pwm_lpss_probe);
 
 int pwm_lpss_remove(struct pwm_lpss_chip *lpwm)
 {
+	int i;
+
+	for (i = 0; i < lpwm->info->npwm; i++) {
+		if (pwm_is_enabled(&lpwm->chip.pwms[i]))
+			pm_runtime_put(lpwm->chip.dev);
+	}
 	return pwmchip_remove(&lpwm->chip);
 }
 EXPORT_SYMBOL_GPL(pwm_lpss_remove);
-- 
2.20.1

