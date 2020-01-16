Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB413F412
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389805AbgAPRKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389800AbgAPRJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB15E2081E;
        Thu, 16 Jan 2020 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194598;
        bh=eS8mU3QIA0TBXe9Uxh91D1mjEfC0CK2I4ipAljZKsLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHe2yCUo03r9DVV9OR+QMC9NxqzVi8klYDBioAYSF6oyPFRYUdmbXUOnk8ftAGzKt
         FIA5X36eOJSXh2NCKNHdPVzR/uODwrMqDGB+IEaooo8U5TLiV6jCBlZlxT0BIOXeqa
         /adMn1qV8wplHBF5+6WknUdz+RpT6Ya14urI2Wng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 467/671] PM: sleep: Fix possible overflow in pm_system_cancel_wakeup()
Date:   Thu, 16 Jan 2020 12:01:45 -0500
Message-Id: <20200116170509.12787-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2933954b71f10d392764f95eec0f0aa2d103054b ]

It is not actually guaranteed that pm_abort_suspend will be
nonzero when pm_system_cancel_wakeup() is called which may lead to
subtle issues, so make it use atomic_dec_if_positive() instead of
atomic_dec() for the safety sake.

Fixes: 33e4f80ee69b ("ACPI / PM: Ignore spurious SCI wakeups from suspend-to-idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 7c84f64c74f7..2dfa2e048745 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -875,7 +875,7 @@ EXPORT_SYMBOL_GPL(pm_system_wakeup);
 
 void pm_system_cancel_wakeup(void)
 {
-	atomic_dec(&pm_abort_suspend);
+	atomic_dec_if_positive(&pm_abort_suspend);
 }
 
 void pm_wakeup_clear(bool reset)
-- 
2.20.1

