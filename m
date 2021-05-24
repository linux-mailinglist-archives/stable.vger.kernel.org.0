Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C31338EBC5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhEXPHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233438AbhEXPDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C5B61490;
        Mon, 24 May 2021 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867842;
        bh=TD042Atec4F9ZBJai4TbAhVmwzi2hnS8ajipd8FJQ0E=;
        h=From:To:Cc:Subject:Date:From;
        b=px53FX9yBvhL0rWs4iG87Lv0BdCDNayT0I4TBw1WDe0A5qI8jijATyjPt2g7MgzG7
         oj0EF/HHS21OXyU8HU+aDO9b0JtS02lbdBuJBDUerNv/Wj0Jzq+QsMQR7pjsf9crVm
         yVcJQnE/wJv1oiqx2myL5F8uVTqgJ4qGMeqtVX4lHo6qmLrjikYjDoq4GBAL5Jak/J
         aqO2OrcYiixY+NY7d61tNB8m7XTFDj7L2sZbvVjPHsp3xuXFCeBZ7I/T9L4XphaCxz
         cLZNGQYbdE686o0GjJVo8mpOcE/X2vcYqsZqZg10ec75G9F3sQFc5UCxzlixA1b+D+
         RPu3MQnRo1DbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@trempplin-utc.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/21] platform/x86: hp_accel: Avoid invoking _INI to speed up resume
Date:   Mon, 24 May 2021 10:50:20 -0400
Message-Id: <20210524145040.2499322-1-sashal@kernel.org>
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
index 7b12abe86b94..9c3c83ef445b 100644
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
@@ -367,6 +370,7 @@ static int lis3lv02d_add(struct acpi_device *device)
 	}
 
 	/* call the core layer do its init */
+	lis3_dev.init_required = true;
 	ret = lis3lv02d_init_device(&lis3_dev);
 	if (ret)
 		return ret;
@@ -414,11 +418,27 @@ static int lis3lv02d_suspend(struct device *dev)
 
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

