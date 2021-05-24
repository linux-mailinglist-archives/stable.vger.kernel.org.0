Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE538EBCF
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhEXPI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235117AbhEXPF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D559D61627;
        Mon, 24 May 2021 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867868;
        bh=sQiWuScMbxy9VtWXcBE5CITdHteElPRev8Hc9wVuDYg=;
        h=From:To:Cc:Subject:Date:From;
        b=BvVAt490x3CSmdxeS4Okss8CCsWxlngwQR9Fzaq8VvxmtaIXMZsi0g4xaA8+HVY1Z
         6ZFVjIezwJc/XHc9luLrhK2+T17GmgeruRapm9JvZhFIlxEtewh86/6h6OJ0tF410H
         hlztfU4243WIAO1vEX/GsP4t+dZTenzSxg6AdhZqgY1pStmK1rTbM6KblAaSRkKs0H
         k4n6ixEm8VR+UdZkHZLM8s5pxetOw4bLFmlrfnIkwlZQdUFKfTyu2g1oGxxMwl/Fs5
         cw2ZLT2Aa8CHmeuFRLzKVxnLXQ1OoegRdsCOpj54JFndQ3kwNGkD7ROdj2vOn9X/Ws
         a0/9bntzqHsMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@trempplin-utc.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/19] platform/x86: hp_accel: Avoid invoking _INI to speed up resume
Date:   Mon, 24 May 2021 10:50:48 -0400
Message-Id: <20210524145106.2499571-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 79d341e26ebcdbc622348aaaab6f8f89b6fdb25f ]

hp_accel can take almost two seconds to resume on some HP laptops.

The bottleneck is on evaluating _INI, which is only needed to run once.

Resolve the issue by only invoking _INI when it's necessary. Namely, on
probe and on hibernation restore.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Éric Piel <eric.piel@trempplin-utc.net>
Link: https://lore.kernel.org/r/20210430060736.590321-1-kai.heng.feng@canonical.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lis3lv02d/lis3lv02d.h |  1 +
 drivers/platform/x86/hp_accel.c    | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index c439c827eea8..0ef759671b54 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -284,6 +284,7 @@ struct lis3lv02d {
 	int			regs_size;
 	u8                      *reg_cache;
 	bool			regs_stored;
+	bool			init_required;
 	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index abd9d83f6009..403d966223ee 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -101,6 +101,9 @@ MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
 static int lis3lv02d_acpi_init(struct lis3lv02d *lis3)
 {
 	struct acpi_device *dev = lis3->bus_priv;
+	if (!lis3->init_required)
+		return 0;
+
 	if (acpi_evaluate_object(dev->handle, METHOD_NAME__INI,
 				 NULL, NULL) != AE_OK)
 		return -EINVAL;
@@ -366,6 +369,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	}
 
 	/* call the core layer do its init */
+	lis3_dev.init_required = true;
 	ret = lis3lv02d_init_device(&lis3_dev);
 	if (ret)
 		return ret;
@@ -413,11 +417,27 @@ static int lis3lv02d_suspend(struct device *dev)
 
 static int lis3lv02d_resume(struct device *dev)
 {
+	lis3_dev.init_required = false;
+	lis3lv02d_poweron(&lis3_dev);
+	return 0;
+}
+
+static int lis3lv02d_restore(struct device *dev)
+{
+	lis3_dev.init_required = true;
 	lis3lv02d_poweron(&lis3_dev);
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(hp_accel_pm, lis3lv02d_suspend, lis3lv02d_resume);
+static const struct dev_pm_ops hp_accel_pm = {
+	.suspend = lis3lv02d_suspend,
+	.resume = lis3lv02d_resume,
+	.freeze = lis3lv02d_suspend,
+	.thaw = lis3lv02d_resume,
+	.poweroff = lis3lv02d_suspend,
+	.restore = lis3lv02d_restore,
+};
+
 #define HP_ACCEL_PM (&hp_accel_pm)
 #else
 #define HP_ACCEL_PM NULL
-- 
2.30.2

