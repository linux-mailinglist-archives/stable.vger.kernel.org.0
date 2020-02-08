Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495D4156690
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBHS3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33862 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727786AbgBHS3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrH-0003dS-IH; Sat, 08 Feb 2020 18:29:35 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrG-000CMw-GZ; Sat, 08 Feb 2020 18:29:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chanwoo Choi" <cw00.choi@samsung.com>,
        "Leonard Crestez" <leonard.crestez@nxp.com>,
        "Matthias Kaehlcke" <mka@chromium.org>
Date:   Sat, 08 Feb 2020 18:19:55 +0000
Message-ID: <lsq.1581185940.187456453@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 056/148] PM / devfreq: Lock devfreq in trans_stat_show
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Leonard Crestez <leonard.crestez@nxp.com>

commit 2abb0d5268ae7b5ddf82099b1f8d5aa8414637d4 upstream.

There is no locking in this sysfs show function so stats printing can
race with a devfreq_update_status called as part of freq switching or
with initialization.

Also add an assert in devfreq_update_status to make it clear that lock
must be held by caller.

Fixes: 39688ce6facd ("PM / devfreq: account suspend/resume for stats")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -95,6 +95,7 @@ static int devfreq_update_status(struct
 	int lev, prev_lev, ret = 0;
 	unsigned long cur_time;
 
+	lockdep_assert_held(&devfreq->lock);
 	cur_time = jiffies;
 
 	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
@@ -1054,9 +1055,13 @@ static ssize_t trans_stat_show(struct de
 	int i, j;
 	unsigned int max_state = devfreq->profile->max_state;
 
+	mutex_lock(&devfreq->lock);
 	if (!devfreq->stop_polling &&
-			devfreq_update_status(devfreq, devfreq->previous_freq))
+			devfreq_update_status(devfreq, devfreq->previous_freq)) {
+		mutex_unlock(&devfreq->lock);
 		return 0;
+	}
+	mutex_unlock(&devfreq->lock);
 
 	len = sprintf(buf, "   From  :   To\n");
 	len += sprintf(buf + len, "         :");

