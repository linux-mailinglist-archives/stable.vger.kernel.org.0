Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D603B14B783
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgA1OPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgA1OPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C9224690;
        Tue, 28 Jan 2020 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220903;
        bh=AY5I3G/sSJ5Yo3Y/16lP/7IScq0UkAUvk+3O1nOwWTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muXsIHX67A7aQNt8XWbWehhdqexuU9mu6CDP76JM9bng8+FP5sQkqYaTEPJkqUGg0
         19fDYTQ4RmaP/DARftP9N4JmhPvwzDw7ssnwoXHwTuM0+bkEU8uZNF4AM0B1so9TS/
         PnS14hyNRQXt6MyQBUamUqMsFhWhyfmOga+y+6JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 010/271] pwm: lpss: Release runtime-pm reference from the drivers remove callback
Date:   Tue, 28 Jan 2020 15:02:39 +0100
Message-Id: <20200128135853.181673753@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5208b3f80ad85..239003807c085 100644
--- a/drivers/pwm/pwm-lpss.c
+++ b/drivers/pwm/pwm-lpss.c
@@ -205,6 +205,12 @@ EXPORT_SYMBOL_GPL(pwm_lpss_probe);
 
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



