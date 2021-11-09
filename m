Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51944A398
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbhKIB1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239358AbhKIBZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F05C061A82;
        Tue,  9 Nov 2021 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420192;
        bh=GH9Qs1FFLoYLFKb91c61seX5XaFN8KUN0rQbQAGHqyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO2y68b1tsoVofNUDAp6F9+oPaPRfIiEN62te4k8esa7S0z9EVumqLfOz9Ex5ypLw
         zxAp07x/edlGUt2QD8DeUqDYznDP0v0dcZcIX+CgrSB83hCSg4tVFTbKx2z/beksvl
         H2+xboCjNOhnLwbqqfxEQluqtnwfQ2VRdlwl0dbhhnIVv8MPx1uz9rFg8tOIAnm0WB
         4d5cjDNEx/2OijCMXwNRzJtullgDVEfyo1Gw08CZIthPGUd1z7s0zD6KXg7GTU5MAA
         2QFjwUEGug+q6SZfZMI2VmfGWCJRrhrPWxOxn50dB5Hjyg8lU25s4tY3BD2/Vs7Kq+
         oZxBSNXV832gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/30] ACPI: battery: Accept charges over the design capacity as full
Date:   Mon,  8 Nov 2021 20:09:07 -0500
Message-Id: <20211109010918.1192063-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Almeida <andrealmeid@collabora.com>

[ Upstream commit 2835f327bd1240508db2c89fe94a056faa53c49a ]

Some buggy firmware and/or brand new batteries can support a charge that's
slightly over the reported design capacity. In such cases, the kernel will
report to userspace that the charging state of the battery is "Unknown",
when in reality the battery charge is "Full", at least from the design
capacity point of view. Make the fallback condition accepts capacities
over the designed capacity so userspace knows that is full.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b719ab3090bb2..e4f1cb67ba127 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -187,7 +187,7 @@ static int acpi_battery_is_charged(struct acpi_battery *battery)
 		return 1;
 
 	/* fallback to using design values for broken batteries */
-	if (battery->design_capacity == battery->capacity_now)
+	if (battery->design_capacity <= battery->capacity_now)
 		return 1;
 
 	/* we don't do any sort of metric based on percentages */
-- 
2.33.0

