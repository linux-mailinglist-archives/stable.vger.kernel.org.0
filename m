Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC54512A1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbhKOTiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244933AbhKOTSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E06F6342E;
        Mon, 15 Nov 2021 18:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000739;
        bh=UsCMY0vPhkfnNm4ouVzXAVYprKlsfPZLk37GB5JhQeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltMeuAmY7naaHlryIa5VMzDvA1A+vPu/Nt1/YhSD3lQq5xgQb8kgTsX708xhSh33N
         M6AbuR2aePkVEim5Md9QZbv3LRquMa8K9TOXtb6Yk/O2nME3wHehxreubJHz9bAGrv
         kJLU/xehcwcR8NoMUB8j9yI7xhjZLfw87GtKXpyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 746/849] ACPI: PM: Fix device wakeup power reference counting error
Date:   Mon, 15 Nov 2021 18:03:49 +0100
Message-Id: <20211115165445.493088465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index e1f9a45587857..36c554a1cfbf4 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -746,13 +746,11 @@ int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 
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



