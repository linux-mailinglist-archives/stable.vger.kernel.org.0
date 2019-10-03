Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87AE7CA82C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390321AbfJCQWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390311AbfJCQWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B54B21783;
        Thu,  3 Oct 2019 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119750;
        bh=AMxdu2iAMkSh3XMhlH/qsHZK8WG69YqnxAMbGUcPvu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH4ZfRsDyPjkprbglfwG/qSqmbyNvI9+B/8XhFdatr+YTiK06dSEHqBp92bZyactY
         LcU6hWXV5DPaHtewPR1w5FaBy0l24xlp4t3R7vfm2YIBDPpviLw5hjBxxeUFnU36/a
         aWfaHSnaAasSx7P1ApVTE+Q5ycj0fEXo/hFGlMX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 179/211] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
Date:   Thu,  3 Oct 2019 17:54:05 +0200
Message-Id: <20191003154527.198767687@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.

ENOTSUPP is not supposed to be returned to userspace. This was found on an
OpenPower machine, where the RTC does not support set_alarm.

On that system, a clock_nanosleep(CLOCK_REALTIME_ALARM, ...) results in
"524 Unknown error 524"

Replace it with EOPNOTSUPP which results in the expected "95 Operation not
supported" error.

Fixes: 1c6b39ad3f01 (alarmtimers: Return -ENOTSUPP if no RTC device is present)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190903171802.28314-1-cascardo@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/alarmtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -676,7 +676,7 @@ static int alarm_timer_create(struct k_i
 	enum  alarmtimer_type type;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
@@ -794,7 +794,7 @@ static int alarm_timer_nsleep(const cloc
 	int ret = 0;
 
 	if (!alarmtimer_get_rtcdev())
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (flags & ~TIMER_ABSTIME)
 		return -EINVAL;


