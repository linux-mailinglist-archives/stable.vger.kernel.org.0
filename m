Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50664451E50
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbhKPAfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344795AbhKOTZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E28B636CD;
        Mon, 15 Nov 2021 19:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003080;
        bh=C5KlOM06aDrXkjQMDAH/Vv4QLT/zPeDYzbgxtDwTwMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BrU13mj6DRdZfc9iqjbMKNrlQoHDuUowCwhoYeveE8SbWwmTPxDBVaQJoRzropUU9
         hwMMa2d8yxdu9nzGSBznULo9cslCZpRmXYVc/y5rJt//OmPHOp6mGpQQwkIgWJHV4Y
         f87g1AJN5+UQs8AlwS2JJSQ4Jbn9Dx2vETtJ77OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 802/917] ACPI: PM: Fix device wakeup power reference counting error
Date:   Mon, 15 Nov 2021 18:04:57 +0100
Message-Id: <20211115165456.170065434@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 452a3e723f75880757acf87b053935c43aa89f89 ]

Fix a device wakeup power reference counting error introduced by
commit a2d7b2e004af ("ACPI: PM: Fix sharing of wakeup power
resources") because of a coding mistake.

Fixes: a2d7b2e004af ("ACPI: PM: Fix sharing of wakeup power resources")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 4b42debeed455..c95eedd58f5bf 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -755,13 +755,11 @@ int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 
 	mutex_lock(&acpi_device_lock);
 
-	if (dev->wakeup.prepare_count > 1) {
-		dev->wakeup.prepare_count--;
+	/* Do nothing if wakeup power has not been enabled for this device. */
+	if (dev->wakeup.prepare_count <= 0)
 		goto out;
-	}
 
-	/* Do nothing if wakeup power has not been enabled for this device. */
-	if (!dev->wakeup.prepare_count)
+	if (--dev->wakeup.prepare_count > 0)
 		goto out;
 
 	err = acpi_device_sleep_wake(dev, 0, 0, 0);
-- 
2.33.0



