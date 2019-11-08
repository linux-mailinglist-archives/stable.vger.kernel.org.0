Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5207F5034
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKHPvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:51:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:37340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfKHPvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 10:51:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B90B2AC81;
        Fri,  8 Nov 2019 15:51:23 +0000 (UTC)
From:   Petr Vorel <pvorel@suse.cz>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH v4.4-stable] alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP
Date:   Fri,  8 Nov 2019 16:51:16 +0100
Message-Id: <20191108155116.12896-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.

Update backport to change ENOTSUPP to EOPNOTSUPP in
alarm_timer_{del,set}(), which were removed in
f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.

Fixes: c22df8ea7c5831d6fdca2f6f136f0d32d7064ff9

Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
 kernel/time/alarmtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 70aef327b6e8..015d432bcb08 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -573,7 +573,7 @@ static void alarm_timer_get(struct k_itimer *timr,
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -597,7 +597,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	ktime_t exp;
 
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;
-- 
2.16.4

