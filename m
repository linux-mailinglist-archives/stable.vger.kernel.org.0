Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACEBF54D7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbfKHSza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387504AbfKHSz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B91120865;
        Fri,  8 Nov 2019 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239321;
        bh=+3VcyUp/A4wUfZUTyKpsRPmiL8cfFBaBUdLzuwzK3r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLwWwbLYp6Sr/3M/NwfJ+0f01aa785aMArt7q0NC7n8GcSrYasKQzLKPWnC5h2yd1
         66pPxyNJ65N8Xs+zBF7oYyUzm3eX2K5p83h5zKQO/sipuyUPeDjn++NfD/TbALU+5I
         M1cO/Hrysj+2dogTj1/V3iCnHUHp919xsFFvDzeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Petr Vorel <pvorel@suse.cz>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.4 74/75] alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP
Date:   Fri,  8 Nov 2019 19:50:31 +0100
Message-Id: <20191108174813.354911623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <pvorel@suse.cz>

Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.

Update backport to change ENOTSUPP to EOPNOTSUPP in
alarm_timer_{del,set}(), which were removed in
f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.

Fixes: c22df8ea7c5831d6fdca2f6f136f0d32d7064ff9

Signed-off-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -573,7 +573,7 @@ static void alarm_timer_get(struct k_iti
 static int alarm_timer_del(struct k_itimer *timr)
 {
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
 		return TIMER_RETRY;
@@ -597,7 +597,7 @@ static int alarm_timer_set(struct k_itim
 	ktime_t exp;
 
 	if (!rtcdev)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;


