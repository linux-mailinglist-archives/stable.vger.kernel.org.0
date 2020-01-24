Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4618147D8A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbgAXKBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgAXKBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:01:32 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F635206D5;
        Fri, 24 Jan 2020 10:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860092;
        bh=qys4PTBg21yuijVxAzhvDQXXNLAkLmDpV3GE4iGs2Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkQsarKb5IqHOZ3aw4um9MJj70sKM+ETlpVCxA2SoY3MHNwS7Pp3LWRgEkd7jEgbA
         1FEbi270MADGWAbtScf2/SI+RuTC0rl8TWx84scG8YzaBBkvzELqrbVCGOKO8TSYdx
         VYaa0O5ybvGqObMDhOHo6nufD8rea+V+73thcX/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 256/343] PM: sleep: Fix possible overflow in pm_system_cancel_wakeup()
Date:   Fri, 24 Jan 2020 10:31:14 +0100
Message-Id: <20200124092953.735890345@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
index df53e2b3296b4..877b2a1767a5a 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -877,7 +877,7 @@ EXPORT_SYMBOL_GPL(pm_system_wakeup);
 
 void pm_system_cancel_wakeup(void)
 {
-	atomic_dec(&pm_abort_suspend);
+	atomic_dec_if_positive(&pm_abort_suspend);
 }
 
 void pm_wakeup_clear(bool reset)
-- 
2.20.1



