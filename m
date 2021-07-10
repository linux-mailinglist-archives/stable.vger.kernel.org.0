Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A3D3C379D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhGJXwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232566AbhGJXw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A6D61356;
        Sat, 10 Jul 2021 23:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960980;
        bh=xWCCHaF5NQH3bwlPXq7cZGPq7DcVswBFm6vzcPVvN44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWgUY7i1s91KbKVaEbPNvcnuN1IGvil/eOkNQ3s9MjG/82WfAyHL4WDH/b1KK4MtQ
         qIy0mw8GT4qXrWefmzyO53EVKmI+MFbkShVwOxLU8nDIz42NmX/K/iSGRvtu0coxSx
         KQY8lhruMq5TjFDpH5pRcfPeDO+n9NZ/Ro+Fy1p986OReRGxF2VEMUy0mi6poZ7Tam
         o2vCjmP8kS5+5IXN8St3JBt75bU2D7qllOFcx3NghGZAHYgs2ODCbx0Rfc3zUB+V8T
         WL0Cf+wKVzC4RNjQra74ObFzsIitOCrgRD418GHlx60yw+B9d9wFvocxMt6K0o9M29
         0HsOIhGXwkIqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 16/43] watchdog: sc520_wdt: Fix possible use-after-free in wdt_turnoff()
Date:   Sat, 10 Jul 2021 19:48:48 -0400
Message-Id: <20210710234915.3220342-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 90b7c141132244e8e49a34a4c1e445cce33e07f4 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1620716691-108460-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sc520_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index e66e6b905964..ca65468f4b9c 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -186,7 +186,7 @@ static int wdt_startup(void)
 static int wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	/* Stop the watchdog */
 	wdt_config(0);
-- 
2.30.2

